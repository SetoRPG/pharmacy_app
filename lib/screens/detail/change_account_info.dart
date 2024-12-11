import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _newAddressController = TextEditingController();
  final TextEditingController _newPhoneController = TextEditingController();
  final TextEditingController _dobController =
      TextEditingController(); // Move out of GestureDetector
  DateTime? _newDateOfBirth;
  String? _newGender;

  bool _isLoading = true;
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the tree
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authController.getUserData();
      setState(() {
        _newNameController.text = userData['name'] ?? '';
        _newAddressController.text = userData['address'] ?? '';
        _newPhoneController.text = userData['phone'] ?? '';
        _newGender = userData['gender'];
        _newDateOfBirth = userData['dateOfBirth'];
        _dobController.text = _newDateOfBirth == null
            ? 'Ngày sinh'
            : "${_newDateOfBirth!.day}-${_newDateOfBirth!.month}-${_newDateOfBirth!.year}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lỗi tải thông tin người dùng: ${e.toString()}'),
      ));
    }
  }

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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFF16B2A5),
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _newNameController,
                        hintText: 'Họ Tên',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _newAddressController,
                        hintText: 'Địa chỉ',
                        prefixIcon: Icons.home,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _newPhoneController,
                        hintText: 'Số điện thoại',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller:
                                _dobController, // Use _dobController here
                            hintText: 'Ngày sinh',
                            prefixIcon: Icons.calendar_today,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _newGender,
                        hint: const Text('Giới tính'),
                        onChanged: (value) {
                          setState(() {
                            _newGender = value;
                          });
                        },
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Nam')),
                          DropdownMenuItem(value: 'Female', child: Text('Nữ')),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _updateButton(context, "Cập Nhật", _updateAccountDetails),
                      const SizedBox(height: 16),
                      _updateButton(context, "Đổi Mật Khẩu", () async {
                        try {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser == null) {
                            return;
                          }

                          final email = currentUser.email;
                          if (email == null) {
                            return;
                          }
                          // Query the `users` collection to find the user by email
                          QuerySnapshot userQuery = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .where('email', isEqualTo: email)
                              .limit(1)
                              .get();

                          if (userQuery.docs.isNotEmpty) {
                            // Use Firebase Functions or another email-sending service here
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Yêu cầu đặt lại mặt khẩu đã được gửi đến email của bạn."),
                            ));
                          } else {
                            throw Exception(
                                "Không tìm thấy người dùng với email này.");
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Lỗi khi gửi email: $e"),
                          ));
                        }
                      })
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

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _newDateOfBirth ??
          DateTime(2000), // Default to 2000 if no date is selected
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _newDateOfBirth = pickedDate;
        // Update the controller's text
        _dobController.text =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  void _updateAccountDetails() async {
    try {
      await _authController.updateUserDetails(
        newName: _newNameController.text.trim(),
        newPassword: null,
        newAddress: _newAddressController.text.trim(),
        newPhone: _newPhoneController.text.trim(),
        newDateOfBirth: _newDateOfBirth,
        newGender: _newGender,
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
