import 'package:flutter/material.dart';

class JournalDetailPage extends StatefulWidget {
  const JournalDetailPage({super.key});

  @override
  State<JournalDetailPage> createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: Text(
            'Delete Journal',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xff666159),
            ),
          ),
          content: Text(
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
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xFF9B968E),
                ),
              ),
              style: TextButton.styleFrom(
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
            TextButton(
              onPressed: () {
                // Add your deletion logic here
                Navigator.of(context).pop();
                Navigator.pushNamed(context,
                    '/journal'); // Navigate back to journal list
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFF8485A),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 13),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100),
                        child: Text(
                          '16/11/2024',
                          style: TextStyle(
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
                  Image.asset('assets/images/happy.png'),
                  SizedBox(width: 20),
                  Text(
                    'journalTitle',
                    style: TextStyle(
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
                'journalContent',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  color: Color(0xff666159),
                ),
              ),
            ),
            SizedBox(
                height: 200), // Spacer between content and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/EditJournalPage',
                    );
                  },
                  icon: Icon(Icons.edit),
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
                    backgroundColor: Color(0xFF9B968E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showDeleteDialog,
                  icon: Icon(Icons.delete),
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
                    backgroundColor: Color(0xFFF8485A),
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
                height:
                    50), // Bottom padding for better visual separation
          ],
        ),
      ),
    );
  }
}
