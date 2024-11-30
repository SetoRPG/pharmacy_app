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
  Future<User?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String userName,
    required String address,
    required String phone,
    required DateTime dateOfBirth,
    required String gender,
  }) async {
    try {
      // Create the user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Send email verification
        await user.sendEmailVerification();

        // Generate custom ID for the user
        String customId = _generateCustomId();

        // Save user data to Firestore in "users" collection
        await _firestore.collection("users").doc(customId).set({
          'id': customId,
          'name': userName,
          'email': email,
          'password': password, // Consider encrypting the password
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': false,
          'basket': [],
          'role': 'CUSTOMER',
        });

        // Save additional customer data in the "customers" collection
        await _firestore.collection("customers").doc(customId).set({
          'cusId': customId,
          'cusName': userName,
          'cusEmail': email,
          'cusAddress': address,
          'cusDateOfBirth': Timestamp.fromDate(dateOfBirth),
          'cusGender': gender,
          'cusPhone': phone,
          'cusLoyaltyPoints': 0,
          'cusTransaction': [],
        });

        // Update display name in Firebase Auth
        await user.updateDisplayName(userName);
        await user.reload();
        user = _auth.currentUser;
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

  // Update user details: name and/or password
  Future<void> updateUserDetails({
    String? newName,
    String? newPassword,
    String? newAddress,
    String? newPhone,
    DateTime? newDateOfBirth,
    String? newGender,
  }) async {
    User? user = _auth.currentUser; // Get the currently authenticated user
    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    String email = user.email ?? "";
    if (email.isEmpty) {
      throw Exception("User email not available.");
    }

    try {
      // Get document reference for both collections
      // Query the `users` collection for the document with the matching email
      QuerySnapshot userQuery = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception("Không tìm thấy tài liệu người dùng.");
      }

      // Query the `customers` collection for the document with the matching cusEmail
      QuerySnapshot customerQuery = await _firestore
          .collection("customers")
          .where("cusEmail", isEqualTo: email)
          .limit(1)
          .get();

      if (customerQuery.docs.isEmpty) {
        throw Exception("Không tìm thấy tài liệu khách hàng.");
      }

      // Extract document references
      DocumentReference userDocRef = userQuery.docs.first.reference;
      DocumentReference customerDocRef = customerQuery.docs.first.reference;

      // Prepare the update data for users collection
      Map<String, dynamic> userUpdateData = {};
      if (newName != null && newName.isNotEmpty) {
        userUpdateData['name'] = newName;
      }
      if (newPassword != null && newPassword.isNotEmpty) {
        userUpdateData['password'] = newPassword;
      }

      // Prepare the update data for customers collection
      Map<String, dynamic> customerUpdateData = {};
      if (newName != null && newName.isNotEmpty) {
        customerUpdateData['cusName'] = newName;
      }
      if (newAddress != null && newAddress.isNotEmpty) {
        customerUpdateData['cusAddress'] = newAddress;
      }
      if (newPhone != null && newPhone.isNotEmpty) {
        customerUpdateData['cusPhone'] = newPhone;
      }
      if (newDateOfBirth != null) {
        customerUpdateData['cusDateOfBirth'] =
            Timestamp.fromDate(newDateOfBirth);
      }
      if (newGender != null && newGender.isNotEmpty) {
        customerUpdateData['cusGender'] = newGender;
      }

      // Update both collections
      if (userUpdateData.isNotEmpty) {
        await userDocRef.update(userUpdateData);
      }

      if (customerUpdateData.isNotEmpty) {
        await customerDocRef.update(customerUpdateData);
      }

      // Optionally update the Firebase Auth password and name
      if (newPassword != null && newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }
      if (newName != null && newName.isNotEmpty) {
        await user.updateDisplayName(newName);
      }
    } catch (e) {
      debugPrint("Error updating user details: $e");
      throw Exception("Failed to update user details.");
    }
  }

  Future<String?> getUsernameByEmail() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String email = user.email ?? "";

      try {
        // Query the Firestore collection to find the document with the matching email
        QuerySnapshot snapshot = await _firestore
            .collection("users")
            .where('email', isEqualTo: email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Extract the 'name' field from the first matching document
          String username = snapshot.docs.first.get('name');
          return username;
        } else {
          debugPrint("No user document found for email: $email");
          return null; // No document found
        }
      } catch (e) {
        debugPrint("Error retrieving username: $e");
        return null; // Return null in case of an error
      }
    }

    debugPrint("No authenticated user found.");
    return null; // Return null if no user is logged in
  }

  Future<Map<String, dynamic>> getUserData() async {
    User? user = _auth.currentUser; // Get the currently authenticated user
    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    String email = user.email ?? "";
    if (email.isEmpty) {
      throw Exception("User email not available.");
    }

    try {
      // Get data from the 'users' collection
      QuerySnapshot usersSnapshot = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (usersSnapshot.docs.isEmpty) {
        throw Exception("User not found in 'users' collection.");
      }

      // Get data from the 'customers' collection
      QuerySnapshot customersSnapshot = await _firestore
          .collection("customers")
          .where("cusEmail", isEqualTo: email)
          .get();

      if (customersSnapshot.docs.isEmpty) {
        throw Exception("User not found in 'customers' collection.");
      }

      // Assuming both collections contain one matching document each
      var userData = usersSnapshot.docs.first.data() as Map<String, dynamic>;
      var customerData =
          customersSnapshot.docs.first.data() as Map<String, dynamic>;

      // Merge user data from both collections
      return {
        'name': userData['name'],
        'email': userData['email'],
        'password': userData['password'],
        'address': customerData['cusAddress'],
        'phone': customerData['cusPhone'],
        'dateOfBirth': customerData['cusDateOfBirth']
            .toDate(), // assuming it's a timestamp
        'gender': customerData['cusGender'],
        'loyaltyPoints': customerData['cusLoyaltyPoints'],
      };
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      throw Exception("Failed to fetch user data.");
    }
  }
}
