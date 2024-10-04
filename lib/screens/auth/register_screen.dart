import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/auth_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/core/widgets/custom_textfield_1.dart';
import 'package:pharmacy_app/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        title: const CustomText(text: 'ĐĂNG KÍ TÀI KHOẢN MỚI', size: 20),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF20B6E8), Color(0xFF16B2A5)],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/logo.jpg', height: 170),
              ),
              _buildRegisterForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          hintText: 'Họ Tên',
          prefixIcon: Icons.person,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          hintText: 'Email',
          prefixIcon: Icons.email,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          hintText: 'Mật khẩu',
          prefixIcon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 32),
        _registerButton(context, "Đăng Ký", _registerUser),
      ],
    );
  }

  Widget _registerButton(
      BuildContext context, String text, Function onPressed) {
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
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(text,
            style: const TextStyle(color: Color.fromRGBO(92, 92, 92, 1))),
      ),
    );
  }

  void _registerUser() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    _authController.signUpWithEmailPassword(email, password, name).then((user) {
      if (user != null) {
        // Inform the user to check their email for verification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'A verification email has been sent to $email. Please verify your email.')),
        );

        // Optionally, check if the email is verified after some time
        _authController.isEmailVerified(user).then((isVerified) {
          if (isVerified) {
            // Email verified, proceed with login or other actions
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          } else {
            // Handle case where the email is not verified
            print("Email is not verified yet.");
          }
        });
      }
    }).catchError((error) {
      print("Error during registration: $error");
    });
  }
}
