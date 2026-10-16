import 'package:flutter/material.dart';

import '../core/nav.dart';
import '../core/theme.dart';
import '../widgets/buttons.dart';
import '../widgets/feedback.dart';

enum SuccessKind { donation, request, booking }

/// Confirmation screen shared by the donation form, the blood request form
/// and the appointment flow (Figma frames 13, 16, 17).
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.kind});

  final SuccessKind kind;

  String get _title => switch (kind) {
        SuccessKind.donation => 'تم ارسال استمارة التبرع بنجاح',
        SuccessKind.request => 'تم ارسال استمارة طلب الدم بنجاح',
        SuccessKind.booking => 'تم حجز موعدك بنجاح',
      };

  String get _subtitle => switch (kind) {
        SuccessKind.donation => 'شكراً لرغبتك في التبرع بالدم، كن جزءاً من الأمل.',
        SuccessKind.request => 'تم تسجيل طلبك بنجاح في النسخة التجريبية.',
        SuccessKind.booking => 'تم تأكيد موعد التبرع الخاص بك.',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user, size: 96, color: AppColors.success),
                  const SizedBox(height: 20),
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: AppColors.muted),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: 'حسناً',
                    expand: false,
                    minWidth: 180,
                    radius: 12,
                    onPressed: () => Nav.afterSuccess(context),
                  ),
                  const SizedBox(height: 24),
                  const DemoNotice('واجهة تجريبية: لم يتم حفظ أو إرسال أي بيانات إلى أي خادم.'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
