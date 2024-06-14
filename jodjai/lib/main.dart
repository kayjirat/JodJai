import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jodjai/pages/edit_journal_page.dart';
import 'package:jodjai/pages/journal_detail.dart';
import 'package:jodjai/pages/journal_list_page.dart';
import 'package:jodjai/pages/new_journal_page.dart';
import 'package:jodjai/component/navigation_menu.dart';
import 'package:jodjai/pages/profile_page.dart';
import 'package:jodjai/pages/weeklysum_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jodjai App',
      initialRoute: '/journal',
      getPages: [
        GetPage(
          name: '/journal',
          page: () => MainScaffold(
            body: const JournalListPage(),
            selectedIndex: 0,
          ),
        ),
        GetPage(
          name: '/weeklySummary',
          page: () => MainScaffold(
            body: WeeklySumPage(),
            selectedIndex: 1,
          ),
        ),
        GetPage(
          name: '/profile',
          page: () => MainScaffold(
            body: ProfilePage(),
            selectedIndex: 2,
          ),
        ),
        GetPage(
          name: '/journalDetail',
          page: () => Scaffold(
            body: const JournalDetailPage(),
          ),
        ),
        GetPage(
          name: '/newJournal',
          page: () => Scaffold(
            body: NewJournalPage(),
          ),
        ),
        GetPage(
          name: '/editJournal',
          page: () => Scaffold(
            body: EditJournalPage(),
          ),
        ),
      ],
    );
  }
}
