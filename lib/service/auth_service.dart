import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seeker/model/user_model.dart';


class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmail(String email, String pass) async {
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pass);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
      throw Exception(e.message);
    }
  }

  Future<UserCredential> signUpWithEmail(
      String email, String password, String name) async {
    try {
      UserCredential userinfo = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel user =
          UserModel(email: email, username: name, uid: userinfo.user!.uid);
      await firestore
          .collection('users')
          .doc(userinfo.user!.uid)
          .set(user.toJson());
      return userinfo;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await firebaseAuth.signOut();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }
}
