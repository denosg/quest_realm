import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/user.dart';

import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;
  final User _user = User('', '', '');
  List<User> _userList = [];

  UserProvider({required this.authToken, required this.userId});

  User get user {
    return _user;
  }

  List<User> get userList {
    return [..._userList];
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
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    // gets the users
    Uri url = Uri.parse(
        'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/users.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<User> tempUserList = [];
      if (extractedData == null) {
        return;
      }
      // saves the data locally in the memory
      extractedData.forEach((userKey, userData) {
        tempUserList.add(User(userData['username'], userData['userId'], userKey,
            points: userData['points']));
      });
      // sorts the list by most amount of points
      tempUserList.sort((a, b) => b.points.compareTo(a.points));
      _userList = tempUserList;
      print(_userList);
      notifyListeners();
    } catch (error) {
      throw error;
    }
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
    // update the points inside the user key
    Uri url = Uri.parse(
        'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/users/$userKey/points.json?auth=$authToken');
    await http.put(
      url,
      body: json.encode((_user.points - questPoints)),
    );

    // update the points in local memory
    _user.points -= questPoints;
    notifyListeners();
  }
}
