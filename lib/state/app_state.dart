import 'package:flutter/foundation.dart';

/// In-memory model of a (fake) user account. Passwords are kept in plain text
/// in memory ONLY because this is a UI demo with no real authentication.
class UserProfile {
  UserProfile({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    this.bloodGroup,
    this.gender,
    this.birthDate,
    this.donations = 0,
    this.bookings = 0,
    this.requests = 0,
  });

  String fullName;
  String phone;
  String email;
  String password;
  String? bloodGroup;
  String? gender;
  DateTime? birthDate;
  int donations;
  int bookings;
  int requests;

  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;
  String get shortName => fullName.trim().split(RegExp(r'\s+')).take(2).join(' ');
}

enum LoginResult { success, notRegistered, wrongPassword }

enum RegisterResult { success, emailTaken, phoneTaken }

/// Session + mock "database" held in memory. Reset on app restart.
class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  static const demoEmail = 'example@gmail.com';
  static const demoPassword = '12345678';

  final List<UserProfile> _users = [
    UserProfile(
      fullName: 'أحمد محمد إبراهيم',
      phone: '+201012345678',
      email: demoEmail,
      password: demoPassword,
      bloodGroup: 'A+',
      gender: 'ذكر',
      birthDate: DateTime(2006, 5, 15),
      donations: 5,
      bookings: 2,
      requests: 5,
    ),
  ];

  UserProfile? _current;

  UserProfile? get currentUser => _current;
  bool get isLoggedIn => _current != null;

  static String normalizePhone(String raw) {
    var p = raw.replaceAll(RegExp(r'[\s\-]'), '');
    if (p.startsWith('+20')) {
      p = '0${p.substring(3)}';
    } else if (p.startsWith('0020')) {
      p = '0${p.substring(4)}';
    }
    return p;
  }

  UserProfile? _findByEmail(String email) {
    for (final u in _users) {
      if (u.email.toLowerCase() == email.trim().toLowerCase()) return u;
    }
    return null;
  }

  UserProfile? _findByPhone(String phone) {
    final n = normalizePhone(phone);
    for (final u in _users) {
      if (normalizePhone(u.phone) == n) return u;
    }
    return null;
  }

  LoginResult login(String identifier, String password) {
    final id = identifier.trim();
    final user = id.contains('@') ? _findByEmail(id) : _findByPhone(id);
    if (user == null) return LoginResult.notRegistered;
    if (user.password != password) return LoginResult.wrongPassword;
    _current = user;
    notifyListeners();
    return LoginResult.success;
  }

  RegisterResult register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) {
    if (_findByEmail(email) != null) return RegisterResult.emailTaken;
    if (_findByPhone(phone) != null) return RegisterResult.phoneTaken;
    _users.add(UserProfile(
      fullName: fullName.trim(),
      phone: phone.trim(),
      email: email.trim(),
      password: password,
    ));
    return RegisterResult.success;
  }

  /// Simulated password reset (no email is sent; unknown emails are ignored).
  void resetPassword(String email, String newPassword) {
    final u = _findByEmail(email);
    if (u != null) u.password = newPassword;
  }

  void updateProfile({
    required String fullName,
    required String phone,
    required String email,
    String? bloodGroup,
    String? gender,
    DateTime? birthDate,
  }) {
    final u = _current;
    if (u == null) return;
    u.fullName = fullName.trim();
    u.phone = phone.trim();
    u.email = email.trim();
    u.bloodGroup = bloodGroup;
    u.gender = gender;
    u.birthDate = birthDate;
    notifyListeners();
  }

  void recordDonation() {
    _current?.donations++;
    notifyListeners();
  }

  void recordBooking() {
    _current?.bookings++;
    notifyListeners();
  }

  void recordRequest() {
    _current?.requests++;
    notifyListeners();
  }

  void logout() {
    _current = null;
    notifyListeners();
  }
}
