import 'package:chat_app/utilities/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.validator,
    this.obscureText = false,
  });
  final String labelText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: validator,
      controller: controller,
      cursorColor: AppColors.white,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        label: Text(labelText, style: TextStyle(color: AppColors.white)),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightBlue),
        ),
      ),
    );
  }
}
