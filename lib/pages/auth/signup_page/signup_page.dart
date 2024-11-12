import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Implement your sign-up logic similarly to LoginPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Sign Up Page - To Be Implemented',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}