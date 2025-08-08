
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.placeholder,
    this.isPassword = false,
    this.keyboardType,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      enabled: enabled,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 13,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}
