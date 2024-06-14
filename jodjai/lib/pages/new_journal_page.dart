import 'package:flutter/material.dart';
import 'package:jodjai/component/e_primary_header_container.dart';
import 'package:jodjai/component/emotion_selector.dart';

class NewJournalPage extends StatefulWidget {
  NewJournalPage({Key? key}) : super(key: key);

  @override
  State<NewJournalPage> createState() => _NewJournalPageState();
}

class _NewJournalPageState extends State<NewJournalPage> {
  final TextEditingController _goalController =
      TextEditingController();

  DateTime? _selectedDate;

  final maxLines = 10;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            EPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 45.0, left: 10.0, right: 20.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xff3C270B),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/journal');
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, top: 10),
                    child: Text(
                      'New Journal',
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
              padding: const EdgeInsets.only(
                left: 30,
                right: 30.0,
              ),
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
                  EmotionSelector(),
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
                            width:
                                1.0, // Adjust border width as needed
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust border radius as needed
                        ),
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Ensures the row takes minimum space
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                child: Text(
                                  _selectedDate != null
                                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
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
                    controller: _goalController,
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
                  TextField(
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.black),
                    maxLines:
                        maxLines, // Allows the TextField to be multiline
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical:
                            20.0, // Adjust vertical padding for better spacing
                        horizontal: 12.0,
                      ),
                      hintText: 'Type something...',
                    ),
                    textAlignVertical: TextAlignVertical
                        .top, // Aligns text to the top vertically
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 40, bottom: 30.0),
              child: SizedBox(
                width:
                    300, // Set button width to match the parent width
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save logic here
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xff64D79C), // Text color
                    textStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Set border radius
                    ),
                  ),
                  child: Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
