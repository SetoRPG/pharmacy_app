// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/screens/auth/login_screen.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Custom ID generator
  String _generateCustomId() {
    final now = DateTime.now();
    String datePart =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    String randomPart = (Random().nextInt(90) + 10)
        .toString(); // Generates a number between 10 and 99
    return "CUS$datePart$randomPart";
  }

  // Step 1: Register user with email and password and send email verification
  Future<User?> signUpWithEmailPassword(
      String email, String password, String userName) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Send email verification
        await user.sendEmailVerification();

        // Create custom ID and save user to Firestore
        String customId = _generateCustomId();
        await _firestore.collection("users").doc(customId).set({
          'id': customId,
          'name': userName,
          'email': email,
          'password': password, // Consider encrypting the password
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': false,
          'basket': []
        });

        // Update display name in Firebase Auth
        await user.updateDisplayName(userName);
        await user.reload();
        user = _auth.currentUser;

        // You can notify the user to check their email for verification
      }
      return user;
    } on FirebaseAuthException {
      return null;
    }
  }

  // Step 2: Check if email is verified
  Future<bool> isEmailVerified(User? user) async {
    if (user != null) {
      await user.reload(); // Refresh the user's info
      return user.emailVerified;
    }
    return false;
  }

  // Step 3: Resend verification email
  Future<void> resendVerificationEmail(User? user) async {
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Step 4: Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null && user.emailVerified) {
        // Email is verified
        return user;
      } else {
        // Email not verified or user is null
        return null;
      }
    } on FirebaseAuthException {
      return null;
    }
  }

  //Logout
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate to the LoginScreen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {}
  }
}
