import 'package:flutter/material.dart';

import '../utils/exports/managers_exports.dart';

class UnderlineTextFormField extends StatefulWidget {
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization? textCapitalization;

  const UnderlineTextFormField({
    super.key,
    required this.label,
    this.validator,
    this.controller,
    this.keyboardType,
    this.maxLines,
    this.maxLength,
    this.textCapitalization,
  });

  @override
  _UnderlineTextFormFieldState createState() => _UnderlineTextFormFieldState();
}

class _UnderlineTextFormFieldState extends State<UnderlineTextFormField> {
  // ignore: unused_field
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      maxLines: widget.maxLines ?? 1,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.words,
      maxLength: widget.maxLength,
      cursorColor: ColorsManager.secondaryColor,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          fontFamily: FontsManager.fontFamilyPoppins,
          color: ColorsManager.primaryColor,
          fontSize: FontSize.subTitleFontSize * 1.2,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.primaryColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.secondaryColor),
        ),
      ),
      onChanged: (value) => setState(() {}),
      onTap: () => setState(() => _isFocused = true),
      onFieldSubmitted: (value) => setState(() => _isFocused = false),
    );
  }
}
