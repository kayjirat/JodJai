import 'package:flutter/material.dart';
import 'package:jodjai/pages/edit_journal_page.dart';
import 'package:jodjai/pages/journal_detail.dart';
import 'package:jodjai/pages/journal_list_page.dart';

import 'package:jodjai/pages/new_jornal_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JournalListPage(),
      routes: {
        '/journal': (context) => const JournalListPage(),
        '/newJournal': (context) => NewJournalPage(),
        '/journalDetail': (context) => JournalDetailPage(),
        '/editJournal': (context) => EditJournalPage(),
      },
    );
  }
}
