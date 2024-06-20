// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:frontend/component/checkout.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/signup_page.dart';
//import 'package:frontend/pages/success.dart';
import 'package:get/get.dart';
import 'package:frontend/pages/edit_journal_page.dart';
import 'package:frontend/pages/journal_detail.dart';
import 'package:frontend/pages/journal_list_page.dart';
import 'package:frontend/pages/new_journal_page.dart';
import 'package:frontend/component/navigation_menu.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/weeklysum_page.dart';
import 'package:frontend/pages/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jodjai App',
      initialRoute: '/landing',
      getPages: [
        GetPage(
          name: '/landing',
          page: () => const LandingPage(),
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
          name: '/profile/',
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
        // GetPage(
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
        ),
        GetPage(
          name: '/register',
          page: () => const SignupPage(),
        ),
      ],
      routingCallback: (routing) {
        if (routing != null) {
          final currentRoute = routing.current;
          print('Current route: $currentRoute');
        }
      },
      navigatorObservers: [AuthMiddleware()],
    );
  }
}

class AuthMiddleware extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) async {
    super.didPush(route, previousRoute);
    await _checkAuth(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) async {
    super.didPop(route, previousRoute);
    await _checkAuth(route);
  }

  Future<void> _checkAuth(Route route) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (route.settings.name == '/login' || route.settings.name == '/register' || route.settings.name == '/landing') {
      return;
    }

    if (token == null) {
      Get.offAllNamed('/login');
    } else {
      print('Token is present, proceeding to ${route.settings.name}');
    }
  }
}