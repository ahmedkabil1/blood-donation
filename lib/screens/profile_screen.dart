import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/format.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../core/validators.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/buttons.dart';
import '../widgets/dashboard_shell.dart';
import '../widgets/feedback.dart';
import '../widgets/selectors.dart';

/// "ملفي الشخصي": read-only card with an in-place edit mode (frontend only).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  bool _editing = false;
  String? _group;
  String? _gender;
  DateTime? _birth;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  void _startEdit(UserProfile u) {
    _name.text = u.fullName;
    _phone.text = u.phone;
    _email.text = u.email;
    _group = u.bloodGroup;
    _gender = u.gender;
    _birth = u.birthDate;
    setState(() => _editing = true);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    AppState.instance.updateProfile(
      fullName: _name.text,
      phone: _phone.text,
      email: _email.text,
      bloodGroup: _group,
      gender: _gender,
      birthDate: _birth,
    );
    setState(() => _editing = false);
    showFeedback(context, 'تم حفظ التعديلات (محلياً فقط)');
  }

  Widget _pair(Widget a, Widget b) {
    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth >= 560) {
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: a), const SizedBox(width: 24), Expanded(child: b)]);
        }
        return Column(children: [a, const SizedBox(height: 16), b]);
      },
    );
  }

  Widget _info(String label, String value, {bool ltr = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: AppColors.muted)),
        const SizedBox(height: 2),
        Text(
          value,
          textDirection: ltr ? TextDirection.ltr : null,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return DashboardShell(
      currentRoute: Routes.dashProfile,
      child: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final u = AppState.instance.currentUser;
          if (u == null) return const SizedBox.shrink();

          final Widget body = _editing
              ? Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _pair(
                        AppTextField(label: 'الإسم بالكامل', controller: _name, validator: Validators.fullName),
                        AppTextField(
                          label: 'رقم الجوال',
                          controller: _phone,
                          validator: Validators.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]'))],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _pair(
                        AppTextField(label: 'البريد الإلكتروني', controller: _email, validator: Validators.email, keyboardType: TextInputType.emailAddress),
                        AppDropdownField<String>(
                          label: 'فصيله الدم',
                          items: MockData.bloodGroups,
                          labelOf: (s) => s,
                          initialValue: _group,
                          errorMessage: 'برجاء اختيار فصيلة الدم',
                          onChanged: (v) => _group = v,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _pair(
                        AppDateField(
                          label: 'تاريخ الميلاد',
                          firstDate: DateTime(1930),
                          lastDate: today,
                          pickerStart: DateTime(2000),
                          initialValue: _birth,
                          isRequired: false,
                          onChanged: (v) => _birth = v,
                        ),
                        AppDropdownField<String>(
                          label: 'الجنس',
                          items: const ['ذكر', 'أنثى'],
                          labelOf: (s) => s,
                          initialValue: _gender,
                          errorMessage: 'برجاء اختيار الجنس',
                          onChanged: (v) => _gender = v,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          PrimaryButton(label: 'حفظ', expand: false, minWidth: 180, height: 50, onPressed: _save),
                          SecondaryButton(label: 'إلغاء', minWidth: 140, height: 50, onPressed: () => setState(() => _editing = false)),
                        ],
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _pair(_info('الإسم بالكامل', u.fullName), _info('رقم الجوال', u.phone, ltr: true)),
                    const SizedBox(height: 20),
                    _pair(_info('البريد الإلكتروني', u.email, ltr: true), _info('فصيله الدم', u.bloodGroup ?? '—')),
                    const SizedBox(height: 20),
                    _pair(
                      _info('تاريخ الميلاد', u.birthDate == null ? '—' : formatDate(u.birthDate!)),
                      _info('الجنس', u.gender ?? '—'),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(label: 'تعديل البيانات', expand: false, minWidth: 200, height: 52, onPressed: () => _startEdit(u)),
                  ],
                );

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    const Text('معلوماتي الشخصيه', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3)),
                      child: const Icon(Icons.person, size: 60),
                    ),
                    const SizedBox(height: 28),
                    body,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
