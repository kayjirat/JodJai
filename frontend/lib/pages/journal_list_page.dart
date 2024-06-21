// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:frontend/component/journal_card.dart';
import 'package:frontend/component/month_dropdown.dart';
import 'package:frontend/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalListPage extends StatefulWidget {
  const JournalListPage({super.key});

  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  late JournalService _journalService;
  late String _selectedMonth;
  late String _selectedYear;
  List<dynamic> _journals = [];
  bool _isLoading = true;
  String _token = '';

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    _journalService = JournalService();
    DateTime now = DateTime.now();
    _selectedMonth = _months[now.month - 1];
    _selectedYear = now.year.toString();
    _loadTokenAndFetchJournalEntries();
  }

  Future<void> _loadTokenAndFetchJournalEntries() async {
    await _loadTokenFromSharedPreferences();
    if (_token.isNotEmpty) {
      int month = _months.indexOf(_selectedMonth) + 1;
      int year = int.parse(_selectedYear);
      await _fetchJournalEntries(month: month, year: year);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token') ?? '';
    });
  }

  // Future<void> _fetchJournalEntries() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     print('token: $_token');
  //     final entries = await _journalService.getJournalEntries(_token);
  //     setState(() {
  //       _journals = entries;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Failed to fetch journal entries: $e');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  Future<void> _fetchJournalEntries(
      {required int month, required int year}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final entries = await _journalService.getJournalEntriesByDate(
          _token, month, year);
      if (entries != null) {
        setState(() {
          _journals = entries;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to fetch journal entries: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMonthYearChanged(int month, int year) {
    setState(() {
      _selectedMonth = _months[month - 1];
      _selectedYear = year.toString();
    });
    _fetchJournalEntries(month: month, year: year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBF6),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                'My journal',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 33,
                  color: Color(0xFF666159),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MonthYearDropdown(
                      onMonthYearChanged: _onMonthYearChanged),
                  SizedBox(
                    width: 80,
                  )
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : _journals.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/journal_empty.png',
                              width: 208,
                              height: 208,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'You haven\'t written any journal yet',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: Color(0xFF666159),
                              ),
                            ),
                            const Text(
                              'Let\'s start by adding your first journal!',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: Color(0xFF666159),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: _journals.map((entry) {
                            return JournalCard(
                              id: entry['journal_id'],
                              title: entry['title'],
                              content: entry['content'],
                              entryDate: entry['entry_date'],
                              moodRating: entry['mood_rating'],
                            );
                          }).toList(),
                        ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/newJournal');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add daily journal',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF3C270B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
