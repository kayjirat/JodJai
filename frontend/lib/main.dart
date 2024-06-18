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
              LandingPage(), // Define your landing page widget
        ),
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
            body: JournalDetailPage(),       
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
        GetPage(
          name: '/checkout',
          page: () => Scaffold(
            body: CheckoutButton(),
          ),
        ),
        GetPage(
          name: '/success',
          page: () => Scaffold(
            body: MyWidget(),
          ),
        ),
      ],
    );
  }
}