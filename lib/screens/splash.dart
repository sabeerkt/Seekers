import 'package:flutter/material.dart';
import 'package:seeker/auth/auth_gate.dart';
import 'package:seeker/screens/Login_Page/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization code here
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/amzonpay.png",
          width: 200.0,
          height: 200.0,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
