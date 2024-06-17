import 'package:flutter/material.dart';
import 'package:frontend/pages/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showConfirmationDialog(context);
      },
      child: const Text(
        'Logout',
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFF666159),
          color: Color(0xFF666159),
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

Future<void> _showConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent dialog from closing on tap outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout',
            style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                fontWeight: FontWeight.w900)),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey.shade300),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Nunito', fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LandingPage()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                print('Error signing out: $e');
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF3C270B)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontFamily: 'Nunito', fontSize: 14),
            ),
          ),
        ],
      );
    },
  );
}
