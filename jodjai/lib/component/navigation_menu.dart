import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final bool showNavigation;

  const MainScaffold({
    Key? key,
    required this.body,
    required this.selectedIndex,
    this.showNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: showNavigation
          ? NavigationMenu(selectedIndex: selectedIndex)
          : null,
    );
  }
}

class NavigationMenu extends StatelessWidget {
  final int selectedIndex;

  const NavigationMenu({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Color.fromARGB(255, 222, 202, 175),
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              color: Color(0xff3C270B),
              fontFamily: 'Nunito',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: MaterialStateProperty.all(
            IconThemeData(color: Color(0xff3C270B)),
          ),
          elevation: 10),
      child: NavigationBar(
        height: 70,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/journal');
              break;
            case 1:
              Get.offAllNamed('/weeklySummary');
              break;
            case 2:
              Get.offAllNamed('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'My Journal',
            tooltip: 'My Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Weekly Summary',
            tooltip: 'Weekly Summary',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }
}
