// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/component/checkout.dart';
import 'package:frontend/component/logOutButton.dart';
import 'package:frontend/pages/feedback_page.dart';
import 'package:frontend/services/stripe_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  //final Function? refreshCallback;
  //const ProfilePage({Key? key, this.refreshCallback}) : super(key: key);
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditingName = false;
  late String _name = '';
  late bool _isMember = false;
  late String _status = '';
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  String _token = '';
  //String _paymentId = '';
  String _sessionId = '';
  late UserService _userService;
  late StripeService _stripeService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _stripeService = StripeService();
    _loadTokenAndGetInfo();
  }

  Future<void> _loadTokenAndGetInfo() async {
    setState(() {
      _isLoading = true;
    });
    await _loadTokenFromSharedPreferences();
    if (_sessionId.isNotEmpty) {
      try {
        final paymentId = await _stripeService.getPaymentIntentId(_sessionId);
        if (paymentId != null) {
          await _stripeService.createMembership(_token, paymentId);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('sessionId');
        }
      } catch (e) {
        print('Failed to get user info: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
    if (_token.isNotEmpty) {
      try {
        final response = await _userService.getUser(_token);
        setState(() {
          _name = response['username'];
          _isMember = response['member_status'];
          _nameController.text = _name;
          _status = _isMember ? 'Premium' : 'Free';
          _isLoading = false;
        });
      } catch (e) {
        print('Failed to get user info: $e');
      }
    }
  }

  void refreshUserData() {
    _loadTokenAndGetInfo();
  }

  Future<void> _loadTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    _sessionId = prefs.getString('sessionId') ?? '';
  }

  Future<void> _updateUsername() async {
    if (_formKey1.currentState?.validate() ?? false) {
      try {
        setState(() {
          _isLoading = true;
        });
        final username = _nameController.text.trim();
        final response = await _userService.editUser(_token, username);
        if (response == 'User updated') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Username updated'),
            ),
          );
          setState(() {
            _name = username;
            _isEditingName = false;
            _isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Username is already existed'),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Failed to update username: $e');
      }
    }
  }

  void _editName() {
    setState(() {
      _isEditingName = true;
    });
  }

  void _saveName() {
    if (_formKey1.currentState?.validate() ?? false) {
      _updateUsername();
    }
  }

  void _navigateToFeedbackPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedbackPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBF6),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : SingleChildScrollView(
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
                              key: _formKey1,
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                color: _isEditingName
                                    ? Colors.green
                                    : Colors.white,
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
                      onTap: () {
                        if (!_isMember) {
                          // Navigate to the payment page or show a dialog to upgrade membership
                          // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Text(
                                'Membership: $_status',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3C270B),
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: Icon(
                            //     Icons.arrow_forward_ios,
                            //     size: 15,
                            //     color: Color(0xFF3C270B),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    if (!_isMember) const SizedBox(height: 20),
                    if (!_isMember)
                      const CheckoutButton(
                          // onSuccessCallback: refreshUserData,
                          ),
                    if (!_isMember) const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
