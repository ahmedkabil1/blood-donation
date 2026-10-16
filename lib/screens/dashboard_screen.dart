import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../widgets/dashboard_shell.dart';
import '../widgets/request_tile.dart';

/// Dashboard summary (Figma "Frame 9").
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      currentRoute: Routes.dashboard,
      child: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final user = AppState.instance.currentUser;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً، ${user?.shortName ?? ''}',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Text('إليك ملخص نشاطك على المنصة', style: TextStyle(fontSize: 15, color: AppColors.muted)),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, c) {
                  final cards = <Widget>[
                    _StatCard(icon: Icons.water_drop, label: 'تبرعاتي', value: user?.donations ?? 0),
                    _StatCard(icon: Icons.calendar_month, label: 'حجوزاتي', value: user?.bookings ?? 0),
                    _StatCard(icon: Icons.bloodtype, label: 'طلبات الدم', value: user?.requests ?? 0),
                  ];
                  if (c.maxWidth >= 720) {
                    return Row(
                      children: [
                        for (var i = 0; i < cards.length; i++) ...[
                          if (i > 0) const SizedBox(width: 16),
                          Expanded(child: cards[i]),
                        ],
                      ],
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < cards.length; i++) ...[
                        if (i > 0) const SizedBox(height: 12),
                        cards[i],
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 14, offset: Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('اخر طلبات الدم', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 14),
                    for (final r in MockData.requests.take(3)) ...[
                      RequestTile(request: r, detailsLabel: 'عرض التفاصيل'),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: AppColors.pinkStrong, borderRadius: BorderRadius.circular(18)),
            child: Icon(icon, color: AppColors.crimson, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text('$value', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
