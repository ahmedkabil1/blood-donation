import 'package:flutter/material.dart';

enum ScreenSize { phone, tablet, desktop }

/// Breakpoints: phone < 600 <= tablet < 1024 <= desktop.
class Responsive {
  Responsive._();

  static const double tabletMin = 600;
  static const double desktopMin = 1024;

  static ScreenSize of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= desktopMin) return ScreenSize.desktop;
    if (w >= tabletMin) return ScreenSize.tablet;
    return ScreenSize.phone;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    switch (of(context)) {
      case ScreenSize.phone:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case ScreenSize.tablet:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
      case ScreenSize.desktop:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
  }
}

/// Centers content and caps its width (keeps 1920x1080 layouts tidy).
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 1400});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: Responsive.pagePadding(context), child: child),
      ),
    );
  }
}
