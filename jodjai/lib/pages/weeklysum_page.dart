import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: WeeklySumPage(),
  ));
}

class WeeklySumPage extends StatefulWidget {
  const WeeklySumPage({super.key});

  @override
  State<WeeklySumPage> createState() => _WeeklySumPageState();
}

class _WeeklySumPageState extends State<WeeklySumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBF6),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Weekly Summary',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 33.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF666159),
                    ),
                  ),
                ),
                const SizedBox(height: 45.0),
                _buildProgressRow(
                  context,
                  'assets/images/happy.png',
                  0.5,
                  const Color(0xFFFFE790),
                ),
                const SizedBox(height: 30.0),
                _buildProgressRow(
                  context,
                  'assets/images/smile_pink.png',
                  0.5,
                  const Color(0xFFFFD2D7),
                ),
                const SizedBox(height: 30.0),
                _buildProgressRow(
                  context,
                  'assets/images/soso.png',
                  0.5,
                  const Color(0xFFCAEAB1),
                ),
                const SizedBox(height: 30.0),
                _buildProgressRow(
                  context,
                  'assets/images/sad.png',
                  0.5,
                  const Color(0xFFB6D7FF),
                ),
                const SizedBox(height: 30.0),
                _buildProgressRow(
                  context,
                  'assets/images/cry.png',
                  0.5,
                  const Color(0xFFA3A3A3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressRow(
      BuildContext context, String emojiPath, double progress, Color color) {
    return Row(
      children: [
        Image.asset(
          emojiPath,
          width: 57.13,
          height: 57.13,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFDEDEDE),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666159),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
