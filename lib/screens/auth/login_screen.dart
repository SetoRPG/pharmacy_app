// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
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
        const SnackBar(content: Text("Vui lòng nhập cả email và mật khẩu.")),
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
                "Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.")),
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
                            _showForgotPasswordDialog(context);
                          },
                          child:
                              const CustomText(text: 'Quên mật khẩu', size: 14),
                        ),
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
                'Đăng Nhập',
                style: TextStyle(
                  color: Color.fromRGBO(92, 92, 92, 1), // Text color
                ),
              ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Khôi phục mật khẩu"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Vui lòng nhập email của bạn để nhận mật khẩu."),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  _sendPasswordToEmail(email);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Vui lòng nhập email hợp lệ."),
                  ));
                }
              },
              child: const Text("Gửi"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendPasswordToEmail(String email) async {
    try {
      // Query the `users` collection to find the user by email
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // Use Firebase Functions or another email-sending service here
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Yêu cầu đặt lại mặt khẩu đã được gửi đến email của bạn."),
        ));
      } else {
        throw Exception("Không tìm thấy người dùng với email này.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi khi gửi email: $e"),
      ));
    }
  }
}
