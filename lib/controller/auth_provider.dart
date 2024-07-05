import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seeker/service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthService service = AuthService();

  Future<UserCredential> signInWithEmail(String email, String pass) {
    return service.signInWithEmail(email, pass);
  }

  Future<UserCredential> signUpWithEmail(
      String email, String password, String name) {
    return service.signUpWithEmail(email, password, name);
  }

  Future<void> signOut() {
    return service.signOut();
  }
}
