import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final bool emptyAllowed;

  const TextInput({
    super.key, 
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.emptyAllowed = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (emptyAllowed) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer $label';
        }
        return null;
      },
    );
  }
}