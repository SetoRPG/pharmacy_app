import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/screens/auth/login_screen.dart';
import 'package:pharmacy_app/screens/detail/basket_screen.dart';
import 'package:pharmacy_app/screens/home/search_results.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData logo; // Allows you to change the logo
  final bool showBackButton; // New parameter to control back button visibility

  const CustomAppBar({
    super.key,
    required this.title,
    required this.logo,
    this.showBackButton = true, // Default to true
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
          showBackButton, // Controls automatic back button
      leading: showBackButton
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
              logo, // Use the dynamic logo here
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
            CustomText(text: title, size: 20),
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
      ],
    );
  }
}
