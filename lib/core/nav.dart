import 'package:flutter/material.dart';

import '../state/app_state.dart';
import 'routes.dart';

/// Small navigation helpers so screens stay readable.
class Nav {
  Nav._();

  /// Replace the whole stack with [route].
  static void toRoot(BuildContext context, String route, {Object? arguments}) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (r) => false, arguments: arguments);
  }

  static void logout(BuildContext context) {
    AppState.instance.logout();
    toRoot(context, Routes.login);
  }

  /// Used by every success screen ("حسناً"): Dashboard if logged in, else Home.
  static void afterSuccess(BuildContext context) {
    toRoot(context, AppState.instance.isLoggedIn ? Routes.dashboard : Routes.home);
  }

  static void toDashboardSection(BuildContext context, String route) {
    if (ModalRoute.of(context)?.settings.name == route) return;
    Navigator.of(context).pushReplacementNamed(route);
  }

  static void toPublic(BuildContext context, String route) {
    if (ModalRoute.of(context)?.settings.name == route) return;
    toRoot(context, route);
  }
}
