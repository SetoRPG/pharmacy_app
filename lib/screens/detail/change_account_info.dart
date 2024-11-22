import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/auth_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/core/widgets/custom_textfield_1.dart';

class ChangeAccountDetailsScreen extends StatefulWidget {
  const ChangeAccountDetailsScreen({super.key});

  @override
  State<ChangeAccountDetailsScreen> createState() =>
      _ChangeAccountDetailsScreenState();
}

class _ChangeAccountDetailsScreenState
    extends State<ChangeAccountDetailsScreen> {
  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        title: const CustomText(text: 'CẬP NHẬT THÔNG TIN', size: 20),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _newNameController,
                  hintText: 'Tên mới',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _newPasswordController,
                  hintText: 'Mật khẩu mới',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                _updateButton(context, "Cập Nhật", _updateAccountDetails),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _updateButton(BuildContext context, String text, Function onPressed) {
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

  void _updateAccountDetails() async {
    String newName = _newNameController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    if (newName.isEmpty && newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Vui lòng nhập tên hoặc mật khẩu mới để cập nhật.'),
      ));
      return;
    }

    // Check if the password length is less than 6 characters
    if (newPassword.isNotEmpty && newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Mật khẩu mới phải có ít nhất 6 ký tự.'),
      ));
      return; // Exit the function early
    }

    try {
      await _authController.updateUserDetails(
        newName: newName.isNotEmpty ? newName : null,
        newPassword: newPassword.isNotEmpty ? newPassword : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cập nhật thông tin tài khoản thành công!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cập nhật thất bại: ${e.toString()}'),
      ));
    }
  }
}
