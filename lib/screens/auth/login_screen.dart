import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/custom_textfield_1.dart';
import 'package:pharmacy_app/screens/auth/register_screen.dart';
import 'package:pharmacy_app/screens/home/base_frame.dart';

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
                  color: Colors.white, //COLOR
                  child: Image.asset('assets/logo.jpg')),
            ),

            // bottom half: login form
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 10, spreadRadius: 5)
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                  gradient: LinearGradient(colors: [
                    Color(0xFF20B6E8),
                    Color(0xFF16B2A5),
                  ], stops: [
                    0.6,
                    1
                  ]),
                ),
                padding: const EdgeInsets.all(20.0),
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
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),

                    //LOGIN BUTTON
                    _loginButton(context),

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
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const RegisterScreen())));
                          },
                          child: const Text(
                            'Đăng kí',
                            style: TextStyle(color: Colors.white),
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

  Container _loginButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.white,
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0),
          BoxShadow(
              color: Color(0xFF757575),
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => const BaseFrame())),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors
              .transparent, // Make the button itself transparent so the gradient shows
          shadowColor:
              Colors.transparent, // Disable ElevatedButton's default shadow
        ),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(
              color:
                  Color.fromRGBO(92, 92, 92, 1)), // Adjust text color if needed
        ),
      ),
    );
  }
}
