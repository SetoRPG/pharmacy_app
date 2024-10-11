import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/custom_bottom_navbar.dart';
import 'package:pharmacy_app/screens/home/account_screen.dart';
import 'package:pharmacy_app/screens/home/category_screen.dart';
import 'package:pharmacy_app/screens/home/home_screen.dart';
import 'package:pharmacy_app/screens/home/orders_sreeen.dart';

class BaseFrame extends StatefulWidget {
  final int passedIndex;

  const BaseFrame({super.key, required this.passedIndex});

  @override
  State<BaseFrame> createState() => _BaseFrameState();
}

class _BaseFrameState extends State<BaseFrame> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.passedIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const OrdersScreen(),
    const AccountScreen(),
  ];

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          CustomBottomNavBar(
              initialSelectedIndex: _selectedIndex,
              onButtonPressed: _onNavBarItemTapped)
        ],
      ),
    );
  }
}
