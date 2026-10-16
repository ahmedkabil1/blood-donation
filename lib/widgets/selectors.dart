import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import 'app_text_field.dart';

/// White rounded card with a pink icon + red title (used by the forms).
class FormCard extends StatelessWidget {
  const FormCard({super.key, required this.title, required this.icon, required this.children});

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.pink,
                child: Icon(icon, color: AppColors.crimson, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: AppColors.crimson, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children.expand((c) => [c, const SizedBox(height: 14)]),
        ],
      ),
    );
  }
}

class RadioDot extends StatelessWidget {
  const RadioDot({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: selected ? AppColors.crimson : const Color(0xFF555555), width: 1.6),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.crimson),
              ),
            )
          : null,
    );
  }
}

/// 2-column grid of blood group pills (O+, O-, A+ ...).
class BloodGroupField extends FormField<String> {
  BloodGroupField({super.key, String? initialValue, ValueChanged<String?>? onChanged})
      : super(
          initialValue: initialValue,
          validator: (v) => v == null ? 'برجاء اختيار فصيلة الدم' : null,
          builder: (state) {
            final groups = MockData.bloodGroups;

            Widget chip(String g) {
              final sel = state.value == g;
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  state.didChange(g);
                  onChanged?.call(g);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: sel ? AppColors.pinkStrong : AppColors.pink,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: sel ? AppColors.crimson : Colors.transparent, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        g,
                        style: const TextStyle(color: AppColors.crimson, fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      RadioDot(selected: sel),
                    ],
                  ),
                ),
              );
            }

            final rows = <Widget>[];
            for (var i = 0; i < groups.length; i += 2) {
              rows.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(child: chip(groups[i])),
                      const SizedBox(width: 12),
                      Expanded(child: chip(groups[i + 1])),
                    ],
                  ),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...rows, if (state.hasError) ErrorText(state.errorText!)],
            );
          },
        );
}

/// "النوع: أنثى / ذكر" radio pair.
class GenderField extends FormField<String> {
  GenderField({super.key, String? initialValue, ValueChanged<String?>? onChanged})
      : super(
          initialValue: initialValue,
          validator: (v) => v == null ? 'برجاء اختيار النوع' : null,
          builder: (state) {
            Widget option(String label) {
              final sel = state.value == label;
              return InkWell(
                onTap: () {
                  state.didChange(label);
                  onChanged?.call(label);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 8),
                      RadioDot(selected: sel),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const FieldLabel('النوع:'),
                    const SizedBox(width: 12),
                    option('أنثى'),
                    const SizedBox(width: 12),
                    option('ذكر'),
                  ],
                ),
                if (state.hasError) ErrorText(state.errorText!),
              ],
            );
          },
        );
}

/// Question with نعم / لا answers.
class YesNoField extends FormField<bool> {
  YesNoField({super.key, required String question, bool? initialValue, ValueChanged<bool?>? onChanged})
      : super(
          initialValue: initialValue,
          validator: (v) => v == null ? 'برجاء اختيار نعم أو لا' : null,
          builder: (state) {
            Widget option(String label, bool value) {
              final sel = state.value == value;
              return InkWell(
                onTap: () {
                  state.didChange(value);
                  onChanged?.call(value);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 8),
                      RadioDot(selected: sel),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(question),
                const SizedBox(height: 4),
                Row(children: [option('نعم', true), const SizedBox(width: 16), option('لا', false)]),
                if (state.hasError) ErrorText(state.errorText!),
              ],
            );
          },
        );
}

/// Dropdown with the same look as the filled text fields.
class AppDropdownField<T> extends FormField<T> {
  AppDropdownField({
    super.key,
    required List<T> items,
    required String Function(T) labelOf,
    String? label,
    String hint = 'اختر',
    String errorMessage = 'برجاء الاختيار',
    T? initialValue,
    ValueChanged<T?>? onChanged,
  }) : super(
          initialValue: initialValue,
          validator: (v) => v == null ? errorMessage : null,
          builder: (state) {
            final box = Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.field,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: state.hasError ? AppColors.crimson : Colors.transparent),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isExpanded: true,
                  value: state.value,
                  hint: Text(hint, style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 15)),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  borderRadius: BorderRadius.circular(12),
                  items: items
                      .map((e) => DropdownMenuItem<T>(value: e, child: Text(labelOf(e), style: const TextStyle(fontSize: 15))))
                      .toList(),
                  onChanged: (v) {
                    state.didChange(v);
                    onChanged?.call(v);
                  },
                ),
              ),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null) ...[FieldLabel(label), const SizedBox(height: 6)],
                box,
                if (state.hasError) ErrorText(state.errorText!),
              ],
            );
          },
        );
}

/// Date picker field (opens the Material date picker, localized to Arabic).
class AppDateField extends FormField<DateTime> {
  AppDateField({
    super.key,
    required DateTime firstDate,
    required DateTime lastDate,
    String? label,
    String hint = 'اختر التاريخ',
    String errorMessage = 'برجاء اختيار التاريخ',
    bool isRequired = true,
    DateTime? initialValue,
    DateTime? pickerStart,
    String? Function(DateTime)? extraValidator,
    ValueChanged<DateTime?>? onChanged,
  }) : super(
          initialValue: initialValue,
          validator: (v) {
            if (v == null) return isRequired ? errorMessage : null;
            return extraValidator?.call(v);
          },
          builder: (state) {
            DateTime clamp(DateTime d) {
              if (d.isBefore(firstDate)) return firstDate;
              if (d.isAfter(lastDate)) return lastDate;
              return d;
            }

            Future<void> pick() async {
              final picked = await showDatePicker(
                context: state.context,
                initialDate: clamp(state.value ?? pickerStart ?? DateTime.now()),
                firstDate: firstDate,
                lastDate: lastDate,
              );
              if (picked != null) {
                state.didChange(picked);
                onChanged?.call(picked);
              }
            }

            final value = state.value;
            final box = InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: pick,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: state.hasError ? AppColors.crimson : Colors.transparent),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value == null ? hint : formatDate(value),
                        style: TextStyle(
                          fontSize: 15,
                          color: value == null ? const Color(0xFF9E9E9E) : AppColors.text,
                        ),
                      ),
                    ),
                    const Icon(Icons.calendar_month_outlined, size: 20, color: AppColors.crimson),
                  ],
                ),
              ),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null) ...[FieldLabel(label), const SizedBox(height: 6)],
                box,
                if (state.hasError) ErrorText(state.errorText!),
              ],
            );
          },
        );
}
