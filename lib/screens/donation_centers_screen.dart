import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import '../widgets/dashboard_shell.dart';
import '../widgets/feedback.dart';

/// "مراكز التبرع": searchable grid of centers (Figma image 15).
class DonationCentersScreen extends StatefulWidget {
  const DonationCentersScreen({super.key});

  @override
  State<DonationCentersScreen> createState() => _DonationCentersScreenState();
}

class _DonationCentersScreenState extends State<DonationCentersScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _details(DonationCenter c) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(c.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('العنوان: ${c.address}'),
            const SizedBox(height: 6),
            Text('مواعيد العمل: ${c.hours}'),
            const SizedBox(height: 6),
            Text('الهاتف: ${c.phone}', textDirection: TextDirection.rtl),
            const SizedBox(height: 6),
            Text('الحالة: ${c.available ? 'متاح الآن' : 'مغلق الآن'}'),
            const SizedBox(height: 10),
            const Text('بيانات تجريبية للعرض فقط.', style: TextStyle(color: AppColors.muted, fontSize: 12.5)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إغلاق'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim();
    final list = MockData.centers
        .where((c) => q.isEmpty || c.name.contains(q) || c.address.contains(q) || c.region.contains(q))
        .toList();

    return DashboardShell(
      currentRoute: Routes.dashCenters,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('مراكز التبرع بالدم', style: TextStyle(color: AppColors.crimson, fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [AppColors.crimson, Color(0x00B30F1B)],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2))],
            ),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'ابحث عن المركز او المنطقه',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('لا توجد مراكز مطابقة', style: TextStyle(color: AppColors.muted, fontSize: 16))),
            )
          else
            LayoutBuilder(
              builder: (context, c) {
                final cols = c.maxWidth >= 1000 ? 3 : (c.maxWidth >= 620 ? 2 : 1);
                const gap = 16.0;
                final itemWidth = (c.maxWidth - gap * (cols - 1)) / cols;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final center in list)
                      SizedBox(
                        width: itemWidth,
                        child: _CenterCard(
                          center: center,
                          onDetails: () => _details(center),
                          onDirections: () => showFeedback(context, 'الاتجاهات غير متاحة في النسخة التجريبية (لا توجد خرائط).'),
                        ),
                      ),
                  ],
                );
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _CenterCard extends StatelessWidget {
  const _CenterCard({required this.center, required this.onDetails, required this.onDirections});

  final DonationCenter center;
  final VoidCallback onDetails;
  final VoidCallback onDirections;

  Widget _line(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 14.5))),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ok = center.available;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.cardGrey, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(center.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ok ? const Color(0xFFE3F5E8) : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 9, color: ok ? AppColors.success : AppColors.muted),
                    const SizedBox(width: 5),
                    Text(
                      ok ? 'متاح الآن' : 'مغلق الآن',
                      style: TextStyle(fontSize: 12.5, color: ok ? AppColors.success : AppColors.muted, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _line(Icons.location_on, center.address),
          _line(Icons.access_time, center.hours),
          _line(Icons.place_outlined, 'يبعد عنك ${center.distanceKm}كم'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('التفاصيل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB30F0F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDirections,
                  icon: const Icon(Icons.navigation_outlined, size: 18),
                  label: const Text('الاتجاهات'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB30F0F),
                    side: const BorderSide(color: Color(0xFFB30F0F)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
