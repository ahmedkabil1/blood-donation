import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';

enum AppFieldStyle { filled, outlined, pill }

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.text),
    );
  }
}

class ErrorText extends StatelessWidget {
  const ErrorText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(text, style: const TextStyle(color: AppColors.crimson, fontSize: 12.5)),
    );
  }
}

/// Reusable text field used by every form (3 visual styles from the designs).
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.prefixIcon,
    this.style = AppFieldStyle.filled,
    this.errorText,
    this.onChanged,
    this.readOnly = false,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.onFieldSubmitted,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final AppFieldStyle style;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  OutlineInputBorder _border(Color color, double radius, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final double radius = switch (style) {
      AppFieldStyle.filled => 8,
      AppFieldStyle.outlined => 14,
      AppFieldStyle.pill => 30,
    };
    final fill = switch (style) {
      AppFieldStyle.filled => AppColors.field,
      AppFieldStyle.outlined => Colors.white,
      AppFieldStyle.pill => const Color(0xFFD9D9D9),
    };
    final enabledColor = switch (style) {
      AppFieldStyle.filled => Colors.transparent,
      AppFieldStyle.outlined => AppColors.border,
      AppFieldStyle.pill => AppColors.crimson,
    };

    final field = TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && _obscure,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 15),
        filled: true,
        fillColor: fill,
        errorText: widget.errorText,
        errorMaxLines: 2,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: style == AppFieldStyle.filled ? 14 : 16),
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: AppColors.crimson) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.muted,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        border: _border(enabledColor, radius),
        enabledBorder: _border(enabledColor, radius),
        focusedBorder: _border(AppColors.crimson, radius, 1.6),
        errorBorder: _border(AppColors.crimson, radius),
        focusedErrorBorder: _border(AppColors.crimson, radius, 1.6),
      ),
    );

    if (widget.label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [FieldLabel(widget.label!), const SizedBox(height: 6), field],
    );
  }
}
