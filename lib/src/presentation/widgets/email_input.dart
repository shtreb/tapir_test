import 'package:flutter/material.dart';
import 'package:tapir_test/src/presentation/widgets/custom_text_form_field.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    required this.controller,
    this.onChanged,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      hint: 'Email',
      isRequired: true,
      validator: validator ??
          (String? value) {
            if (value == null || value.isEmpty) {
              return 'Введите email';
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Некорректный email';
            }
            return null;
          },
    );
  }
}
