import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hint, label;
  final bool isRequired;

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextAlign? textAlign;
  final TextAlign? hintTextAlign;
  final TextCapitalization? textCapitalization;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextFormField({
    super.key,
    this.hint,
    this.label,
    this.isRequired = false,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.textAlign,
    this.hintTextAlign,
    this.textCapitalization,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 68),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              fillColor: Colors.transparent,
              label: hint == null
                  ? null
                  : RichText(
                      textAlign: hintTextAlign ?? TextAlign.start,
                      text: TextSpan(
                        text: hint,
                        style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
                        children: [
                          if (isRequired)
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9E9E9E))),
              contentPadding: EdgeInsets.zero,
              counterText: '',
              counterStyle: TextStyle(fontSize: 0),
            ),
            keyboardType: keyboardType,
            onChanged: onChanged,
            validator: validator,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            textAlign: textAlign ?? TextAlign.start,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            readOnly: readOnly,
            onTap: onTap,
          ),
          if (label?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(left: 2, top: 8, bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  label!,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, color: Color(0xFF727272)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
