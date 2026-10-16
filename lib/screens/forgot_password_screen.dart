import 'package:flutter/material.dart';

import '../core/nav.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../core/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_layouts.dart';
import '../widgets/buttons.dart';
import '../widgets/feedback.dart';

/// Step 1 of the reset flow: enter the email (Figma "Frame 5").
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.otp, arguments: _email.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardLayout(
      title: 'استعاده كلمه المرور',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'ادخل البريد الاكتروني المسجل لارسال كود التحقق',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, height: 1.6),
            ),
            const SizedBox(height: 24),
            AppTextField(
              hint: 'ex: mail@gmail.com',
              controller: _email,
              style: AppFieldStyle.pill,
              prefixIcon: Icons.mark_email_unread_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            PrimaryButton(label: 'إرسال', loading: _loading, expand: false, minWidth: 240, radius: 30, onPressed: _submit),
            const SizedBox(height: 16),
            const DemoNotice('محاكاة فقط: لن يتم إرسال أي بريد إلكتروني حقيقي.'),
            TextButton(
              onPressed: () => Nav.toRoot(context, Routes.login),
              style: TextButton.styleFrom(foregroundColor: AppColors.crimson),
              child: const Text('العودة لتسجيل الدخول', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
