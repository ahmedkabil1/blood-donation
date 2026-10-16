import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Text + drop logo (replace with the exported Figma asset if desired).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.light = false, this.scale = 1.0, this.showSubtitle = true});

  final bool light;
  final double scale;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    final main = light ? Colors.white : AppColors.crimson;
    final sub = light ? const Color(0xCCFFFFFF) : AppColors.muted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.water_drop, color: main, size: 40 * scale),
        SizedBox(width: 6 * scale),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'شريان',
              style: TextStyle(color: main, fontSize: 30 * scale, fontWeight: FontWeight.w800, height: 1.1),
            ),
            if (showSubtitle)
              Text(
                'المنصة الوطنية للتبرع بالدم',
                style: TextStyle(color: sub, fontSize: 10.5 * scale, fontWeight: FontWeight.w600),
              ),
          ],
        ),
      ],
    );
  }
}
