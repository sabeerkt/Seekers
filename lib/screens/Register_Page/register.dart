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
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                      'assets/register.json', // Replace with your image path
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
                          borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                          borderSide: const BorderSide(color: Colors.grey), // Add a border color
                        ),
                        filled: true,
                        fillColor: Colors.white, // Set a background color
                        prefixIcon: const Icon(Icons.person), // Optionally add an icon
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
                      borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                      borderSide: const BorderSide(color: Colors.grey), // Add a border color
                    ),
                    filled: true,
                    fillColor: Colors.white, // Set a background color
                    prefixIcon: const Icon(Icons.email), // Optionally add an icon
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true, // This hides the entered text for passwords
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock), // Changed icon to lock icon
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
                  obscureText: true, // This hides the entered text for passwords
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock), // Changed icon to lock icon
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
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await Provider.of<AuthProvider>(context, listen: false).signUpWithEmail(
            _emailController.text, _passwordController.text, _usernameController.text);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Account created successfully! Redirecting to login page...'),
          ),
        );
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Passwords Not Same')));
    }
  }
}
