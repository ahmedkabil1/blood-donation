import 'package:flutter/material.dart';

import '../core/nav.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../core/validators.dart';
import '../state/app_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_layouts.dart';
import '../widgets/buttons.dart';
import '../widgets/feedback.dart';

/// Step 3 of the reset flow: new password (Figma "Frame 7").
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    AppState.instance.resetPassword(widget.email, _pass.text);
    showFeedback(context, 'تم تعيين كلمة المرور الجديدة (محاكاة). سجّل الدخول الآن.');
    Nav.toRoot(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardLayout(
      title: 'اعادة تعيين كلمة المرور',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('تعيين كلمة المرور الجديدة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800))),
            const Center(child: Text('أدخل كلمة المرور الجديدة لحسابك', style: TextStyle(fontSize: 14, color: AppColors.muted))),
            const SizedBox(height: 20),
            AppTextField(
              label: 'كلمة المرور الجديدة',
              controller: _pass,
              isPassword: true,
              style: AppFieldStyle.pill,
              prefixIcon: Icons.lock,
              validator: Validators.newPassword,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'تأكيد كلمة المرور',
              controller: _confirm,
              isPassword: true,
              style: AppFieldStyle.pill,
              prefixIcon: Icons.lock_outline,
              validator: (v) => Validators.confirmPassword(v, _pass.text),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 8),
            const Text(
              'يجب أن تحتوي كلمة المرور علي 8 احرف علي الأقل',
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
            const SizedBox(height: 18),
            PrimaryButton(label: 'تعيين كلمة المرور', loading: _loading, radius: 30, height: 56, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
