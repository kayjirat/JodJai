import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {

  late final String baseUrl;
   AuthService() {
    final base = dotenv.env['BASE_URL'] ?? '';
    final androidUrl = dotenv.env['ANDROID_URL'] ?? '';

    if (kIsWeb || Platform.isIOS) {
      baseUrl = '$base/authen';
    } else {
      baseUrl = '$androidUrl/authen';
    }
  }
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Wrong password');
    } else {
      print(response.body);
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(
      String username, String password, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'email': email,
      }),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('This email is already used');
    } else if (response.statusCode == 409) {
      throw Exception('This username is already used');
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> logout() async {
    final response = await http.get(
      Uri.parse('$baseUrl/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get user');
    }
  }
}
