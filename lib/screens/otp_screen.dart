import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/routes.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_layouts.dart';
import '../widgets/buttons.dart';
import '../widgets/feedback.dart';

/// Step 2 of the reset flow: 6-digit code (Figma "Frame 6").
/// SIMULATED: the only accepted code is [MockData.otpCode].
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});

  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _resendSeconds = 180;

  final _controllers = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());
  late final TextEditingController _emailCtl = TextEditingController(text: widget.email);
  Timer? _timer;
  int _seconds = _resendSeconds;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = _resendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _seconds <= 0) {
        t.cancel();
        return;
      }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    _emailCtl.dispose();
    super.dispose();
  }

  String get _mmss {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _clearBoxes() {
    for (final c in _controllers) {
      c.clear();
    }
    _nodes.first.requestFocus();
  }

  void _resend() {
    setState(() => _error = null);
    _clearBoxes();
    _startTimer();
    showFeedback(context, 'محاكاة: تمت إعادة الإرسال. الرمز التجريبي هو ${MockData.otpCode}');
  }

  Future<void> _verify() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 6) {
      setState(() => _error = 'برجاء إدخال الرمز المكون من 6 أرقام');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    if (code != MockData.otpCode) {
      setState(() {
        _loading = false;
        _error = 'رمز التحقق غير صحيح';
      });
      _clearBoxes();
      return;
    }
    Navigator.of(context).pushReplacementNamed(Routes.reset, arguments: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardLayout(
      title: 'ادخل رمز التحقق المرسل',
      child: Column(
        children: [
          const Text('أدخل رمز التحقق المرسل لك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const Text('لقد أرسلنا رمز التحقق الي بريدك الالكتروني', style: TextStyle(fontSize: 15, color: AppColors.muted)),
          const SizedBox(height: 20),
          AppTextField(
            controller: _emailCtl,
            readOnly: true,
            style: AppFieldStyle.pill,
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 20),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                for (var i = 0; i < 6; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 56),
                          child: TextField(
                            controller: _controllers[i],
                            focusNode: _nodes[i],
                            autofocus: i == 0,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: const Color(0xFFBDBDBD),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.crimson, width: 2),
                              ),
                            ),
                            onChanged: (v) {
                              if (_error != null) setState(() => _error = null);
                              if (v.isNotEmpty && i < 5) _nodes[i + 1].requestFocus();
                              if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_error != null) ErrorText(_error!),
          const SizedBox(height: 16),
          if (_seconds > 0)
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              children: [
                const Text('يمكنك اعاده ارسال الرمز خلال', style: TextStyle(fontSize: 16, color: AppColors.muted)),
                Text(_mmss, style: const TextStyle(fontSize: 18, color: Color(0xFF8E3B3B), fontWeight: FontWeight.w700)),
                const Icon(Icons.refresh, color: Color(0xFF8E3B3B)),
              ],
            )
          else
            TextButton.icon(
              onPressed: _resend,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة إرسال الرمز', style: TextStyle(fontWeight: FontWeight.w700)),
              style: TextButton.styleFrom(foregroundColor: AppColors.crimson),
            ),
          const SizedBox(height: 16),
          PrimaryButton(label: 'إرسال', loading: _loading, radius: 30, height: 56, onPressed: _verify),
          const SizedBox(height: 16),
          const DemoNotice('محاكاة فقط: لم يتم إرسال أي رسالة حقيقية. رمز التحقق التجريبي هو ${MockData.otpCode}'),
        ],
      ),
    );
  }
}
