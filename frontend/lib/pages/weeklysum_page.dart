// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/services/journal_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weekly_summary.dart';
import 'package:intl/intl.dart';

class WeeklySumPage extends StatefulWidget {
  const WeeklySumPage({super.key});

  @override
  State<WeeklySumPage> createState() => _WeeklySumPageState();
}

class _WeeklySumPageState extends State<WeeklySumPage> {
  late UserService _userService;
  late JournalService _journalService;
  bool _isMember = false;
  bool _isLoading = true;
  String _token = '';
  List<WeeklySummary> _weeklySummary = [];
  final List<DateTime> _weeks = [];
  DateTime _selectedWeek = DateTime.now();

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _journalService = JournalService();
    _generateWeekList();
    _loadTokenAndGetInfo();
  }

  void _generateWeekList() {
  DateTime now = DateTime.now();
  for (int i = 0; i < 12; i++) {
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - DateTime.monday + 7 * i));
    _weeks.add(startOfWeek);
  }
  _selectedWeek = _weeks.first;
}


  Future<void> _loadTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
  }

  Future<void> _loadTokenAndGetInfo() async {
    await _loadTokenFromSharedPreferences();
    if (_token.isNotEmpty) {
      try {
        final response = await _userService.checkMembership(_token);
        setState(() {
          _isMember = response;
        });
        if (_isMember) {
          _fetchWeeklySummary(_selectedWeek);
        }
      } catch (e) {
        print('Failed to get user info: $e');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchWeeklySummary(DateTime startOfWeek) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await _journalService.getWeeklySummary(_token, startOfWeek);
      setState(() {
        _weeklySummary = _completeMoodSummary(response);
      });
    } catch (e) {
      print('Failed to get weekly summary: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  List<WeeklySummary> _completeMoodSummary(List<WeeklySummary> summary) {
    final List<WeeklySummary> completeSummary = List.generate(5, (index) {
      final moodRating = index + 1;
      return WeeklySummary(moodRating: moodRating, moodPercentage: 0);
    });
    for (var item in summary) {
      final index = completeSummary
          .indexWhere((mood) => mood.moodRating == item.moodRating);
      if (index != -1) {
        completeSummary[index] = item;
      }
    }

    return completeSummary;
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBF6),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Weekly Summary',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 33.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF666159),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      if (_isMember)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: SizedBox(
                            width: 180,
                            child: DropdownButtonFormField<DateTime>(
                              value: _selectedWeek,
                              decoration: InputDecoration(
                                labelText: 'Select Week',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4.0),
                              ),
                              items: _weeks.map((DateTime week) {
                                return DropdownMenuItem<DateTime>(
                                  value: week,
                                  child: Text(
                                    _formatDate(week),
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666159),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (DateTime? newWeek) {
                                if (newWeek != null) {
                                  setState(() {
                                    _selectedWeek = newWeek;
                                  });
                                  _fetchWeeklySummary(newWeek);
                                }
                              },
                              dropdownColor: const Color(0xFFFEFBF6),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20.0),
                      if (_isMember)
                        ..._weeklySummary.map((summary) {
                          return _buildProgressRow(
                            context,
                            _getEmojiPath(summary.moodRating),
                            summary.moodPercentage / 100,
                            _getColor(summary.moodRating),
                          );
                        })
                      else
                        const Center(
                          child: Text(
                            'Unlock to Premium Membership to view the summary',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF666159),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  String _getEmojiPath(int moodRating) {
    switch (moodRating) {
      case 1:
        return 'assets/images/happy.png';
      case 2:
        return 'assets/images/smile_pink.png';
      case 3:
        return 'assets/images/soso.png';
      case 4:
        return 'assets/images/sad.png';
      case 5:
        return 'assets/images/cry.png';
      default:
        return 'assets/images/soso.png';
    }
  }

  Color _getColor(int moodRating) {
    switch (moodRating) {
      case 1:
        return const Color(0xFFFFE790);
      case 2:
        return const Color(0xFFFFD2D7);
      case 3:
        return const Color(0xFFCAEAB1);
      case 4:
        return const Color(0xFFB6D7FF);
      case 5:
        return const Color(0xFFA3A3A3);
      default:
        return const Color(0xFFDEDEDE);
    }
  }

  Widget _buildProgressRow(
      BuildContext context, String emojiPath, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Image.asset(
            emojiPath,
            width: 57.13,
            height: 57.13,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFDEDEDE),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF666159),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
