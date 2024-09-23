import 'package:flutter/material.dart';

class UnpressedButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const UnpressedButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 70, // Adjust this to control the minimum button size
        minHeight: 70, // Adjust this to control the minimum button size
      ),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Color(0xFF757575),
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0),
          BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0),
        ],
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEEEEEE),
              Color(0xFFE0E0E0),
              Color(0xFFBDBDBD),
              Color(0xFF9E9E9E),
            ],
            stops: [
              0.1,
              0.3,
              0.8,
              1
            ]),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.grey[600]),
            Text(
              text,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
