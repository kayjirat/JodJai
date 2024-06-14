import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: FeedbackPage(),
  ));
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFEFBF6),
                      Color(0xFFFCB4BB),
                      Color(0xFFFCAFB7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 45.0, left: 10.0, right: 20.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 120),
              child: Center(
                child: Text(
                  'Feedback & Support',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF666159),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 190.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 200.0, 40.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 25),
                  const Center(
                    child: Text(
                      'We would like your feedback\n'
                      'to improve our application',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Color(0xFF666159),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Please leave your feedback below:',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF666159),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: const Color(0xFFFEFBF6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Please type here...',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(221, 55, 55, 55),
                              fontSize: 10,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          maxLines: 6,
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF64D79C)),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 80),
                        ),
                      ),
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
