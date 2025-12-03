import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:medicine_reminder/pages/home_page.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  String _name = '';
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        EasyLoading.show(status: 'Signing up...');

        UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _name,
          'email': _email,
          'uid': userCredential.user!.uid,
          'createdAt': DateTime.now(),
        });

        EasyLoading.dismiss();

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      } on FirebaseAuthException catch (e) {
        EasyLoading.dismiss();
        setState(() {
          _errorMessage = e.message!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to get started!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  _buildTextField(
                    label: 'Name',
                    onSaved: (value) => _name = value!,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _buildTextField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => _email = value!,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter an email';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  _buildTextField(
                    label: 'Password',
                    obscureText: true,
                    controller: _passwordController,
                    onSaved: (value) => _password = value!,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter a password';
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  _buildTextField(
                    label: 'Confirm Password',
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please confirm your password';
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error Message
                  if (_errorMessage.isNotEmpty)
                    Center(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Navigate to Login
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
