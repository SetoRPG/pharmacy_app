import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;

  const CustomText({super.key, required this.text, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: size, // Adjust as needed
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(
            offset: Offset(2.0, 2.0), // Position of the shadow (right and down)
            blurRadius: 3.0, // Blur radius of the shadow
            color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
          ),
          Shadow(
            offset:
                Offset(-2.0, -2.0), // Position of a second shadow (left and up)
            blurRadius: 3.0,
            color: Color.fromARGB(
                100, 255, 255, 255), // A lighter shadow for the 3D effect
          ),
        ],
      ),
    );
  }
}
