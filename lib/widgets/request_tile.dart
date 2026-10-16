import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/mock_data.dart';

/// "متبقي N يوم" pill: red when 1 day is left, amber for 2, grey otherwise.
class DaysChip extends StatelessWidget {
  const DaysChip({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    if (days <= 1) {
      bg = AppColors.pink;
      fg = const Color(0xFFE53935);
    } else if (days == 2) {
      bg = AppColors.amberChip;
      fg = const Color(0xFFB71C1C);
    } else {
      bg = AppColors.cardGrey;
      fg = AppColors.text;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text('متبقي $days يوم', style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 15)),
    );
  }
}

void showRequestDetails(BuildContext context, BloodRequest r) {
  Widget row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text('$k: ', style: const TextStyle(fontWeight: FontWeight.w700)),
            Expanded(child: Text(v)),
          ],
        ),
      );

  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('تفاصيل طلب الدم'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row('المستشفى', r.hospital),
          row('المنطقة', r.region),
          row('الفصيلة المطلوبة', r.bloodGroup),
          row('عدد الوحدات', '${r.units}'),
          row('المتبقي', '${r.daysLeft} يوم'),
          const SizedBox(height: 8),
          const Text('بيانات تجريبية للعرض فقط.', style: TextStyle(color: AppColors.muted, fontSize: 12.5)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إغلاق')),
      ],
    ),
  );
}

class RequestTile extends StatelessWidget {
  const RequestTile({super.key, required this.request, required this.detailsLabel});

  final BloodRequest request;
  final String detailsLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 560;
        final badge = Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: AppColors.pinkStrong, shape: BoxShape.circle),
          child: Text(
            request.bloodGroup,
            style: const TextStyle(color: AppColors.crimson, fontWeight: FontWeight.w800, fontSize: 20),
          ),
        );
        final info = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(request.hospital, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 2),
            Text('عدد الوحدات المطلوبة ${request.units}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
          ],
        );
        final button = ElevatedButton(
          onPressed: () => showRequestDetails(context, request),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.maroon,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
          ),
          child: Text(detailsLabel),
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFBDBDBD)),
          ),
          child: narrow
              ? Column(
                  children: [
                    Row(children: [badge, const SizedBox(width: 12), Expanded(child: info)]),
                    const SizedBox(height: 10),
                    Row(children: [DaysChip(days: request.daysLeft), const Spacer(), button]),
                  ],
                )
              : Row(
                  children: [
                    badge,
                    const SizedBox(width: 16),
                    Expanded(child: info),
                    DaysChip(days: request.daysLeft),
                    const SizedBox(width: 16),
                    button,
                  ],
                ),
        );
      },
    );
  }
}
