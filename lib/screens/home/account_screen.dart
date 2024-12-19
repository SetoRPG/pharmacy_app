import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/auth_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/screens/detail/basket_screen.dart';
import 'package:pharmacy_app/screens/detail/change_account_info.dart';
import 'package:pharmacy_app/screens/detail/favorite_screen.dart';
import 'package:pharmacy_app/screens/detail/purchase_history.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _basketItemCount = 0; // Holds the count of basket items
  StreamSubscription<QuerySnapshot>? _basketSubscription;

  @override
  void initState() {
    super.initState();
    _listenToBasketChanges();
  }

  void _listenToBasketChanges() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _basketSubscription = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = snapshot.docs.first;
          List<dynamic> basket = userDoc['basket'] ?? [];
          setState(() {
            _basketItemCount = basket.length; // Update the basket item count
          });
        } else {
          setState(() {
            _basketItemCount = 0; // Reset if no items
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _basketSubscription?.cancel(); // Safely cancel the subscription
    super.dispose();
  }

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
            notificationCount: _basketItemCount, // Pass the item count
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => const BasketPage())),
              );
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
                    builder: ((context) => const PurchaseHistoryScreen())),
              );
            },
          ),
          const Divider(),
          _buildAccountOption(
            context,
            title: 'Sản phẩm yêu thích',
            icon: Icons.favorite,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const FavoriteProductsScreen())),
              );
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
                    builder: ((context) => const ChangeAccountDetailsScreen())),
              );
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
  Widget _buildAccountOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    Function()? onTap,
    int notificationCount = 0, // Optional notification count parameter
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF16B2A5)),
      title: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          if (notificationCount > 0)
            // Only show the notification if count > 0
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: const BoxDecoration(
                color: Color(0xFF16B2A5),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
