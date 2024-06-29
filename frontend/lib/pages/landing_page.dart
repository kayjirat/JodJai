import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';

void main() {
  runApp(const MaterialApp(
    home: LandingPage(),
  ));
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBF6),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/JodJai_logo.png',
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Welcome to JodJai',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 34.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF666159),
                ),
              ),
              const SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Keep a personal journal to record your thoughts and moods, and track your emotional well-being with our easy-to-use app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.0,
                    color: Color(0xFF666159),
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              SizedBox(
                width: 275,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3C270B),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('GET STARTED !'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}