import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:medicine_reminder/pages/auth/signup_screen.dart';
import 'package:medicine_reminder/pages/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    EasyLoading.show(status: 'Loading...');
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      EasyLoading.dismiss();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(height: 40),
          Icon(Icons.medical_services, size: 80, color: Colors.deepPurpleAccent),
          SizedBox(height: 20),
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Login to continue',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 40),

          // Email Field
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),

          SizedBox(height: 20),

          // Password Field
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
                controller: _passwordController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
          ),
          obscureText: true,
        ),
      ),

      SizedBox(height: 30),

      // Login Button
      _isLoading
          ? CircularProgressIndicator()
          : SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.deepPurpleAccent,
          ),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),

      SizedBox(height: 20),

      TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SignupScreen()),
          );
        },
        child: Text(
          'New User? Create Account',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      ],
    ),
    ),
    ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
