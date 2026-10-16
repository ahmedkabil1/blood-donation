import 'package:flutter/material.dart';

import '../core/nav.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import 'app_logo.dart';

/// Page frame for the public (pre-login) screens: top navigation bar that
/// collapses into a drawer below 1000 px, plus a scrolling body.
class PublicScaffold extends StatelessWidget {
  const PublicScaffold({
    super.key,
    required this.currentRoute,
    required this.body,
    this.backgroundColor = Colors.white,
  });

  final String currentRoute;
  final Widget body;
  final Color backgroundColor;

  static const _items = <(String, String)>[
    ('الرئيسية', Routes.home),
    ('التبرع بالدم', Routes.donate),
    ('طلب الدم', Routes.request),
    ('دليل المتبرع', Routes.guide),
  ];

  static void _showSearchDemo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('البحث'),
        content: const Text('ميزة البحث غير متاحة في النسخة التجريبية.'),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('حسناً'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 1000;
    final pageContext = context;
    final loggedIn = AppState.instance.isLoggedIn;
    final authLabel = loggedIn ? 'لوحة التحكم' : 'تسجيل الدخول';

    void goAuth() {
      if (loggedIn) {
        Nav.toRoot(pageContext, Routes.dashboard);
      } else {
        Navigator.of(pageContext).pushNamed(Routes.login);
      }
    }

    final authButton = ElevatedButton(
      onPressed: goAuth,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.maroon,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: wide ? 22 : 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: TextStyle(fontSize: wide ? 17 : 14, fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
      ),
      child: Text(authLabel),
    );

    final topBar = Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: wide ? 40 : 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          if (!wide)
            Builder(
              builder: (ctx) => IconButton(
                tooltip: 'القائمة',
                icon: const Icon(Icons.menu, size: 28),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
          AppLogo(scale: wide ? 1.0 : 0.8, showSubtitle: wide),
          if (wide) ...[
            const SizedBox(width: 40),
            for (final (label, route) in _items)
              _NavLink(
                label: label,
                active: route == currentRoute,
                big: width >= 1200,
                onTap: () => Nav.toPublic(pageContext, route),
              ),
          ],
          const Spacer(),
          if (wide) ...[
            IconButton(
              tooltip: 'بحث',
              icon: const Icon(Icons.search, size: 30),
              onPressed: () => _showSearchDemo(pageContext),
            ),
            const SizedBox(width: 12),
          ],
          authButton,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: wide
          ? null
          : Drawer(
              child: SafeArea(
                child: ListView(
                  children: [
                    const Padding(padding: EdgeInsets.all(20), child: Align(alignment: AlignmentDirectional.centerStart, child: AppLogo())),
                    const Divider(),
                    for (final (label, route) in _items)
                      ListTile(
                        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                        selected: route == currentRoute,
                        selectedColor: AppColors.crimson,
                        onTap: () {
                          Navigator.of(pageContext).pop();
                          Nav.toPublic(pageContext, route);
                        },
                      ),
                    ListTile(
                      leading: const Icon(Icons.search),
                      title: const Text('بحث', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                      onTap: () {
                        Navigator.of(pageContext).pop();
                        _showSearchDemo(pageContext);
                      },
                    ),
                  ],
                ),
              ),
            ),
      body: SafeArea(
        child: Column(
          children: [
            topBar,
            Expanded(child: SingleChildScrollView(child: body)),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.active, required this.onTap, required this.big});

  final String label;
  final bool active;
  final bool big;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: active ? AppColors.crimson : Colors.transparent, width: 2.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: big ? 20 : 17,
            fontWeight: FontWeight.w700,
            color: active ? AppColors.crimson : AppColors.text,
          ),
        ),
      ),
    );
  }
}
