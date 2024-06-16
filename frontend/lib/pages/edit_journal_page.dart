import 'package:flutter/material.dart';
import 'package:frontend/component/e_primary_header_container.dart';
import 'package:frontend/component/emotion_show_and_select.dart';
import 'package:frontend/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditJournalPage extends StatefulWidget {
  @override
  State<EditJournalPage> createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  DateTime? _selectedDate;
  int _selectedEmotion = 0;
  final maxLines = 10;
  late JournalService _journalService;
  late final String title;
  late final String content;
  late final String date;
  late int moodRating = 0;
  late final int id;
  bool _isLoading = true;
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
      _titleController = TextEditingController(text: title);
      _contentController = TextEditingController(text: content);
      _selectedDate = DateTime.parse(date);
      _selectedEmotion = moodRating;
      _isLoading = false;
    });
  }

  Future<void> _loadTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    print('picked date: $picked');
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
    print('selected date: $_selectedDate');
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

  void _updateJournalEntry() async {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _selectedDate == null ||
        _selectedEmotion == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }
    try {
      await _journalService.updateJournalEntry(
        _token,
        id,
        _titleController.text,
        _contentController.text,
        _selectedDate!.toString(),
        _selectedEmotion,
      );
      Navigator.pushNamed(
        context,
       '/journalDetail',
       arguments: {
         'title': _titleController.text,
         'content': _contentController.text,
         'entryDate': _selectedDate!.toString(),
         'moodRating': _selectedEmotion,
         'id': id,
       },);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update journal entry')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  EPrimaryHeaderContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 13),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xff3C270B),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context, 
                                '/journalDetail',
                                arguments: {
                                  'title': title,
                                  'content': content,
                                  'entryDate': date,
                                  'moodRating': moodRating,
                                  'id': id,
                                },);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 10),
                          child: Text(
                            'Edit Journal',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: 32,
                              color: Color(0xFF666159),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How are you feeling today?',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF666159),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // if (_selectedEmotion != 0) ...[
                        //   Image.asset(
                        //     getMoodImage(_selectedEmotion),
                        //     height: 50,
                        //   ),
                        //   const SizedBox(height: 10),
                        // ],
                        EmotionShowAndSelect(
                          onEmotionSelected: (int emotion) {
                            setState(() {
                              _selectedEmotion = emotion;
                            });
                          },
                          initialEmotion: _selectedEmotion,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              'Date :',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF666159),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff3C270B),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 12.0),
                                      child: Text(
                                        _selectedDate != null
                                            ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                                            : 'Select Date',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: _selectedDate != null
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: _selectedDate != null
                                            ? Color(0xff3C270B)
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF666159),
                          ),
                        ),
                        const SizedBox(height: 2),
                        TextField(
                          controller: _titleController,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: 'Title...',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 1.0,
                              horizontal: 12.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        const Text(
                          'Content',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF666159),
                          ),
                        ),
                        const SizedBox(height: 2),
                        TextField(
                          controller: _contentController,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.black),
                          maxLines: maxLines,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 12.0,
                            ),
                            hintText: 'Type something...',
                          ),
                          textAlignVertical: TextAlignVertical.top,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                context, 
                                '/journalDetail',
                                arguments: {
                                  'title': title,
                                  'content': content,
                                  'entryDate': date,
                                  'moodRating': moodRating,
                                  'id': id,
                                },);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0xFF9B968E),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Color(0xFF9B968E),
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _updateJournalEntry();
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFF64D79C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
