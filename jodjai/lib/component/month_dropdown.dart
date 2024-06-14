import 'package:flutter/material.dart';

class MonthYearDropdown extends StatefulWidget {
  @override
  _MonthYearDropdownState createState() => _MonthYearDropdownState();
}

class _MonthYearDropdownState extends State<MonthYearDropdown> {
  String _selectedMonth = 'January';
  String _selectedYear = '2024';

  List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> _years = ['2023', '2024', '2025', '2026'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDropdown(_months, _selectedMonth, (String? newValue) {
          setState(() {
            _selectedMonth = newValue!;
          });
        }),
        SizedBox(width: 16),
        _buildDropdown(_years, _selectedYear, (String? newValue) {
          setState(() {
            _selectedYear = newValue!;
          });
        }),
      ],
    );
  }
import 'package:flutter/material.dart';

class MonthYearDropdown extends StatefulWidget {
  @override
  _MonthYearDropdownState createState() => _MonthYearDropdownState();
}

class _MonthYearDropdownState extends State<MonthYearDropdown> {
  String _selectedMonth = 'January';
  String _selectedYear = '2024';

  List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> _years = ['2023', '2024', '2025', '2026'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDropdown(_months, _selectedMonth, (String? newValue) {
          setState(() {
            _selectedMonth = newValue!;
          });
        }),
        SizedBox(width: 16),
        _buildDropdown(_years, _selectedYear, (String? newValue) {
          setState(() {
            _selectedYear = newValue!;
          });
        }),
      ],
    );
  }

  Widget _buildDropdown(List<String> items, String selectedValue,
      Function(String?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        icon: Icon(Icons.arrow_drop_down_rounded,
            color: Color(0xff3C270B)),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          color: Color(0xff3C270B),
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Dropdown Menu Example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MonthYearDropdown(),
        ),
      ),
    ),
  ));
}
