import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/screens/home/search_results.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8, // Adds shadow to the AppBar
        shadowColor: Colors.black, // Customize shadow color

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

        title: const Center(
            child: Row(
          children: [
            Icon(
              Icons.person,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(
                      2.0, 2.0), // Position of the shadow (right and down)
                  blurRadius: 3.0, // Blur radius of the shadow
                  color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
                ),
                Shadow(
                  offset: Offset(
                      -2.0, -2.0), // Position of a second shadow (left and up)
                  blurRadius: 3.0,
                  color: Color.fromARGB(
                      100, 255, 255, 255), // A lighter shadow for the 3D effect
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            CustomText(text: 'CÀI ĐẶT TÀI KHOẢN', size: 20),
          ],
        )),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchResultPage(),
                ),
              );
            },
          ),
        ],
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
            onTap: () async {},
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
