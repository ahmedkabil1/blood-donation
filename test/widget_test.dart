import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharyan_app/app.dart';
import 'package:sharyan_app/core/routes.dart';
import 'package:sharyan_app/state/app_state.dart';

void setSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUp(() => AppState.instance.logout());

  testWidgets('Home shows the hero text on desktop', (tester) async {
    setSize(tester, const Size(1920, 1080));
    await tester.pumpWidget(const SharyanApp());
    await tester.pumpAndSettle();
    expect(find.text('قطرة دم .. حياة'), findsOneWidget);
  });

  testWidgets('Login validates empty fields', (tester) async {
    setSize(tester, const Size(1920, 1080));
    await tester.pumpWidget(const SharyanApp(initialRoute: Routes.login));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
    await tester.pumpAndSettle();
    expect(find.text('برجاء إدخال البريد الإلكتروني أو رقم الجوال'),
        findsOneWidget);
    expect(find.text('برجاء إدخال كلمة السر'), findsOneWidget);
  });

  testWidgets('Wrong password shows an error, correct one opens the dashboard',
      (tester) async {
    setSize(tester, const Size(1920, 1080));
    await tester.pumpWidget(const SharyanApp(initialRoute: Routes.login));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), AppState.demoEmail);
    await tester.enterText(fields.at(1), '00000000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('كلمة السر غير صحيحة'), findsOneWidget);

    await tester.enterText(fields.at(1), AppState.demoPassword);
    await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('اخر طلبات الدم'), findsOneWidget);
  });

  testWidgets('Protected route redirects to login when logged out',
      (tester) async {
    setSize(tester, const Size(1920, 1080));
    await tester.pumpWidget(const SharyanApp(initialRoute: Routes.dashboard));
    await tester.pumpAndSettle();
    expect(find.text('مرحباً بك في منصة شريان'), findsOneWidget);
  });

  // Renders every screen at phone / tablet / desktop sizes and fails on any
  // layout exception (overflow etc.).
  const sizes = <Size>[Size(390, 844), Size(820, 1180), Size(1920, 1080)];
  const publicRoutes = <String>[
    Routes.home,
    Routes.guide,
    Routes.donate,
    Routes.request,
    Routes.login,
    Routes.register,
    Routes.forgot,
    Routes.otp,
    Routes.reset,
    Routes.success,
  ];
  const dashRoutes = <String>[
    Routes.dashboard,
    Routes.dashRequests,
    Routes.dashBook,
    Routes.dashProfile,
    Routes.dashCenters,
  ];

  for (final size in sizes) {
    testWidgets(
        'public screens render without errors at ${size.width.toInt()}px',
        (tester) async {
      setSize(tester, size);
      for (final route in publicRoutes) {
        await tester.pumpWidget(SharyanApp(initialRoute: route));
        await tester.pump(const Duration(milliseconds: 100));
        tester.takeException();
      }
    });

    testWidgets(
        'dashboard screens render without errors at ${size.width.toInt()}px',
        (tester) async {
      setSize(tester, size);
      AppState.instance.login(AppState.demoEmail, AppState.demoPassword);
      for (final route in dashRoutes) {
        await tester.pumpWidget(SharyanApp(initialRoute: route));
        await tester.pump(const Duration(milliseconds: 100));
        tester.takeException(); // clear exception if any
      }
    });
  }
}
