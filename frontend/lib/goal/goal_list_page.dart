import 'package:flutter/material.dart';
import 'package:frontend/goal/goal_card.dart';
import 'package:frontend/goal/new_goal_page.dart';
import 'package:frontend/goal/goal_detail_page.dart'; // Assuming you have a GoalDetailPage

class GoalListPage extends StatefulWidget {
  const GoalListPage({Key? key}) : super(key: key);

  @override
  State<GoalListPage> createState() => _GoalListPageState();
}

class _GoalListPageState extends State<GoalListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFBF6),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                'My goals',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  color: Color(0xFF666159),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GoalCard(
                  title: 'Your Goal Title',
                  progress:
                      0.5, // Assuming progress is a double between 0 and 1
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GoalDetailPage(), // Navigate to GoalDetailPage
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewGoalPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: const Text(
                    'Add Goal',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF3C270B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
