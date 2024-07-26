import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:seeker/controller/auth_provider.dart';
import 'package:seeker/screens/Login_Page/login.dart';

import 'package:seeker/widgets/button.dart'; // Replace with your actual button import

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Optional: remove shadow
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Lottie.asset(
                      'assets/Animation - 1721967145718.json', // Replace with your image path
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust border radius as needed
                          borderSide: const BorderSide(
                              color: Colors.grey), // Add a border color
                        ),
                        filled: true,
                        fillColor: Colors.white, // Set a background color
                        prefixIcon:
                            const Icon(Icons.person), // Optionally add an icon
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust border radius as needed
                      borderSide: const BorderSide(
                          color: Colors.grey), // Add a border color
                    ),
                    filled: true,
                    fillColor: Colors.white, // Set a background color
                    prefixIcon:
                        const Icon(Icons.email), // Optionally add an icon
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText:
                      true, // This hides the entered text for passwords
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon:
                        const Icon(Icons.lock), // Changed icon to lock icon
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        // Toggle password visibility
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText:
                      true, // This hides the entered text for passwords
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon:
                        const Icon(Icons.lock), // Changed icon to lock icon
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        // Toggle password visibility
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Button(
                  onTap: () {
                    signUpWithEmail(context);
                  },
                  name: 'Register',
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Login Page'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUpWithEmail(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar(context, 'Passwords do not match');
      return;
    }

    try {
      await Provider.of<AuthProviders>(context, listen: false).signUpWithEmail(
        _emailController.text,
        _passwordController.text,
        _usernameController.text,
      );

      _showSuccessDialog(context);

      await Future.delayed(const Duration(seconds: 3));
      _navigateToLoginPage(context);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Success', style: TextStyle(color: Colors.green)),
          ],
        ),
        content:
            Text('Account created successfully! Redirecting to login page...'),
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text('Error', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
