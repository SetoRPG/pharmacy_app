// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Thêm import này
import 'dart:io'; // Để sử dụng File

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  DateTime? _selectedDate;
  File? _image; // Biến để lưu trữ ảnh đã chọn

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery); // Chọn ảnh từ thư viện
    // Nếu bạn muốn cho phép chụp ảnh, bạn có thể thêm tùy chọn sau:
    // final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : null, // Hiển thị ảnh nếu có
                child: _image == null
                    ? const Icon(Icons.person, size: 50)
                    : null, // Hiển thị biểu tượng nếu không có ảnh
              ),
            ),
            TextButton(
              onPressed: _pickImage, // Gọi hàm chọn ảnh
              child: const Text('Cập nhật ảnh',
                  style: TextStyle(color: Colors.blue)),
            ),
            const SizedBox(height: 20),
            buildTextField('Họ và Tên', 'Khach hang'),
            buildDateField(context, 'Ngày sinh', _dateController),
            buildDropdownField('Giới tính', ['Nam', 'Nữ', 'Khác']),
            buildTextField('Số điện thoại', '0774008406', enabled: false),
            buildTextField('Email', 'Nhập email'),
            const SizedBox(height: 20),
            buildChangePasswordButton(context),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic lưu thay đổi
                if (_selectedDate != null && _isOlderThan12(_selectedDate!)) {
                  // Tiến hành lưu thông tin
                } else {
                  // Hiển thị thông báo lỗi
                  _showErrorDialog(context);
                }
              },
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String placeholder,
      {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        TextField(
          enabled: enabled,
          decoration: InputDecoration(
            hintText: placeholder,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildDateField(
      BuildContext context, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: const InputDecoration(
            hintText: 'Chọn ngày sinh',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
                controller.text = _dateFormat.format(pickedDate);
              });
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildDropdownField(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        DropdownButtonFormField<String>(
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildChangePasswordButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
        );
      },
      child: const Text('Đổi mật khẩu'),
    );
  }

  bool _isOlderThan12(DateTime date) {
    final today = DateTime.now();
    final age = today.year - date.year;
    return age > 12 ||
        (age == 12 && today.month > date.month) ||
        (age == 12 && today.month == date.month && today.day >= date.day);
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content:
              const Text('Bạn phải lớn hơn 12 tuổi để sử dụng ứng dụng này.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Màn hình "Thay đổi mật khẩu"
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thay đổi mật khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text(
              'Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu cho người khác. Bạn có thể tạo mật khẩu từ 6 - 16 kí tự.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            buildPasswordField('Mật khẩu hiện tại', 'Nhập mật khẩu hiện tại'),
            buildPasswordField('Mật khẩu mới', 'Nhập mật khẩu mới'),
            buildPasswordField('Nhập lại mật khẩu', 'Nhập lại mật khẩu mới'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic lưu mật khẩu mới
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: placeholder,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
