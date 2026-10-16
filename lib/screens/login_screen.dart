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

/// Simulated login (Figma "Frame 3"). No real authentication.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.notice});

  /// Optional message shown once (e.g. when a protected page was requested).
  final String? notice;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  bool _remember = false; // cosmetic only
  String? _idError;
  String? _passError;

  @override
  void initState() {
    super.initState();
    final notice = widget.notice;
    if (notice != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showFeedback(context, notice, isError: true);
      });
    }
  }

  @override
  void dispose() {
    _id.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _idError = null;
      _passError = null;
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    final result = AppState.instance.login(_id.text, _pass.text);
    setState(() => _loading = false);
    switch (result) {
      case LoginResult.success:
        showFeedback(context, 'تم تسجيل الدخول (محاكاة)');
        Nav.toRoot(context, Routes.dashboard);
      case LoginResult.notRegistered:
        setState(() => _idError = 'هذا البريد أو الرقم غير مسجل لدينا');
      case LoginResult.wrongPassword:
        setState(() => _passError = 'كلمة السر غير صحيحة');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthSplitLayout(
      title: 'تسجيل الدخول',
      subtitle: 'مرحباً بك في منصة شريان',
      onBack: () => Nav.toRoot(context, Routes.home),
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'البريد الالكتروني او رقم الجوال',
              hint: 'أدخل بريدك الالكتروني أو رقم الجوال',
              controller: _id,
              style: AppFieldStyle.outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.emailOrPhone,
              errorText: _idError,
              onChanged: (_) {
                if (_idError != null) setState(() => _idError = null);
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'كلمة السر',
              hint: 'ادخل كلمة السر',
              controller: _pass,
              isPassword: true,
              style: AppFieldStyle.outlined,
              textInputAction: TextInputAction.done,
              validator: Validators.loginPassword,
              errorText: _passError,
              onChanged: (_) {
                if (_passError != null) setState(() => _passError = null);
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _remember = !_remember),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? false)),
                      const Text('تذكرني', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(Routes.forgot),
                  style: TextButton.styleFrom(foregroundColor: AppColors.crimson),
                  child: const Text('نسيت كلمة السر؟', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            PrimaryButton(label: 'تسجيل الدخول', loading: _loading, radius: 12, onPressed: _submit),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('ليس لديك حساب ؟', style: TextStyle(fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(Routes.register),
                  style: TextButton.styleFrom(foregroundColor: AppColors.crimson),
                  child: const Text('سجل الان', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const DemoNotice(
              'نسخة تجريبية بدون مصادقة حقيقية. الحساب التجريبي: '
              '${AppState.demoEmail} / ${AppState.demoPassword}',
            ),
          ],
        ),
      ),
    );
  }
}
