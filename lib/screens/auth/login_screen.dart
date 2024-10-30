// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/auth_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/core/widgets/custom_textfield_1.dart';
import 'package:pharmacy_app/screens/auth/register_screen.dart';
import 'package:pharmacy_app/screens/home/base_frame.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase authentication

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false; // For loading indicator

  // Function to handle login
  Future<void> _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    User? user = await _authController.signInWithEmailPassword(email, password);

    if (user != null) {
      // Login successful, navigate to the home screen or wherever you want
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BaseFrame(
            passedIndex: 0,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Login failed. Please check your credentials and email verification.")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensure the view resizes with the keyboard
      body: SafeArea(
        child: SingleChildScrollView(
          // Make the content scrollable
          child: Column(
            children: [
              // top half: logo
              Container(
                height: MediaQuery.of(context).size.height *
                    0.5, // Dynamic height for logo container
                alignment: Alignment.center,
                color: Colors.white,
                child: Image.asset('assets/logo.jpg'),
              ),

              // bottom half: login form
              Container(
                height: MediaQuery.of(context).size.height *
                    0.5, // Dynamic height for form container
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF20B6E8),
                      Color(0xFF16B2A5),
                    ],
                    stops: [0.6, 1],
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // EMAIL
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD
                    CustomTextField(
                      controller: _passController,
                      hintText: 'Mật khẩu',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),

                    // LOGIN BUTTON
                    _loginButton(context),

                    const SizedBox(height: 16),

                    // PASSWORD RECOVER & SIGN UP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              // PASS RECOVER
                            },
                            child: const CustomText(
                                text: 'Quên mật khẩu', size: 14)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const CustomText(text: 'Đăng kí', size: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _loginButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Color(0xFF757575),
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF616161),
            Color(0xFF757575),
            Color(0xFF9E9E9E),
            Color(0xFFEEEEEE),
          ],
          stops: [0, 0.01, 0.2, 1],
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ElevatedButton(
        onPressed: _isLoading
            ? null // Disable button when loading
            : () => _login(context),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor:
              Colors.transparent, // Transparent to show the gradient
          shadowColor: Colors.transparent, // Disable default button shadow
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Color(0xFF16B2A5)) // Show loading indicator
            : const Text(
                'Đăng nhập',
                style: TextStyle(
                  color: Color.fromRGBO(92, 92, 92, 1), // Text color
                ),
              ),
      ),
    );
  }
}
