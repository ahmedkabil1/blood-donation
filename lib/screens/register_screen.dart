import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/nav.dart';
import '../core/routes.dart';
import '../core/validators.dart';
import '../state/app_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_layouts.dart';
import '../widgets/buttons.dart';
import '../widgets/feedback.dart';

/// Simulated sign-up (Figma "Frame 4"). Account lives in memory only.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _emailError;
  String? _phoneError;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _emailError = null;
      _phoneError = null;
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    final result = AppState.instance.register(
      fullName: _name.text,
      phone: _phone.text,
      email: _email.text,
      password: _pass.text,
    );
    setState(() => _loading = false);
    switch (result) {
      case RegisterResult.success:
        showFeedback(context, 'تم إنشاء الحساب (محاكاة). سجّل الدخول الآن.');
        Nav.toRoot(context, Routes.login);
      case RegisterResult.emailTaken:
        setState(() => _emailError = 'هذا البريد الإلكتروني مسجل بالفعل');
      case RegisterResult.phoneTaken:
        setState(() => _phoneError = 'رقم الهاتف مسجل بالفعل');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthSplitLayout(
      title: 'إنشاء حساب جديد',
      subtitle: 'ابدا رحلتك في إنقاذ الحياة',
      onBack: () => Nav.toRoot(context, Routes.login),
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'الإسم بالكامل',
              hint: 'أدخل الإسم بالكامل',
              controller: _name,
              style: AppFieldStyle.outlined,
              textInputAction: TextInputAction.next,
              validator: Validators.fullName,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'رقم الهاتف',
              hint: 'أدخل رقم الهاتف',
              controller: _phone,
              style: AppFieldStyle.outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]'))],
              validator: Validators.phone,
              errorText: _phoneError,
              onChanged: (_) {
                if (_phoneError != null) setState(() => _phoneError = null);
              },
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'البريد الالكتروني',
              hint: 'أدخل بريدك الالكتروني',
              controller: _email,
              style: AppFieldStyle.outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
              errorText: _emailError,
              onChanged: (_) {
                if (_emailError != null) setState(() => _emailError = null);
              },
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'كلمة السر',
              hint: 'ادخل كلمة السر (8 أحرف على الأقل)',
              controller: _pass,
              isPassword: true,
              style: AppFieldStyle.outlined,
              textInputAction: TextInputAction.done,
              validator: Validators.newPassword,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 18),
            PrimaryButton(label: 'إنشاء حساب', loading: _loading, radius: 12, onPressed: _submit),
            const SizedBox(height: 12),
            const DemoNotice('نسخة تجريبية: الحساب يُحفظ في ذاكرة التطبيق فقط ويُحذف عند إعادة التشغيل.'),
          ],
        ),
      ),
    );
  }
}
