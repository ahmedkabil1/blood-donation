import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import '../widgets/dashboard_shell.dart';
import '../widgets/request_tile.dart';

/// Dashboard "طلبات الدم": filterable list of open requests (Figma "Frame 8").
class BloodRequestsScreen extends StatefulWidget {
  const BloodRequestsScreen({super.key});

  @override
  State<BloodRequestsScreen> createState() => _BloodRequestsScreenState();
}

class _BloodRequestsScreenState extends State<BloodRequestsScreen> {
  static const _all = 'all';

  final _search = TextEditingController();
  String _region = _all;
  String _group = _all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Widget _box(Widget child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: child,
      );

  Widget _dropdown({
    required String value,
    required String allLabel,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return _box(
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          borderRadius: BorderRadius.circular(12),
          items: [
            DropdownMenuItem(value: _all, child: Text(allLabel)),
            for (final o in options) DropdownMenuItem(value: o, child: Text(o)),
          ],
          onChanged: (v) => onChanged(v ?? _all),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim();
    final filtered = MockData.requests.where((r) {
      return (_region == _all || r.region == _region) &&
          (_group == _all || r.bloodGroup == _group) &&
          (q.isEmpty || r.hospital.contains(q));
    }).toList();

    final searchField = _box(
      TextField(
        controller: _search,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          hintText: 'ابحث عن المستشفى',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
    final regionBox = _dropdown(
      value: _region,
      allLabel: 'جميع المناطق',
      options: MockData.regions,
      onChanged: (v) => setState(() => _region = v),
    );
    final groupBox = _dropdown(
      value: _group,
      allLabel: 'فصائل الدم المطلوبة',
      options: MockData.bloodGroups,
      onChanged: (v) => setState(() => _group = v),
    );

    return DashboardShell(
      currentRoute: Routes.dashRequests,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Text('طلبات الدم', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800))),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(Routes.request),
                icon: const Icon(Icons.add),
                label: const Text('طلب دم جديد'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth >= 700) {
                return Row(
                  children: [
                    Expanded(flex: 2, child: searchField),
                    const SizedBox(width: 12),
                    Expanded(child: regionBox),
                    const SizedBox(width: 12),
                    Expanded(child: groupBox),
                  ],
                );
              }
              return Column(children: [searchField, const SizedBox(height: 10), regionBox, const SizedBox(height: 10), groupBox]);
            },
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: Text('لا توجد طلبات مطابقة', style: TextStyle(color: AppColors.muted, fontSize: 16))),
                  )
                : Column(
                    children: [
                      for (final r in filtered) ...[
                        RequestTile(request: r, detailsLabel: 'التفاصيل'),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
