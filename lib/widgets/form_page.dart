import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme.dart';
import 'buttons.dart';

/// Shared layout of the two public forms: red banner, 3 cards, submit button.
/// Cards sit side by side on wide screens and stack on tablets / phones.
class FormPageLayout extends StatelessWidget {
  const FormPageLayout({
    super.key,
    required this.formKey,
    required this.title,
    required this.subtitle,
    required this.cards,
    required this.submitLabel,
    required this.onSubmit,
    this.loading = false,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final String subtitle;
  final List<Widget> cards;
  final String submitLabel;
  final VoidCallback onSubmit;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 1000;
    final phone = width < Responsive.tabletMin;

    return ContentWidth(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: phone ? 28 : 44, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppColors.deep, AppColors.heroEnd, AppColors.deep],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: phone ? 28 : 42, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: phone ? 14 : 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    Expanded(child: cards[i]),
                  ],
                ],
              )
            else
              Column(
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    cards[i],
                  ],
                ],
              ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: submitLabel,
              onPressed: onSubmit,
              loading: loading,
              expand: phone,
              minWidth: 280,
              height: 56,
              radius: 30,
              fontSize: 20,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
