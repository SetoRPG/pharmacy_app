import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/screens/auth/login_screen.dart';
import 'package:pharmacy_app/screens/home/base_frame.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: FirebaseAuth.instance.currentUser == null
            ? Future.value(null)
            : FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          // Check connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while checking auth status
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            // If user is logged in, navigate to BaseFrame
            return const BaseFrame(passedIndex: 0);
          } else {
            // If no user is logged in, navigate to LoginScreen
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
