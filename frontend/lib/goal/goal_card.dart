import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final double progress;
  final VoidCallback onTap;

  const GoalCard({
    required this.title,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          border:
              Border.all(color: Color(0xff3C270B)), // Border color
          borderRadius: BorderRadius.circular(10), // Border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff666159),
                      ),
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xffB1EACD),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Color(0xff3C270B),
              ), // Icon on the right side
            ],
          ),
        ),
      ),
    );
  }
}
