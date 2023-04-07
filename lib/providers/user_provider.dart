import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/http_exception.dart' as mException;

import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;

  UserProvider({required this.authToken, required this.userId});
}
