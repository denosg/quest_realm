import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/quest.dart';

import 'package:http/http.dart' as http;

class AccQuestItem {
  final String? id;
  final String title;
  final String description;
  final int points;
  final DateTime dateTime;

  AccQuestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.dateTime,
  });
}

class AccQuests with ChangeNotifier {
  List<AccQuestItem> _accQuests = [];
  final String? authToken;
  final String? userId;

  AccQuests(this.authToken, this.userId);

  List<AccQuestItem> get accQuests {
    return [..._accQuests];
  }

  Future<void> fetchAndSetAccQuests() async {
    if (authToken != null) {
      Uri url = Uri.parse(
          'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/accQuests/$userId.json?auth=$authToken');
      // gets the response from the server with the acc quests information
      final response = await http.get(url);
      final List<AccQuestItem> tempList = [];
      // saves the data as a map
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      // parses the information as it should and saves it locally in the memory
      extractedData.forEach((questId, questData) {
        tempList.add(AccQuestItem(
          id: questId,
          title: questData['title'],
          description: questData['description'],
          points: questData['points'],
          dateTime: DateTime.parse(questData['dateTime']),
        ));
      });
      // saves the quests in ascending order by date
      _accQuests = tempList.reversed.toList();
      notifyListeners();
    }
  }

  Future<void> addAccQuest(Quest accQuest) async {
    if (authToken != null) {
      Uri url = Uri.parse(
          'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/accQuests/$userId.json?auth=$authToken');
      final timeStamp = DateTime.now();
      // adds the accQuest in the web database
      final response = await http.post(url,
          body: json.encode({
            'title': accQuest.title,
            'description': accQuest.description,
            'points': accQuest.points,
            'dateTime': timeStamp.toIso8601String(),
          }));
      // adds the acc quest locally in the memory
      _accQuests.insert(
          0,
          AccQuestItem(
            id: json.decode(response.body)['name'],
            title: accQuest.title,
            description: accQuest.description,
            points: accQuest.points,
            dateTime: timeStamp,
          ));
    }
  }
}
