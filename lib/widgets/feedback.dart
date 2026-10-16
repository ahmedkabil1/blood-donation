import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Success / error snackbar used across the app.
void showFeedback(BuildContext context, String message, {bool isError = false}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: isError ? AppColors.crimson : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
}

/// Small banner that clearly marks a flow as a frontend demonstration.
class DemoNotice extends StatelessWidget {
  const DemoNotice(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFB74D)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Color(0xFFE65100)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: Color(0xFF5D4037), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
