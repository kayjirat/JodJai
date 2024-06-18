// ignore_for_file: avoid_print

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  final String url;
  late final String baseUrl;
  UserService() : url = dotenv.env['BASE_URL'] ?? '' {
    baseUrl = '$url/user';
  }
  
  Future<Map<String, dynamic>> getUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<String> editUser(String token, String username) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/edit'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 409) {
      return 'Username already exists';
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<String> sendFeedback(String token, String feedback) async {
    final response = await http.post(
      Uri.parse('$baseUrl/feedback'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'feedback': feedback,
      }),
    );
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<bool> checkMembership(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/check'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData == false) {
          return false;
        } else {
          return true;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Failed to load membership status: $e');
      return false;
    }
  }
}
