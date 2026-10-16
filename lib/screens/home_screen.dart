import 'package:flutter/material.dart';

import '../core/nav.dart';
import '../core/responsive.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../widgets/blood_drop.dart';
import '../widgets/public_scaffold.dart';

/// First screen of the app (Figma "Frame 1").
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _overlap = 60;

  @override
  Widget build(BuildContext context) {
    return PublicScaffold(
      currentRoute: Routes.home,
      body: Column(
        children: [
          const _Hero(overlap: _overlap),
          Transform.translate(
            offset: const Offset(0, -_overlap),
            child: const Column(children: [_ActionCards(), _Footer()]),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.size);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x14FFFFFF)),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.overlap});

  final double overlap;

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final desktop = size == ScreenSize.desktop;
    final phone = size == ScreenSize.phone;
    final pad = desktop ? 64.0 : 24.0;

    final text = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: desktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          'قطرة دم .. حياة',
          textAlign: desktop ? TextAlign.start : TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: desktop ? 68 : (phone ? 36 : 52), fontWeight: FontWeight.w800, height: 1.25),
        ),
        const SizedBox(height: 12),
        Text(
          'كن جزءاً من الأمل؛ تبرع بالدم',
          textAlign: desktop ? TextAlign.start : TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: desktop ? 30 : (phone ? 18 : 24), fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 14,
          runSpacing: 12,
          alignment: desktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Nav.toPublic(context, Routes.donate),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.crimson,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
              ),
              child: const Text('ابدأ الان'),
            ),
            OutlinedButton(
              onPressed: () => Nav.toPublic(context, Routes.guide),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 1.6),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
              ),
              child: const Text('معرفة المزيد'),
            ),
          ],
        ),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.heroEnd, AppColors.deep],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(left: -80, top: -60, child: _Bubble(300)),
          const Positioned(right: -100, bottom: -120, child: _Bubble(380)),
          Padding(
            padding: EdgeInsets.fromLTRB(pad, desktop ? 56 : 32, pad, overlap + 30),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1300),
                child: desktop
                    ? Row(
                        children: [
                          Expanded(child: text),
                          const SizedBox(width: 32),
                          const BloodDropGraphic(size: 380),
                        ],
                      )
                    : Column(
                        children: [
                          BloodDropGraphic(size: phone ? 150 : 240),
                          const SizedBox(height: 20),
                          text,
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCards extends StatelessWidget {
  const _ActionCards();

  void _comingSoon(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ساعد في المجتمع'),
        content: const Text('هذا القسم غير متاح في النسخة التجريبية (لا يوجد تصميم له بعد).'),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('حسناً'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop = Responsive.of(context) == ScreenSize.desktop;
    final cards = <_ActionData>[
      _ActionData(Icons.bloodtype, 'تبرع بالدم', 'كن منقذاً للحياة', () => Nav.toPublic(context, Routes.donate)),
      _ActionData(Icons.calendar_month, 'احجز موعدك', 'بسهوله وامان', () => Navigator.of(context).pushNamed(Routes.dashBook)),
      _ActionData(Icons.search, 'ابحث عن طلب دم', 'ساعد من يحتاج', () => Navigator.of(context).pushNamed(Routes.dashRequests)),
      _ActionData(Icons.monitor_heart_outlined, 'ساعد في المجتمع', 'معاً نصنع الفرق', () => _comingSoon(context)),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: desktop ? 64 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 24, offset: Offset(0, 8))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: desktop
                  ? Row(
                      children: [
                        for (var i = 0; i < cards.length; i++) ...[
                          if (i > 0) Container(width: 1, height: 100, color: AppColors.border),
                          Expanded(child: _ActionCard(cards[i])),
                        ],
                      ],
                    )
                  : LayoutBuilder(
                      builder: (context, c) => Wrap(
                        children: [
                          for (final d in cards) SizedBox(width: c.maxWidth / 2, child: _ActionCard(d)),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionData {
  const _ActionData(this.icon, this.title, this.subtitle, this.onTap);

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _ActionCard extends StatelessWidget {
  const _ActionCard(this.data);

  final _ActionData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(data.icon, size: 44, color: AppColors.crimson),
            const SizedBox(height: 10),
            Text(data.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(data.subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 40, 16, 32),
      child: Text(
        'شريان — المنصة الوطنية للتبرع بالدم\nنسخة تجريبية للواجهة فقط (بدون خادم أو مصادقة حقيقية)',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.muted, fontSize: 13.5, height: 1.7),
      ),
    );
  }
}
