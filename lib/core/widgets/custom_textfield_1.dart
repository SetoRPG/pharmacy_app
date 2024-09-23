import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color:
                    _focusNode.hasFocus ? const Color(0xFF010C80) : Colors.grey,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(0xFF010C80),
          ),
        ),
      ),
      style: const TextStyle(color: Color(0xFF010C80)),
    );
  }
}
