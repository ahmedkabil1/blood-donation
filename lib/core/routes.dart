/// All named routes of the app.
class Routes {
  Routes._();

  static const home = '/';
  static const guide = '/guide';
  static const donate = '/donate';
  static const request = '/blood-request';
  static const login = '/login';
  static const register = '/register';
  static const forgot = '/forgot-password';
  static const otp = '/otp';
  static const reset = '/reset-password';
  static const success = '/success';
  static const dashboard = '/dashboard';
  static const dashRequests = '/dashboard/requests';
  static const dashBook = '/dashboard/book';
  static const dashProfile = '/dashboard/profile';
  static const dashCenters = '/dashboard/centers';

  /// Routes that need a (simulated) logged-in session.
  static const protectedRoutes = <String>{
    dashboard,
    dashRequests,
    dashBook,
    dashProfile,
    dashCenters,
  };
}
