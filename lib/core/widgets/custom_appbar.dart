import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/screens/auth/login_screen.dart';
import 'package:pharmacy_app/screens/detail/basket_screen.dart';
import 'package:pharmacy_app/screens/home/search_results.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final IconData logo; // Allows you to change the logo
  final bool showBackButton; // Controls back button visibility

  const CustomAppBar({
    super.key,
    required this.title,
    required this.logo,
    this.showBackButton = true, // Default to true
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final List<Map<String, dynamic>> _basketItems = [];
  final MedicineController _medicineController = MedicineController();
  bool _isLoading = true;
  late StreamSubscription<QuerySnapshot> _basketSubscription;

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
          .listen((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = snapshot.docs.first;
          List<dynamic> basket = userDoc['basket'] ?? [];
          List<Map<String, dynamic>> updatedBasketItems = [];

          for (var item in basket) {
            Map<String, dynamic>? medicine =
                await _medicineController.getMedicineById(item['medId']);
            if (medicine != null) {
              updatedBasketItems.add({
                'medicine': medicine,
                'quantity': item['quantity'],
              });
            }
          }

          setState(() {
            _basketItems
              ..clear()
              ..addAll(updatedBasketItems);
            _isLoading = false;
          });
        } else {
          setState(() {
            _basketItems.clear();
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _basketSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      automaticallyImplyLeading:
          widget.showBackButton, // Controls automatic back button
      leading: widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null, // Set leading to null if showBackButton is false
      title: Center(
        child: Row(
          children: [
            Icon(
              widget.logo, // Use the dynamic logo here
              color: Colors.white,
              shadows: const [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0), // Shadow color
                ),
                Shadow(
                  offset: Offset(-2.0, -2.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(100, 255, 255, 255), // Lighter shadow
                ),
              ],
            ),
            const SizedBox(width: 10),
            CustomText(text: widget.title, size: 20),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchResultPage(),
              ),
            );
          },
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  // Navigate to LoginPage if user is not authenticated
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                } else {
                  // Navigate to BasketPage if user is authenticated
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BasketPage(),
                    ),
                  );
                }
              },
            ),
            if (!_isLoading && _basketItems.isNotEmpty)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${_basketItems.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
