import 'package:flutter/material.dart';
import 'package:frontend/component/e_primary_header_container.dart';

class NewGoalPage extends StatefulWidget {
  const NewGoalPage({super.key});

  @override
  State<NewGoalPage> createState() => _NewGoalPageState();
}

class _NewGoalPageState extends State<NewGoalPage> {
  final TextEditingController _goalController =
      TextEditingController();
  final List<String> _subGoals = [];
  DateTime? _selectedDate;
  final List<bool> _subGoalCheckboxValues = []; // Maintain checkbox state

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addSubGoal(String subGoal) {
    setState(() {
      _subGoals.add(subGoal);
      _subGoalCheckboxValues.add(false); // Initialize checkbox state
    });
  }

  void _removeSubGoal(int index) {
    setState(() {
      _subGoals.removeAt(index);
      _subGoalCheckboxValues.removeAt(index); // Remove checkbox state
    });
  }

  void _openAddSubGoalOverlay(BuildContext context) {
    TextEditingController subGoalController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Sub-goal'),
          content: TextField(
            controller: subGoalController,
            decoration: const InputDecoration(
              labelText: 'Enter sub-goal',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (subGoalController.text.isNotEmpty) {
                  _addSubGoal(subGoalController.text);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const EPrimaryHeaderContainer(
              child: Padding(
                padding: EdgeInsets.only(top: 110.0, left: 20),
                child: Column(
                  children: [
                    Text(
                      'New goal',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        color: Color(0xFF666159),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                left: 30,
                right: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Goal',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF666159),
                    ),
                  ),
                  const SizedBox(height: 2),
                  TextField(
                    controller: _goalController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 1.0,
                        horizontal: 12.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Deadline :',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF666159),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Row(
                          children: [
                            Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Select Deadline',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: _selectedDate != null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.calendar_today,
                              color: _selectedDate != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sub-goals',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF666159),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _subGoals.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Checkbox(
                            value: _subGoalCheckboxValues[index],
                            onChanged:
                                null, // Make the checkbox unclickable
                          ),
                          Expanded(
                            child: Text(
                              _subGoals[index],
                              style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => _removeSubGoal(index),
                          ),
                        ],
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => _openAddSubGoalOverlay(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color(0xFF3C270B), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20), // Padding
                      textStyle: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                      ),
                    ),
                    child: const Text('+ Add New Sub-goal'),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 20.0),
              child: SizedBox(
                width:
                    300, // Set button width to match the parent width
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save logic here
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff64D79C), // Text color
                    textStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Set border radius
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
