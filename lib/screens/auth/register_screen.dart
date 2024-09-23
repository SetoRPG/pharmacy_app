import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/custom_textfield_1.dart';
import 'package:pharmacy_app/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ĐĂNG KÍ TÀI KHOẢN MỚI',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF20B6E8),
                Color(0xFF16B2A5),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //LOGO
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/logo.jpg',
                  height: 170,
                ),
              ),

              //FORM
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const CustomTextField(
                      hintText: 'Họ Tên',
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    const CustomTextField(
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    const CustomTextField(
                      hintText: 'Số Điện Thoại',
                      prefixIcon: Icons.phone,
                    ),
                    const SizedBox(height: 16),
                    const CustomTextField(
                      hintText: 'Mật Khẩu',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    const CustomTextField(
                      hintText: 'Xác Nhận Mật khẩu',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),

                    // SIGNUP BUTTON
                    _registerButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _registerButton(BuildContext context) {
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
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Đăng Ký',
          style: TextStyle(color: Color.fromRGBO(92, 92, 92, 1)),
        ),
      ),
    );
  }
}
