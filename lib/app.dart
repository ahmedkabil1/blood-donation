import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/routes.dart';
import 'core/theme.dart';
import 'screens/blood_request_form_screen.dart';
import 'screens/blood_requests_screen.dart';
import 'screens/book_appointment_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/donation_centers_screen.dart';
import 'screens/donation_form_screen.dart';
import 'screens/donor_guide_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/success_screen.dart';
import 'state/app_state.dart';

class SharyanApp extends StatelessWidget {
  const SharyanApp({super.key, this.initialRoute = Routes.home});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'شريان',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Arabic locale => RTL layout + Arabic date pickers.
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: initialRoute,
      onGenerateInitialRoutes: (name) => <Route<dynamic>>[_route(RouteSettings(name: name))],
      onGenerateRoute: _route,
    );
  }
}

Route<dynamic> _page(RouteSettings settings, Widget child, {bool instant = false}) {
  if (instant) {
    return PageRouteBuilder<void>(
      settings: settings,
      pageBuilder: (_, __, ___) => child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
  return MaterialPageRoute<void>(settings: settings, builder: (_) => child);
}

Route<dynamic> _route(RouteSettings s) {
  final name = s.name ?? Routes.home;

  // Simple route guard: dashboard pages need the (simulated) session.
  if (Routes.protectedRoutes.contains(name) && !AppState.instance.isLoggedIn) {
    return _page(
      const RouteSettings(name: Routes.login),
      const LoginScreen(notice: 'سجّل الدخول أولاً للوصول إلى هذه الصفحة'),
    );
  }

  switch (name) {
    case Routes.home:
      return _page(s, const HomeScreen());
    case Routes.guide:
      return _page(s, const DonorGuideScreen());
    case Routes.donate:
      return _page(s, const DonationFormScreen());
    case Routes.request:
      return _page(s, const BloodRequestFormScreen());
    case Routes.login:
      return _page(s, const LoginScreen());
    case Routes.register:
      return _page(s, const RegisterScreen());
    case Routes.forgot:
      return _page(s, const ForgotPasswordScreen());
    case Routes.otp:
      return _page(s, OtpScreen(email: (s.arguments as String?) ?? AppState.demoEmail));
    case Routes.reset:
      return _page(s, ResetPasswordScreen(email: (s.arguments as String?) ?? AppState.demoEmail));
    case Routes.success:
      return _page(s, SuccessScreen(kind: (s.arguments as SuccessKind?) ?? SuccessKind.request));
    case Routes.dashboard:
      return _page(s, const DashboardScreen(), instant: true);
    case Routes.dashRequests:
      return _page(s, const BloodRequestsScreen(), instant: true);
    case Routes.dashBook:
      return _page(s, const BookAppointmentScreen(), instant: true);
    case Routes.dashProfile:
      return _page(s, const ProfileScreen(), instant: true);
    case Routes.dashCenters:
      return _page(s, const DonationCentersScreen(), instant: true);
    default:
      return _page(const RouteSettings(name: Routes.home), const HomeScreen());
  }
}
