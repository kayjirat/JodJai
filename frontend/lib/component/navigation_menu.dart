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
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(4.0), // Set the height of the shadow
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 60, 54, 54)
                    .withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, -4), // changes position of shadow
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: body,
          ),
          if (showNavigation)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NavigationMenu(selectedIndex: selectedIndex),
            ),
        ],
      ),
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
        height: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        indicatorColor: Colors.black.withOpacity(0.1),
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
      ),
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
            icon: Icon(
              Icons.account_circle_outlined,
            ),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Profile',
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }
}