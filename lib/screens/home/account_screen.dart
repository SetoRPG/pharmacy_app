import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/auth_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/screens/detail/basket_screen.dart';
import 'package:pharmacy_app/screens/detail/change_account_info.dart';
import 'package:pharmacy_app/screens/detail/favorite_screen.dart';
import 'package:pharmacy_app/screens/detail/purchase_history.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'TÀI KHOẢN',
        logo: Icons.person,
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAccountOption(
            context,
            title: 'Giỏ hàng',
            icon: Icons.shopping_cart,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const BasketPage())));
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Lịch sử mua hàng',
            icon: Icons.history,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const PurchaseHistoryScreen())));
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Sản phảm yêu thích',
            icon: Icons.favorite,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const FavoriteProductsScreen())));
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Cập nhật thông tin',
            icon: Icons.settings,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          const ChangeAccountDetailsScreen())));
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Đăng xuất',
            icon: Icons.logout,
            onTap: () async {
              final authController = AuthController();
              await authController.signOut(context);
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
      leading: Icon(icon, color: const Color(0xFF16B2A5)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
