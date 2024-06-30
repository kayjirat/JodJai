import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import  '../models/weekly_summary.dart';


class JournalService {

  late final String baseUrl;
  JournalService() {
    final base = dotenv.env['BASE_URL'] ?? '';
    final androidUrl = dotenv.env['ANDROID_URL'] ?? '';

    if (kIsWeb || Platform.isIOS) {
      baseUrl = '$base/journal';
    } else {
      baseUrl = androidUrl.isNotEmpty ? '$androidUrl/journal' : base;
    }
  }

  Future<void> createJournalEntry(String token, String title, String content, String entryDate, int moodRating) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'content': content,
        'entry_date': entryDate.substring(0,10),
        'mood_rating': moodRating,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create journal entry');
    }
  }

  Future<void> updateJournalEntry(String token, int journalId, String title, String content, String entryDate, int moodRating) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/update/$journalId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'content': content,
        'entry_date': entryDate.substring(0,10),
        'mood_rating': moodRating,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update journal entry');
    }
  }

  Future<void> deleteJournalEntry(String token, int journalId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$journalId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete journal entry');
    }
  }

  Future<Map<String, dynamic>> getJournalEntry(String token, int journalId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/journal/$journalId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch journal entry');
    }
  }

  Future<List<dynamic>> getJournalEntries(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/list'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch journal entries');
    }
  }

  Future<List<dynamic>> getJournalEntriesByDate(String token, int month, int year) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ByMonthAndYear/$month/$year'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return json.decode('[]');
    } else {
      throw Exception('Failed to fetch journal entries');
    }
  }

  Future<List<WeeklySummary>> getCurrentWeeklySummary(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/current-weeklysum'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => WeeklySummary.fromJson(json)).toList();
    }
    throw Exception('Failed to load weekly summary');
  }

  Future<List<WeeklySummary>> getWeeklySummary(String token, DateTime startOfWeek) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weeklysum?startOfWeek=${startOfWeek.toIso8601String().substring(0, 10)}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => WeeklySummary.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch weekly summary');
    }
  }
}
