/// Local (frontend-only) validators. All messages are shown in Arabic.
class Validators {
  Validators._();

  static final _email = RegExp(r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$');
  static final _phone = RegExp(r'^(\+20|0020|0)?1[0125]\d{8}$');

  static String? required(String? v, [String label = 'هذا الحقل']) {
    if (v == null || v.trim().isEmpty) return 'برجاء إدخال $label';
    return null;
  }

  static String? fullName(String? v) {
    if (v == null || v.trim().isEmpty) return 'برجاء إدخال الاسم بالكامل';
    if (v.trim().length < 3) return 'الاسم قصير جداً';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'برجاء إدخال البريد الإلكتروني';
    if (!_email.hasMatch(v.trim())) return 'صيغة البريد الإلكتروني غير صحيحة';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'برجاء إدخال رقم الهاتف';
    final p = v.replaceAll(RegExp(r'[\s\-]'), '');
    if (!_phone.hasMatch(p)) return 'رقم الهاتف غير صحيح (مثال: 01012345678)';
    return null;
  }

  static String? emailOrPhone(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'برجاء إدخال البريد الإلكتروني أو رقم الجوال';
    }
    if (v.contains('@')) {
      return _email.hasMatch(v.trim()) ? null : 'صيغة البريد الإلكتروني غير صحيحة';
    }
    final p = v.replaceAll(RegExp(r'[\s\-]'), '');
    return _phone.hasMatch(p) ? null : 'رقم الجوال غير صحيح';
  }

  static String? loginPassword(String? v) {
    if (v == null || v.isEmpty) return 'برجاء إدخال كلمة السر';
    return null;
  }

  static String? newPassword(String? v) {
    if (v == null || v.isEmpty) return 'برجاء إدخال كلمة السر';
    if (v.length < 8) return 'يجب أن تحتوي كلمة السر على 8 أحرف على الأقل';
    return null;
  }

  static String? confirmPassword(String? v, String original) {
    if (v == null || v.isEmpty) return 'برجاء تأكيد كلمة السر';
    if (v != original) return 'كلمتا السر غير متطابقتين';
    return null;
  }

  static String? number(String? v, {required String label, required num min, required num max}) {
    if (v == null || v.trim().isEmpty) return 'برجاء إدخال $label';
    final n = num.tryParse(v.trim());
    if (n == null) return 'برجاء إدخال رقم صحيح';
    if (n < min || n > max) return '$label يجب أن يكون بين $min و $max';
    return null;
  }
}
