import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seeker/service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  AuthService _service = AuthService();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _service.signInWithEmail(email, password);
      return userCredential;
    } catch (e) {
      throw Exception('Sign in with email failed: $e');
    }
  }

  Future<UserCredential> signUpWithEmail(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _service.signUpWithEmail(email, password, name);
      return userCredential;
    } catch (e) {
      throw Exception('Sign up with email failed: $e');
    }
  }

  void signInWithPhone(String phoneNumber, String name, String email, BuildContext context) { 
    try {
      _service.signInWithPhone(phoneNumber, name, email, context);
    } catch (e) {
      throw Exception('Sign in with phone failed: $e');
    }
  }

  void verifyOtp(String verificationId, String otp, Function onSuccess, String name, String email) {
    try {
      _service.verifyOtp(
        verificationId: verificationId,
        otp: otp,
        onSuccess: onSuccess,
        name: name,
        email: email,
      );
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _service.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }
}
