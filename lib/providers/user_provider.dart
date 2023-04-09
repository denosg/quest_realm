import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/user.dart';

import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;
  final User _user = User('', '', '');

  UserProvider({required this.authToken, required this.userId});

  User get user {
    return _user;
  }

  Future<void> fetchUserInfo() async {
    // gets the user's info (points + username)
    Uri url = Uri.parse(
        'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/users.json?auth=$authToken&orderBy="userId"&equalTo="$userId"');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((firebaseId, userData) {
        _user.username = userData['username'];
        _user.points = userData['points'];
        _user.userId = userData['userId'];
        _user.userKey = firebaseId;
      });
    } catch (error) {
      throw error;
    }
    print('username: ${_user.username}, points: ${user.points}');
  }

  Future<void> addPointsByAccQuest(int questPoints, String userKey) async {
    // update the points inside the user key
    Uri url = Uri.parse(
        'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/users/$userKey/points.json?auth=$authToken');
    await http.put(
      url,
      body: json.encode((questPoints + _user.points)),
    );

    // update the points in local memory
    _user.points += questPoints;
    notifyListeners();
  }

  Future<void> removePointsByCreateQuest(
      int questPoints, String userKey) async {
    // Target the user that we want to add the points to
    Uri url = Uri.parse(
        'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/users/$userKey.json?auth=$authToken');
    // update the points
    await http.patch(url,
        body: json.encode({
          'points': (_user.points - questPoints),
        }));
    // update in local memory
    _user.points -= questPoints;
    notifyListeners();
  }
}
