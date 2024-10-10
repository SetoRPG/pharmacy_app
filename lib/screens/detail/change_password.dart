import 'package:flutter/material.dart';

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
              'Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu cho người khác. Bạn có thể tạo mật khẩu từ 6 - 16 kí tự',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            buildPasswordField('Mật khẩu hiện tại', 'Nhập mật khẩu hiện tại'),
            buildPasswordField('Mật khẩu mới', 'Nhập mật khẩu mới'),
            buildPasswordField('Nhập lại mật khẩu', 'Nhập lại mật khẩu mới'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lưu thay đổi mật khẩu logic
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
            suffixIcon: const Icon(Icons.visibility_off),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
