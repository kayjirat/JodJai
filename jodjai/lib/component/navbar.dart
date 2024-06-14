import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jodjai/pages/new_journal_page.dart';
import 'package:jodjai/pages/profile_page.dart';
import 'package:jodjai/pages/weeklysum_page.dart';

void main() {
  runApp(const MaterialApp(
    home: Navbar(),
  ));
}

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          backgroundColor: Colors.white,
          indicatorColor: Colors.black.withOpacity(0.1),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.book_outlined, color: Color(0xFF3C270B)),
                label: 'My Journal'),
            NavigationDestination(
                icon: Icon(Icons.bar_chart_rounded, color: Color(0xFF3C270B)),
                label: 'Weekly Summary'),
            NavigationDestination(
                icon: Icon(Icons.account_circle_outlined,
                    color: Color(0xFF3C270B)),
                label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    NewJournalPage(),
    const WeeklySumPage(),
    const ProfilePage(),
  ];
}
