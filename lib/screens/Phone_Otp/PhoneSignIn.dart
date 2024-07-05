import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seeker/widgets/button.dart';

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({super.key});

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            'Enter OTP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'We have sent an OTP to your phone. Please enter it below:',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6, // Assuming OTP is 6 digits
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'OTP Code',
                  hintText: 'Enter the OTP',
                  counterText: '', // Hide the character counter
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('OTP entered: ${_otpController.text}');
                // Add your OTP verification logic here
              },
              child: const Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_otpController.text.length == 6) {
                  Navigator.of(context).pop();
                  print('OTP entered: ${_otpController.text}');
                  // Add your OTP verification logic here
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please enter a valid 6-digit OTP.'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/PhoneOtp.json', // Make sure to include your Lottie file in the assets directory
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: const Icon(Icons.phone),
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                ),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20),
              Button(
                onTap: () {
                  String phoneNumber = _phoneController.text;
                  print('Phone number entered: $phoneNumber');
                  _showOtpDialog();
                },
                name: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
