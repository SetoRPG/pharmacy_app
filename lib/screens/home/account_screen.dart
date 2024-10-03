import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt tài khoản'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF20B6E8), Color(0xFF16B2A5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAccountOption(
            context,
            title: 'Chỉnh sửa thông tin cá nhân',
            icon: Icons.person,
            onTap: () {
              // Navigate to personal info editing screen
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Đổi mật khẩu',
            icon: Icons.lock,
            onTap: () {
              // Navigate to change password screen
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Phương thức thanh toán',
            icon: Icons.payment,
            onTap: () {
              // Navigate to payment methods screen
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Địa chỉ giao hàng',
            icon: Icons.location_on,
            onTap: () {
              // Navigate to manage delivery address screen
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Thông báo',
            icon: Icons.notifications,
            onTap: () {
              // Navigate to notification settings screen
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Đăng xuất',
            icon: Icons.logout,
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  // Helper method to build account setting options
  Widget _buildAccountOption(BuildContext context,
      {required String title,
      required IconData icon,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
