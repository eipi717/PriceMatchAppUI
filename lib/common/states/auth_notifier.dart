import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthNotifier with ChangeNotifier {
  String? _token;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;

  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;

  AuthNotifier() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      _isAuthenticated = true;
      _user = json.decode(prefs.getString('user') ?? '{}');
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('https://your-api-domain.com/api/login');
    try {
      // final response = await http.post(
      //   url,
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({'email': email, 'password': password}),
      // );

      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   _token = data['token'];
      //   _user = data['user'];
      //   _isAuthenticated = true;
      //
      //   // Persist token and user data
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('token', _token!);
      //   await prefs.setString('user', json.encode(_user));
      //
      //   notifyListeners();
      //   return true;
      // } else {
      //   // Handle errors (e.g., invalid credentials)
      //   return false;
      // }
      if (email == 'test' && password == '1234') {
        _isAuthenticated = true;
        notifyListeners();
          return true;
      }
      else {
        return false;
      }
    } catch (e) {
      // Handle network errors
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    // Clean up the state in notifier
    _token = null;
    _isAuthenticated = false;
    _user = null;

    // Clean the state in shared resources
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    // TODO: API to update the user last action time & record the logout time by calling auth_services
    notifyListeners();
  }
}