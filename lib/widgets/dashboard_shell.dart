import 'package:flutter/material.dart';

import '../core/nav.dart';
import '../core/responsive.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import 'app_logo.dart';

class _NavItem {
  const _NavItem(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}

/// Frame of every logged-in screen: top bar + sidebar (left, as in the Figma
/// design) on tablet/desktop, and a drawer on phones.
class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key, required this.currentRoute, required this.child});

  final String currentRoute;
  final Widget child;

  static const _items = <_NavItem>[
    _NavItem('لوحة التحكم', Icons.dashboard_outlined, Routes.dashboard),
    _NavItem('طلبات الدم', Icons.bloodtype_outlined, Routes.dashRequests),
    _NavItem('احجز معادك', Icons.event_available_outlined, Routes.dashBook),
    _NavItem('ملفي الشخصي', Icons.account_circle_outlined, Routes.dashProfile),
    _NavItem('مراكز التبرع', Icons.location_on_outlined, Routes.dashCenters),
  ];

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final phone = size == ScreenSize.phone;
    final sidebarWidth = size == ScreenSize.desktop ? 260.0 : 210.0;
    final pageContext = context;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final user = AppState.instance.currentUser;
        final greeting = 'أهلاً بك، ${user?.firstName ?? ''}';
        final groupLine = 'فصيلتك هي ${user?.bloodGroup ?? 'غير محددة'}';

        void select(String route, {bool inDrawer = false}) {
          if (inDrawer) Navigator.of(pageContext).pop();
          Nav.toDashboardSection(pageContext, route);
        }

        void logout({bool inDrawer = false}) {
          if (inDrawer) Navigator.of(pageContext).pop();
          Nav.logout(pageContext);
        }

        final topBar = Container(
          height: 76,
          padding: EdgeInsets.symmetric(horizontal: phone ? 12 : 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: Row(
            children: [
              AppLogo(scale: phone ? 0.8 : 1.0, showSubtitle: !phone),
              const Spacer(),
              if (!phone) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(greeting, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    Text(groupLine, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  ],
                ),
                const SizedBox(width: 12),
              ],
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF222222),
                child: Icon(Icons.person, color: Colors.white),
              ),
              if (phone)
                Builder(
                  builder: (ctx) => IconButton(
                    tooltip: 'القائمة',
                    icon: const Icon(Icons.menu, size: 28),
                    onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  ),
                ),
            ],
          ),
        );

        final content = Container(
          color: AppColors.background,
          child: SingleChildScrollView(child: ContentWidth(child: child)),
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          endDrawer: phone
              ? Drawer(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(greeting, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                              Text(groupLine, style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: _SidebarList(
                            currentRoute: currentRoute,
                            onSelect: (r) => select(r, inDrawer: true),
                            onLogout: () => logout(inDrawer: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
          body: SafeArea(
            child: Column(
              children: [
                topBar,
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: content),
                      if (!phone)
                        SizedBox(
                          width: sidebarWidth,
                          child: Container(
                            color: Colors.white,
                            child: _SidebarList(
                              currentRoute: currentRoute,
                              onSelect: select,
                              onLogout: logout,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SidebarList extends StatelessWidget {
  const _SidebarList({required this.currentRoute, required this.onSelect, required this.onLogout});

  final String currentRoute;
  final ValueChanged<String> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        for (final item in DashboardShell._items)
          _SidebarTile(
            icon: item.icon,
            label: item.label,
            active: item.route == currentRoute,
            onTap: () => onSelect(item.route),
          ),
        _SidebarTile(icon: Icons.logout, label: 'تسجيل الخروج', active: false, onTap: onLogout),
      ],
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({required this.icon, required this.label, required this.active, required this.onTap});

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : AppColors.text;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: active ? AppColors.maroon : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 22, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(color: color, fontSize: 16, fontWeight: active ? FontWeight.w800 : FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
