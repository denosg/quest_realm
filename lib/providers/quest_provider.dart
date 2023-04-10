import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../models/http_exception.dart' as mException;

import 'package:http/http.dart' as http;

class QuestProvider with ChangeNotifier {
  List<Quest> _items = [];

  final String? authToken;
  final String? userId;

  QuestProvider(this.authToken, this.userId);

  List<Quest> get items {
    return [..._items];
  }

  Quest findById(String id) {
    return _items.firstWhere((quest) => quest.id == id);
  }

  Future<void> fetchAndSetQuests([bool filterByUser = false]) async {
    // filter the quests for each user if filterByUser is true
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    // Gets the products based on userId (different products for each user)
    Uri url = Uri.parse(
        'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/quests.json?auth=$authToken&$filterString');
    try {
      //Gets the quests from the web server
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Quest> tempListQuest = [];
      if (extractedData == null) {
        return;
      }
      // Saves the data locally in memory in the _items
      extractedData.forEach((questId, questData) {
        tempListQuest.insert(
            0,
            Quest(
              id: questId,
              title: questData['title'],
              description: questData['description'],
              points: questData['points'],
            ));
      });
      _items = tempListQuest;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addQuest(Quest quest) async {
    // Send json data to server database
    Uri url = Uri.parse(
        'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/quests.json?auth=$authToken');
    try {
      //This registers as a 'TODO' function (loads at the end, async task)
      //Waits for this operation to finish before going to the next lines of code
      final response = await http.post(url,
          body: json.encode({
            'title': quest.title,
            'description': quest.description,
            'points': quest.points,
            'creatorId': userId,
          }));
      //json.decode(response.body)['name'] is the database provided id
      //The code below is wrapped in a .then() because of await
      final newQuest = Quest(
        id: json.decode(response.body)['name'],
        title: quest.title,
        description: quest.description,
        points: quest.points,
      );
      // Adds the quest locally in memory
      _items.insert(0, newQuest);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deteleQuest(String id) async {
    // Target the quest that we want to delete
    Uri url = Uri.parse(
        'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/quests/$id.json?auth=$authToken');
    final existingQuestIndex = _items.indexWhere((quest) => quest.id == id);
    Quest? existingQuest = _items[existingQuestIndex];
    // Removes from list, BUT not from memory
    _items.removeAt(existingQuestIndex);
    notifyListeners();
    // Reinserts in list if failed
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingQuestIndex, existingQuest);
      notifyListeners();
      throw mException.HttpException('Could not delete product');
    }
    existingQuest = null;
  }

  Future<void> updateQuest(String id, Quest newQuest) async {
    // Target the quest that we want to update
    Uri url = Uri.parse(
        'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/quests/$id.json?auth=$authToken');
    // Update the quest
    await http.patch(url,
        body: json.encode({
          'title': newQuest.title,
          'description': newQuest.description,
          'points': newQuest.points,
        }));

    final questIndex = _items.indexWhere((quest) => quest.id == id);
    if (questIndex > 0) {
      _items[questIndex] = newQuest;
      notifyListeners();
    }
  }
}
