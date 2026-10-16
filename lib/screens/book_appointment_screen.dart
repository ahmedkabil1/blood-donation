import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/buttons.dart';
import '../widgets/dashboard_shell.dart';
import 'success_screen.dart';

/// Appointment booking, 4 steps: branch, date, time, confirmation.
/// (Figma "Frame 10" only shows step 1; steps 2-4 follow the stepper labels.)
class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  static const _labels = ['الفرع', 'التاريخ', 'الوقت', 'التأكيد'];

  int _step = 0;
  String? _branch;
  DateTime? _date;
  String? _time;
  String? _error;
  bool _loading = false;

  void _next() {
    String? error;
    if (_step == 0 && _branch == null) error = 'برجاء اختيار الفرع';
    if (_step == 1 && _date == null) error = 'برجاء اختيار التاريخ';
    if (_step == 2 && _time == null) error = 'برجاء اختيار الوقت';
    setState(() {
      _error = error;
      if (error == null) _step++;
    });
  }

  void _prev() {
    if (_step == 0) return;
    setState(() {
      _error = null;
      _step--;
    });
  }

  Future<void> _confirm() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    AppState.instance.recordBooking();
    Navigator.of(context).pushReplacementNamed(Routes.success, arguments: SuccessKind.booking);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? today.add(const Duration(days: 1)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _error = null;
      });
    }
  }

  Widget _stepper() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _labels.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 17),
                child: Container(height: 2, color: i <= _step ? AppColors.crimson : AppColors.border),
              ),
            ),
          SizedBox(
            width: 64,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: i <= _step ? AppColors.maroon : AppColors.cardGrey,
                  child: i < _step
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '${i + 1}',
                          style: TextStyle(color: i <= _step ? Colors.white : AppColors.text, fontWeight: FontWeight.w700),
                        ),
                ),
                const SizedBox(height: 6),
                Text(_labels[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  BoxDecoration get _fieldDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 4, offset: Offset(0, 2))],
      );

  Widget _stepContent() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FieldLabel('اختر الفرع'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: _fieldDecoration,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _branch,
                  hint: const Text('اختر الفرع'),
                  borderRadius: BorderRadius.circular(12),
                  items: [for (final b in MockData.branches) DropdownMenuItem(value: b, child: Text(b))],
                  onChanged: (v) => setState(() {
                    _branch = v;
                    _error = null;
                  }),
                ),
              ),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FieldLabel('اختر التاريخ'),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: _fieldDecoration,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _date == null ? 'اختر التاريخ' : formatDate(_date!),
                        style: TextStyle(fontSize: 16, color: _date == null ? const Color(0xFF9E9E9E) : AppColors.text),
                      ),
                    ),
                    const Icon(Icons.calendar_month_outlined, color: AppColors.crimson),
                  ],
                ),
              ),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FieldLabel('اختر الوقت'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final t in MockData.timeSlots)
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => setState(() {
                      _time = t;
                      _error = null;
                    }),
                    child: Container(
                      width: 130,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _time == t ? AppColors.maroon : const Color(0xFFF7F7F9),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Text(
                        '${t}ص',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _time == t ? Colors.white : AppColors.text,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      default:
        Widget row(String k, String v) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text('$k: ', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  Expanded(child: Text(v, style: const TextStyle(fontSize: 16))),
                ],
              ),
            );
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: _fieldDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('راجع بيانات الحجز', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.crimson)),
              const SizedBox(height: 6),
              row('الفرع', _branch ?? '-'),
              row('التاريخ', _date == null ? '-' : formatDate(_date!)),
              row('الوقت', _time == null ? '-' : '${_time}ص'),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = _step == _labels.length - 1;

    return DashboardShell(
      currentRoute: Routes.dashBook,
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('احجز موعدك للتبرع بالدم الان', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
              const Text('اختر الفرع والتاريخ والوقت المناسب لك', style: TextStyle(fontSize: 15, color: AppColors.muted)),
              const SizedBox(height: 24),
              _stepper(),
              const SizedBox(height: 28),
              _stepContent(),
              if (_error != null) ErrorText(_error!),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PrimaryButton(
                      label: last ? 'تأكيد الحجز' : 'التالي',
                      loading: _loading,
                      height: 56,
                      onPressed: last ? _confirm : _next,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _step == 0 || _loading ? null : _prev,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF7F7F9),
                          foregroundColor: AppColors.text,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: AppTheme.fontFamily),
                        ),
                        child: const Text('السابق'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
