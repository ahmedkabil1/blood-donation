import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'app_logo.dart';
import 'blood_drop.dart';

/// Login / Register layout: form on the right, red brand panel on the left
/// (as in Figma). On narrow screens only the form is shown, with a back link.
class AuthSplitLayout extends StatelessWidget {
  const AuthSplitLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 860;

            final formSide = LayoutBuilder(
              builder: (context, cc) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: math.max(0, cc.maxHeight - 48)),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!wide) ...[
                            Row(
                              children: [
                                const AppLogo(scale: 0.8),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: onBack,
                                  icon: const Icon(Icons.arrow_back, size: 18),
                                  label: const Text('الرجوع'),
                                  style: TextButton.styleFrom(foregroundColor: AppColors.crimson),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          Text(title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(subtitle, style: const TextStyle(fontSize: 19, color: AppColors.muted)),
                          const SizedBox(height: 20),
                          form,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );

            if (!wide) return formSide;

            final panel = Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6B0610), Color(0xFF8E0A14)],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(light: true, scale: 1.5),
                      const SizedBox(height: 44),
                      const Text(
                        'معاً .. لإنقاذ حياة',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 28),
                      const BloodDropGraphic(size: 150),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: 240,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: onBack,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(color: AppColors.crimson, width: 2),
                            ),
                            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: AppTheme.fontFamily),
                          ),
                          child: const Text('الرجوع'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            // RTL: first child sits on the right, so the form is first.
            return Row(children: [Expanded(child: formSide), Expanded(child: panel)]);
          },
        ),
      ),
    );
  }
}

/// Forgot-password / OTP / reset layout: grey card with a maroon title bar.
class AuthCardLayout extends StatelessWidget {
  const AuthCardLayout({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 6))],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            color: AppColors.maroon,
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: AppColors.authCard,
                            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                            child: child,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
