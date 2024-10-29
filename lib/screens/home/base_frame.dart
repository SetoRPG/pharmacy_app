import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/custom_bottom_navbar.dart';
import 'package:pharmacy_app/screens/home/account_screen.dart';
import 'package:pharmacy_app/screens/home/category_screen.dart';
import 'package:pharmacy_app/screens/home/home_screen.dart';
import 'package:pharmacy_app/screens/home/orders_sreeen.dart';

class BaseFrame extends StatefulWidget {
  final int passedIndex;
  final String? selectedCategory;

  const BaseFrame(
      {super.key, required this.passedIndex, this.selectedCategory});

  @override
  State<BaseFrame> createState() => _BaseFrameState();
}

class _BaseFrameState extends State<BaseFrame> {
  int _selectedIndex = 0;
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.passedIndex;
    selectedCategory = widget.selectedCategory ?? "All";
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Reset to "All" when navigating to the CategoryScreen tab
      if (index == 1) {
        selectedCategory = "All";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild screens so CategoryScreen always starts with the selectedCategory value
    final List<Widget> screens = [
      const HomeScreen(),
      CategoryScreen(initialCategory: selectedCategory),
      const OrdersScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          screens[_selectedIndex],
          CustomBottomNavBar(
            initialSelectedIndex: _selectedIndex,
            onButtonPressed: _onNavBarItemTapped,
          ),
        ],
      ),
    );
  }
}
