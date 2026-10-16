import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/routes.dart';
import '../core/validators.dart';
import '../state/app_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/feedback.dart';
import '../widgets/form_page.dart';
import '../widgets/public_scaffold.dart';
import '../widgets/selectors.dart';
import 'success_screen.dart';

/// Blood DONATION form (for a donor) - Figma "Frame 15".
/// Different fields from the request form on purpose.
class DonationFormScreen extends StatefulWidget {
  const DonationFormScreen({super.key});

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _illnesses = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  bool? _sick;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _illnesses.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  String? _ageRule(DateTime d) {
    final now = DateTime.now();
    var age = now.year - d.year;
    if (now.month < d.month || (now.month == d.month && now.day < d.day)) age--;
    if (age < 18) return 'يجب ألا يقل عمر المتبرع عن 18 عاماً';
    if (age > 65) return 'يجب ألا يزيد عمر المتبرع عن 65 عاماً';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      showFeedback(context, 'برجاء مراجعة الحقول المطلوبة', isError: true);
      return;
    }
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    AppState.instance.recordDonation();
    Navigator.of(context).pushReplacementNamed(Routes.success, arguments: SuccessKind.donation);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return PublicScaffold(
      currentRoute: Routes.donate,
      backgroundColor: const Color(0xFFF2F2F4),
      body: FormPageLayout(
        formKey: _formKey,
        title: 'استمارة التبرع بالدم',
        subtitle: 'كن جزءاً من الأمل: املأ بياناتك لتصبح متبرعاً',
        submitLabel: 'إرسال الإستماره',
        loading: _loading,
        onSubmit: _submit,
        cards: [
          FormCard(
            title: 'البيانات الشخصيه',
            icon: Icons.person_outline,
            children: [
              AppTextField(label: 'الاسم', controller: _name, validator: Validators.fullName, textInputAction: TextInputAction.next),
              AppTextField(
                label: 'رقم الهاتف',
                controller: _phone,
                validator: Validators.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]'))],
              ),
              GenderField(),
              AppTextField(label: 'العنوان بالتفصيل', controller: _address, validator: (v) => Validators.required(v, 'العنوان')),
              AppDateField(
                label: 'تاريخ الميلاد',
                hint: 'اختر تاريخ الميلاد',
                firstDate: DateTime(1930),
                lastDate: today,
                pickerStart: DateTime(2000),
                errorMessage: 'برجاء اختيار تاريخ الميلاد',
                extraValidator: _ageRule,
              ),
            ],
          ),
          FormCard(
            title: 'الحاله الصحيه',
            icon: Icons.monitor_heart_outlined,
            children: [
              YesNoField(question: 'هل انت مصاب ب مرض؟', onChanged: (v) => setState(() => _sick = v)),
              if (_sick == true)
                AppTextField(
                  label: 'ما هي الامراض',
                  controller: _illnesses,
                  validator: (v) => Validators.required(v, 'الأمراض'),
                ),
              AppTextField(
                label: 'الطول (سم)',
                controller: _height,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => Validators.number(v, label: 'الطول', min: 100, max: 230),
              ),
              AppTextField(
                label: 'الوزن (كجم)',
                controller: _weight,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  final base = Validators.number(v, label: 'الوزن', min: 1, max: 250);
                  if (base != null) return base;
                  if (num.parse(v!.trim()) < 50) return 'يجب ألا يقل الوزن عن 50 كجم للتبرع';
                  return null;
                },
              ),
              AppDateField(
                label: 'اخر مره اتبرعت فيها؟',
                hint: 'اتركه فارغاً إذا لم تتبرع من قبل',
                isRequired: false,
                firstDate: DateTime(2000),
                lastDate: today,
              ),
            ],
          ),
          FormCard(
            title: 'فصيلة الدم',
            icon: Icons.water_drop,
            children: [BloodGroupField()],
          ),
        ],
      ),
    );
  }
}
