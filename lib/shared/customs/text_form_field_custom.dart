import 'package:flutter/material.dart';

class TextFormFieldCustoms extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? initialValue; // Make optional
  final String label;
  final String hint;
  final bool isRequired;
  final String requiredText;
  final bool isPassword;
  final Widget? suffixIcon;

  const TextFormFieldCustoms({
    super.key,
    this.controller,
    required this.keyboardType,
    this.initialValue, // Make optional
    required this.label,
    required this.hint,
    required this.isRequired,
    required this.requiredText,
    this.isPassword = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      initialValue: controller == null ? initialValue : null, // Ensure only one is set
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return requiredText;
        }
        return null;
      },
    );
  }
}
