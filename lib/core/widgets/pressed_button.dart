import 'package:flutter/material.dart';

class PressedButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const PressedButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 70, // Adjust this value to control the minimum size
        minHeight: 70, // Adjust this value to control the minimum size
      ),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.white,
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0),
          BoxShadow(
              color: Color(0xFF757575),
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0),
        ],
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF616161),
              Color(0xFF757575),
              Color(0xFF9E9E9E),
              Color(0xFFEEEEEE),
            ],
            stops: [
              0,
              0.1,
              0.3,
              1
            ]),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 24, color: const Color.fromARGB(255, 53, 255, 245)),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 10, color: Color.fromARGB(255, 53, 255, 245)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
