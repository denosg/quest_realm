import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Auth with ChangeNotifier {
  // firebase api key
  String firebaseApiKey = dotenv.get('FIREBASE_API_KEY');

  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  String? get userId {
    return _userId;
  }

  //Verifies if user is authentificated
  bool get isAuth {
    return token != null;
  }

  //Gets the token for each user
  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  // tries to AutoLogin the user using the auth token provided by firebase
  Future<bool> tryAutoLogin() async {
    // gets the user data with the token
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final tempShit = prefs.getString('userData');
    if (tempShit != null) {
      final extractedUserData = json.decode(tempShit) as Map<String, dynamic>;
      // gets the expiry date of the token
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

      // verifies if the token's time is good
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _expiryDate = expiryDate;
      notifyListeners();
      _autoLogout();
    }
    return true;
  }

  //Sign up method
  Future<void> signUp(String email, String password, User newUser) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$firebaseApiKey'),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      // gets the expiriy date of the token
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      // autoLogout counter starts ->
      _autoLogout();
      notifyListeners();
      // gets the data for the AutoLogin
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      // sets user's data regarding the auth
      prefs.setString('userData', userData);
      //Send json data to server database regarding user info
      Uri url = Uri.parse(
          'https://questrealm-cb1e3-default-rtdb.europe-west1.firebasedatabase.app/users.json?auth=$_token');
      try {
        //This registers as a 'TODO' function (loads at the end, async task)
        //Waits for this operation to finish before going to the next lines of code
        final userResponse = await http.post(url,
            body: json.encode({
              'userId': _userId,
              'username': newUser.username,
              'points': newUser.points,
            }));
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } on HttpException catch (e) {
      throw e;
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$firebaseApiKey'),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      // gets the expiriy date of the token
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      // autoLogout counter starts ->
      _autoLogout();
      notifyListeners();
      // gets the data for the AutoLogin
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      // sets user's data regarding the auth
      prefs.setString('userData', userData);
    } on HttpException catch (e) {
      throw e;
    }
  }

  // logout method in personal profile page
  Future<void> logout() async {
    // resets all the info regarding the login
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    // deletes the info regarding user's data
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  // autoLogout timer
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    // gets how much time till expiry
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
