import 'package:chat_app/utilities/app_colors.dart';
import 'package:flutter/material.dart';

class UserNotes extends StatelessWidget {
  const UserNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Text(
          'Notes:\n'
          '1. Double tap on a message to copy it to clipboard.\n'
          '2. Long press on message to delete it (works on your messages only).',
          style: TextStyle(fontSize: 10, color: AppColors.white),
        ),
      ],
    );
  }
}
