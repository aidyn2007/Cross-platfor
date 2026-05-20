import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// 1
class UserDao extends ChangeNotifier {
  String errorMsg = 'An error has occurred.';
  bool _signedOutLocally = false;

  // 2
  final auth = FirebaseAuth.instance;

  // 1
  bool isLoggedIn() {
    return !_signedOutLocally && auth.currentUser != null;
  }

  // 2
  String? userId() {
    return auth.currentUser?.uid;
  }

  //3
  String? email() {
    return auth.currentUser?.email;
  }

  // 1
  Future<String?> signup(String email, String password) async {
    try {
      // 2
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _signedOutLocally = false;
      // 3
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      // 4
      if (email.isEmpty) {
        errorMsg = 'Email is blank.';
      } else if (password.isEmpty) {
        errorMsg = 'Password is blank.';
      } else if (e.code == 'weak-password') {
        errorMsg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMsg = 'The account already exists for that email.';
      }
      return errorMsg;
    } catch (e) {
      // 5
      log(e.toString());
      return e.toString();
    }
  }

  // 1
  Future<String?> login(String email, String password) async {
    try {
      // 2
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _signedOutLocally = false;
      // 3
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      // 4
      if (email.isEmpty) {
        errorMsg = 'Email is blank.';
      } else if (password.isEmpty) {
        errorMsg = 'Password is blank.';
      } else if (e.code == 'invalid-email') {
        errorMsg = 'Invalid email.';
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        errorMsg = 'Invalid credentials.';
      } else if (e.code == 'user-not-found') {
        errorMsg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMsg = 'Wrong password provided for that user.';
      }
      return errorMsg;
    } catch (e) {
      // 5
      log(e.toString());
      return e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      _signedOutLocally = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code != 'keychain-error') {
        rethrow;
      }

      _signedOutLocally = true;
      notifyListeners();
    }
  }
}
