import 'package:chat_app/utilities/app_colors.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  void showSnackbar({required String message, bool isDelete = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isDelete ? AppColors.errorColor : AppColors.grey,
        ),
      );
  }
}
