// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/component/checkout.dart';
import 'package:frontend/pages/success.dart';
import 'package:get/get.dart';
import 'package:frontend/pages/edit_journal_page.dart';
import 'package:frontend/pages/journal_detail.dart';
import 'package:frontend/pages/journal_list_page.dart';
import 'package:frontend/pages/new_journal_page.dart';
import 'package:frontend/component/navigation_menu.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/weeklysum_page.dart';
import 'package:frontend/pages/landing_page.dart';

void main() async{
  await dotenv.load(fileName: '.env');  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  
  const MainApp({Key? key});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jodjai App',
      initialRoute: '/landing', // Set initial landing route
      getPages: [
        GetPage(
          name: '/landing',
          page: () =>
              const LandingPage(), // Define your landing page widget
        ),
        GetPage(
          name: '/journal',
          page: () => const MainScaffold(
            body: JournalListPage(),
            selectedIndex: 0,
          ),
        ),
        GetPage(
          name: '/weeklySummary',
          page: () => const MainScaffold(
            body: WeeklySumPage(),
            selectedIndex: 1,
          ),
        ),
        GetPage(
          name: '/profile',
          page: () => const MainScaffold(
            body: ProfilePage(),
            selectedIndex: 2,
          ),
        ),
        GetPage(
          name: '/journalDetail',
          page: () => const Scaffold(
            body: JournalDetailPage(),       
          ),
        ),
        GetPage(
          name: '/newJournal',
          page: () => const Scaffold(
            body: NewJournalPage(),
          ),
        ),
        GetPage(
          name: '/editJournal',
          page: () => const Scaffold(
            body: EditJournalPage(),
          ),
        ),
        GetPage(
          name: '/checkout',
          page: () => const Scaffold(
            body: CheckoutButton(),
          ),
        ),
        GetPage(
          name: '/success',
          page: () => const Scaffold(
            body: MyWidget(),
          ),
        ),
      ],
    );
  }
}