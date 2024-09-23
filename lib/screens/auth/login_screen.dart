import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/custom_textfield_1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // top half: logo
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  color: const Color(0xFF010C80), //COLOR
                  child: Image.asset('assets/logo.jpg')),
            ),

            // bottom half: login form
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //EMAIL
                    const CustomTextField(
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 16),

                    //PASSWORD
                    const CustomTextField(
                      hintText: 'Mật khẩu',
                      prefixIcon: Icons.lock,
                    ),
                    const SizedBox(height: 16),

                    //LOGIN BUTTON
                    ElevatedButton(
                      onPressed: () {
                        //LOGIN FUNCTION
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Login'),
                    ),

                    const SizedBox(height: 16),

                    //PASSWORD RECOVER & SIGN UP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // PASS RECOVER
                          },
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(color: Color(0xFF010C80)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // SIGN UP
                          },
                          child: const Text(
                            'Đăng kí',
                            style: TextStyle(color: Color(0xFF010C80)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
