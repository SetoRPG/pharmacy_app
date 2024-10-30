// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/unpressed_button.dart';
import 'package:pharmacy_app/core/widgets/pressed_button.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int initialSelectedIndex;
  final ValueChanged<int> onButtonPressed;

  const CustomBottomNavBar({
    super.key,
    this.initialSelectedIndex = 0,
    required this.onButtonPressed,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  late int selectedButtonIndex;
  bool isNavBarOpen = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    selectedButtonIndex = widget.initialSelectedIndex;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pressButton(int index) {
    setState(() {
      selectedButtonIndex = index;
    });
    widget.onButtonPressed(index);
  }

  void _toggleNavBar() {
    setState(() {
      isNavBarOpen = !isNavBarOpen;
      isNavBarOpen ? _controller.reverse() : _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // NAVBAR
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: 0,
          right: 0,
          bottom: isNavBarOpen
              ? 0
              : -108, // Move the navbar fully off-screen when closed
          child: Container(
            height: 108, // Fixed height
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              boxShadow: isNavBarOpen
                  ? const [
                      BoxShadow(
                        color: Color(0xFF616161),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                    ]
                  : [],
              color: Colors.grey[400],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavBarButton(Icons.home, 'Trang chủ', 0),
                _buildNavBarButton(Icons.category, 'Danh mục', 1),
                _buildNavBarButton(Icons.receipt, 'Đơn hàng', 2),
                _buildNavBarButton(Icons.person, 'Tài khoản', 3),
              ],
            ),
          ),
        ),
        // OPEN - CLOSE NAVBAR BUTTON
        Positioned(
          right: 20,
          bottom: isNavBarOpen ? 108 : 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: FloatingActionButton(
              elevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              hoverElevation: 0,
              backgroundColor: Colors.transparent,
              onPressed: _toggleNavBar,
              child: Icon(
                isNavBarOpen
                    ? Icons.keyboard_double_arrow_down
                    : Icons.keyboard_double_arrow_up,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavBarButton(IconData icon, String text, int index) {
    bool isSelected = selectedButtonIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _pressButton(index),
        child: isSelected
            ? PressedButton(
                icon: icon,
                text: text,
              )
            : UnpressedButton(
                icon: icon,
                text: text,
              ),
      ),
    );
  }
}
