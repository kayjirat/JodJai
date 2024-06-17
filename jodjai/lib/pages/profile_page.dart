import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jodjai/component/checkout.dart';
import 'package:jodjai/component/logOutButton.dart';
import 'package:jodjai/pages/feedback_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditingName = false;
  String _name = 'Name';
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _editName() {
    setState(() {
      _isEditingName = true;
      _nameController.text = _name;
    });
  }

  void _saveName() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _name = _nameController.text;
        _isEditingName = false;
      });
    }
  }

  void _navigateToFeedbackPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedbackPage()),
    );
  }

  void _navigateToPaymentPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckoutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBF6),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 10),
                    child: LogOutButton(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Topic
              const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 33.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF666159),
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              // Edit Name
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    const Expanded(flex: 0, child: Icon(Icons.person)),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 8,
                      child: Form(
                        key: _formKey,
                        child: _isEditingName
                            ? TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your name',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 18.0,
                                    color: Color(0xFF666159),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 18.0,
                                  color: Color(0xFF3C270B),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                              )
                            : Text(
                                _name,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF666159),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _isEditingName ? _saveName : _editName,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isEditingName ? Colors.green : Colors.white,
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          _isEditingName ? Icons.check : Icons.edit,
                          size: 15,
                          color: const Color(0xFF3C270B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Feedback
              GestureDetector(
                onTap: () => _navigateToFeedbackPage(context),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                          'Feedback',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3C270B),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF3C270B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Payment
              GestureDetector(
                onTap: () => _navigateToPaymentPage(context),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                          'Payment',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3C270B),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF3C270B),
                        ),
                      ),
                    ],
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
