// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

void main() {
  runApp(const MaterialApp(
    home: SignupPage(),
  ));
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final username = _usernameController.text.trim();
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        final response = await _authService.register(username, password, email);
        final token = response['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        Navigator.pushReplacementNamed(context, '/journal');
      } catch (e) {
        if(e.toString().contains('This email is already used')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already exists')),
          );
        } else if (e.toString().contains('This username is already used')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username already exists')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed')),
          );
        }
        print('Registration failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBF6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF3C270B),
          ),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              // Logo
              Image.asset(
                'assets/images/JodJai_logo.png',
                width: 115,
                height: 115,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 48.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF666159),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10.0),
                        // Username
                        const Text(
                          'Username',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF666159),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: "Username",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0xFF666159),
                              ),
                            ),
                          ),
                          validator: _validateUsername,
                        ),
                        const SizedBox(height: 7.0),
                        // Email
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF666159),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0xFF666159),
                              ),
                            ),
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 7.0),
                        // Password
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF666159),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0xFF666159),
                              ),
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 30.0),
                        // button
                        Center(
                          child: SizedBox(
                            width: 356,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                _signup();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3C270B),
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: const Text('Sign Up'),
                            ),
                          ),
                        ),
                      ],
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
