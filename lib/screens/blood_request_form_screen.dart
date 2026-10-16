import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/routes.dart';
import '../core/validators.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/feedback.dart';
import '../widgets/form_page.dart';
import '../widgets/public_scaffold.dart';
import '../widgets/selectors.dart';
import 'success_screen.dart';

/// Blood REQUEST form (for a patient who needs blood) - Figma "Frame 14".
class BloodRequestFormScreen extends StatefulWidget {
  const BloodRequestFormScreen({super.key});

  @override
  State<BloodRequestFormScreen> createState() => _BloodRequestFormScreenState();
}

class _BloodRequestFormScreenState extends State<BloodRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _age = TextEditingController();
  final _hospital = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _age.dispose();
    _hospital.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      showFeedback(context, 'برجاء مراجعة الحقول المطلوبة', isError: true);
      return;
    }
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    AppState.instance.recordRequest();
    Navigator.of(context).pushReplacementNamed(Routes.success, arguments: SuccessKind.request);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return PublicScaffold(
      currentRoute: Routes.request,
      backgroundColor: const Color(0xFFF2F2F4),
      body: FormPageLayout(
        formKey: _formKey,
        title: 'استمارة طلب الدم',
        subtitle: 'املأ بيانات الحالة بدقة ليصل طلبك بسرعة',
        submitLabel: 'إرسال الطلب',
        loading: _loading,
        onSubmit: _submit,
        cards: [
          FormCard(
            title: 'بيانات المريض',
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
              AppTextField(
                label: 'العمر',
                controller: _age,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => Validators.number(v, label: 'العمر', min: 0, max: 120),
              ),
            ],
          ),
          FormCard(
            title: 'بيانات الطلب',
            icon: Icons.monitor_heart_outlined,
            children: [
              AppTextField(label: 'المستشفى', controller: _hospital, validator: (v) => Validators.required(v, 'اسم المستشفى')),
              AppDropdownField<String>(
                label: 'درجة الاستعجال',
                hint: 'اختر درجة الاستعجال',
                items: MockData.urgencyLevels,
                labelOf: (s) => s,
                errorMessage: 'برجاء اختيار درجة الاستعجال',
              ),
              AppDateField(
                label: 'تاريخ الاحتياج',
                hint: 'اختر تاريخ الاحتياج',
                firstDate: today,
                lastDate: today.add(const Duration(days: 90)),
                errorMessage: 'برجاء اختيار تاريخ الاحتياج',
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
