import 'package:flutter/material.dart';
import 'package:frontend/component/e_primary_header_container.dart';
import 'package:frontend/goal/edit_goal_page.dart';

class GoalDetailPage extends StatefulWidget {
  const GoalDetailPage({Key? key}) : super(key: key);

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  List<bool> _subGoalChecklist = List.generate(
      5, (index) => false); // Initialize a list of checkboxes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EPrimaryHeaderContainer(
              child: Padding(
                padding: const EdgeInsets.only(top: 110.0, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Goal Title',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        color: Color(0xFF666159),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(
                    'Deadline :',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF666159),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '11/06/2024',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Text(
                'Sub-goals',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666159),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5, // Number of sub-goals
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: _subGoalChecklist[index], // Checkbox state
                    onChanged: (bool? newValue) {
                      setState(() {
                        _subGoalChecklist[index] = newValue ??
                            false; // Update the checkbox state
                      });
                    },
                  ),
                  title: Text(
                    'Sub-goal ${index + 1}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditGoalPage(
                            goalTitle:
                                'Goal Title', // Pass the goal title
                            deadline:
                                '11/06/2024', // Pass the deadline
                            subGoals: _subGoalChecklist
                                .asMap()
                                .entries
                                .map((entry) =>
                                    'Sub-goal ${entry.key + 1}')
                                .toList(), // Pass all the sub-goals
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit),
                    label: const Text(
                      'Edit',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF9B968E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                    label: const Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFF8485A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
