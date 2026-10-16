import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import '../widgets/public_scaffold.dart';

/// Donor guide: compatibility table, eligibility conditions and the verse.
class DonorGuideScreen extends StatelessWidget {
  const DonorGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final phone = Responsive.of(context) == ScreenSize.phone;

    final banner = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: phone ? 28 : 40, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.heroEnd, AppColors.deep],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'دليل المتبرع',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: phone ? 34 : 52, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'كل ما تحتاج معرفته عن إنقاذ الأرواح',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: phone ? 15 : 22),
              ),
            ],
          ),
          if (!phone)
            const Positioned(
              left: 48,
              child: Icon(Icons.volunteer_activism, size: 96, color: Color(0xCCFFFFFF)),
            ),
        ],
      ),
    );

    final verse = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF5E0009), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(
            '﴿ وَمَنْ أَحْيَاهَا فَكَأَنَّمَا أَحْيَا النَّاسَ جَمِيعًا ﴾',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: phone ? 22 : 32, fontWeight: FontWeight.w700, height: 1.6),
          ),
          const SizedBox(height: 4),
          const Text(
            'سورة المائدة، الآية 32',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 16),
          ),
        ],
      ),
    );

    return PublicScaffold(
      currentRoute: Routes.guide,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          banner,
          ContentWidth(
            child: Column(
              children: [
                verse,
                const SizedBox(height: 20),
                if (wide)
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _ConditionsCard()),
                      SizedBox(width: 20),
                      Expanded(flex: 6, child: _CompatCard()),
                    ],
                  )
                else
                  const Column(children: [_ConditionsCard(), SizedBox(height: 20), _CompatCard()]),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 14, offset: Offset(0, 4))],
    );

class _ConditionsCard extends StatelessWidget {
  const _ConditionsCard();

  static const _items = <(IconData, String, String)>[
    (Icons.person_outline, 'العمر', 'يجب أن يكون المتبرع بين 18 و65 عاماً'),
    (Icons.monitor_weight_outlined, 'الوزن', 'ألا يقل الوزن عن 50 كجم كحد أدنى'),
    (Icons.schedule, 'المدة الزمنية', '3 أشهر للرجال و 4 أشهر للنساء بين كل تبرعين'),
    (Icons.favorite_border, 'الحالة الصحية', 'عدم وجود أمراض مزمنة أو معدية'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.crimson, size: 32),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'شروط التبرع بالدم',
                  style: TextStyle(color: Color(0xFF6B0610), fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _items.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.crimson, width: 1.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_items[i].$1, color: AppColors.crimson),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_items[i].$2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        Text(_items[i].$3, style: const TextStyle(fontSize: 15, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GroupBadge extends StatelessWidget {
  const _GroupBadge(this.group);

  final String group;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.pink, borderRadius: BorderRadius.circular(17)),
      child: Text(group, style: const TextStyle(color: AppColors.crimson, fontWeight: FontWeight.w800, fontSize: 14)),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip(this.text, {this.pink = false, this.dark = false});

  final String text;
  final bool pink;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final Color bg = dark ? AppColors.maroon : (pink ? AppColors.pink : const Color(0xFFE6E6E9));
    final Color fg = dark ? Colors.white : (pink ? AppColors.crimson : AppColors.text);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}

class _CompatCard extends StatelessWidget {
  const _CompatCard();

  Widget _chips(CompatRow r, {required bool gives}) {
    if (gives && r.group == 'O-') return const Align(alignment: AlignmentDirectional.centerStart, child: _MiniChip('يعطي للجميع', dark: true));
    if (!gives && r.group == 'AB+') return const Align(alignment: AlignmentDirectional.centerStart, child: _MiniChip('يستقبل من الكل', dark: true));
    final list = gives ? r.gives : r.receives;
    return Wrap(spacing: 6, runSpacing: 6, children: [for (final g in list) _MiniChip(g, pink: gives)]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('توافق فصائل الدم', style: TextStyle(color: Color(0xFF6B0610), fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 520) {
                // Phone layout: one small block per blood group.
                return Column(
                  children: [
                    for (final r in MockData.compatibility)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFF7F7F9), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _GroupBadge(r.group),
                            const SizedBox(height: 8),
                            const Text('يعطي لـ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            const SizedBox(height: 4),
                            _chips(r, gives: true),
                            const SizedBox(height: 8),
                            const Text('يستقبل من', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            const SizedBox(height: 4),
                            _chips(r, gives: false),
                          ],
                        ),
                      ),
                  ],
                );
              }
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(color: const Color(0xFFF1F1F4), borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                      children: [
                        SizedBox(width: 64, child: Text('الفصيلة', style: TextStyle(fontWeight: FontWeight.w700))),
                        Expanded(flex: 3, child: Text('يعطي لـ', style: TextStyle(fontWeight: FontWeight.w700))),
                        Expanded(flex: 3, child: Text('يستقبل من', style: TextStyle(fontWeight: FontWeight.w700))),
                      ],
                    ),
                  ),
                  for (final r in MockData.compatibility)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE6E6E9)))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 64, child: Align(alignment: AlignmentDirectional.centerStart, child: _GroupBadge(r.group))),
                          Expanded(flex: 3, child: _chips(r, gives: true)),
                          const SizedBox(width: 8),
                          Expanded(flex: 3, child: _chips(r, gives: false)),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
