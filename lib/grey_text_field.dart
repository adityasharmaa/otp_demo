import 'package:flutter/material.dart';

class GreyTextField extends StatelessWidget {
  final String hint;
  final bool obscured, enabled;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLength;

  GreyTextField({
    @required this.controller,
    @required this.hint,
    this.obscured = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.maxLength = 200,
  });

  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(color: Colors.grey[300]),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        disabledBorder: _border,
        border: _border,
        focusedBorder: _border,
        enabledBorder: _border,
        filled: true,
        fillColor: Colors.grey[100],
        hintText: hint,
        counter: SizedBox(height: 0),
      ),
      obscureText: obscured,
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLength: maxLength,
    );
  }
}
