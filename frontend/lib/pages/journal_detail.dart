// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalDetailPage extends StatefulWidget {
  const JournalDetailPage({super.key});

  @override
  State<JournalDetailPage> createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  late JournalService _journalService;
  late String title = '';
  late String content = '';
  late String date = '';
  late int moodRating = 0;
  late int id = 0;

  String _token = '';

  @override
  void initState() {
    super.initState();
    _journalService = JournalService();
    _loadTokenAndFetchJournalEntry();
  }

  Future<void> _loadTokenAndFetchJournalEntry() async {
    await _loadTokenFromSharedPreferences();
    final Map<String, dynamic> journalDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      title = journalDetails['title'];
      content = journalDetails['content'];
      date = journalDetails['entryDate'];
      moodRating = journalDetails['moodRating'];
      id = journalDetails['id'];
    });
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return date;
  }

  Future<void> _loadTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
  }

  Future<void> _deleteJournalEntry() async {
    await _journalService.deleteJournalEntry(_token, id);
  }

  String getMoodImage(int moodRating) {
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
        return 'assets/images/happy.png';
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: const Text(
            'Delete Journal',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xff666159),
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this journal?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Color(0xff666159),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: Color(0xFF9B968E),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xFF9B968E),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteJournalEntry();
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/journal');
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF8485A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 45.0, left: 10.0, right: 20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xff3C270B),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/journal');
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Text(
                          formatDate(date),
                          style: const TextStyle(
                            color: Color(0xff666159),
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 30),
              child: Row(
                children: [
                  Image.asset(
                    getMoodImage(moodRating),
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xff666159),
                      fontFamily: 'Nunito',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                content,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  color: Color(0xff666159),
                ),
              ),
            ),
            const SizedBox(height: 200), // Spacer between content and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/editJournal',
                      arguments: {
                        'title': title,
                        'content': content,
                        'entryDate': date,
                        'moodRating': moodRating,
                        'id': id,
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF9B968E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showDeleteDialog,
                  icon: const Icon(Icons.delete),
                  label: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFF8485A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 50), // Bottom padding for better visual separation
          ],
        ),
      ),
    );
  }
}
