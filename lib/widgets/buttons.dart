import 'package:flutter/material.dart';

import '../core/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.height = 52,
    this.radius = 14,
    this.fontSize = 18,
    this.expand = true,
    this.minWidth = 0,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;
  final double radius;
  final double fontSize;

  /// When true the button fills the available width. Do not use inside a Row
  /// without Expanded; pass expand: false there.
  final bool expand;
  final double minWidth;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.maroon,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFB36B6B),
          disabledForegroundColor: Colors.white,
          minimumSize: Size(expand ? 0 : minWidth, height),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
        ),
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
                  Flexible(child: Text(label, textAlign: TextAlign.center)),
                ],
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
    this.radius = 14,
    this.fontSize = 18,
    this.expand = false,
    this.minWidth = 0,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final double fontSize;
  final bool expand;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.crimson,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.crimson, width: 1.4),
          minimumSize: Size(expand ? 0 : minWidth, height),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
