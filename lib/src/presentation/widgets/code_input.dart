import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tapir_test/src/presentation/widgets/custom_text_form_field.dart';

class CodeInput extends StatelessWidget {
  final String? hint;
  final TextAlign? hintTextAlign;
  const CodeInput({
    required this.controller,
    this.onChanged,
    super.key,
    this.hint,
    this.hintTextAlign,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLength: 6,
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
      ],
      hintTextAlign: hintTextAlign,
      hint: hint ?? 'Укажите код из письма',
    );
  }
}
