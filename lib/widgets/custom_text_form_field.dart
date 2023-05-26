import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/exports/managers_exports.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final String? labelText;
  final bool? readOnly;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final bool? obscureText;
  final void Function(String?)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onSuffixTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmit;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final Color? fillColor;
  final bool? autofocus;
  final TextCapitalization? textCapitalization;
  // bool readOnly;

  const CustomTextFormField({
    Key? key,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.onChanged,
    this.onSuffixTap,
    this.keyboardType,
    this.validator,
    this.onSave,
    this.inputFormatters,
    this.textInputAction,
    this.onEditingComplete,
    this.controller,
    this.onFieldSubmit,
    this.readOnly,
    this.focusNode,
    this.maxLines,
    this.maxLength,
    this.fillColor,
    this.autofocus,
    this.textCapitalization,

    // this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      cursorColor: isDarkMode
          ? DarkColorsManager.whiteColor
          : ColorsManager.primaryColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0.0),
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          color: isDarkMode
              ? DarkColorsManager.whiteColor
              : ColorsManager.primaryColor,
          fontSize: FontSize.textFontSize,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: isDarkMode
              ? DarkColorsManager.whiteColor
              : ColorsManager.primaryColor,
          fontSize: FontSize.textFontSize,
        ),
        prefixIcon: prefixIconData != null
            ? Icon(
                prefixIconData,
                size: 20,
                color: ColorsManager.lightSecondaryColor,
              )
            : null,
        suffixIcon: suffixIconData != null
            ? InkWell(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIconData,
                  size: 20,
                  color: ColorsManager.lightSecondaryColor,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode
                ? DarkColorsManager.whiteColor
                : ColorsManager.primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(RadiusManager.fieldRadius),
        ),
        floatingLabelStyle: TextStyle(
          color: isDarkMode
              ? DarkColorsManager.whiteColor
              : ColorsManager.primaryColor,
          fontSize: FontSize.textFontSize,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode
                  ? DarkColorsManager.whiteColor
                  : ColorsManager.primaryColor,
              width: 1.5),
          borderRadius: BorderRadius.circular(RadiusManager.fieldRadius),
        ),

        // fillColor: fillColor ?? kCreamColor,
        // filled: true,
        alignLabelWithHint: true,

        focusColor: isDarkMode
            ? DarkColorsManager.whiteColor
            : ColorsManager.primaryColor,

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusManager.fieldRadius),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusManager.fieldRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: FontSize.subTitleFontSize,
        ),

        // contentPadding: maxLines == null
        //     ? const EdgeInsets.all(8)
        //     : const EdgeInsets.symmetric(vertical: 15),
      ),

      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      autofocus: autofocus ?? true,
      focusNode: focusNode,
      readOnly: readOnly ?? false,
      initialValue: initialValue,
      // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: controller,
      onFieldSubmitted: onFieldSubmit,
      // readOnly: readOnly,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      scrollPadding: const EdgeInsets.all(8),
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      toolbarOptions: const ToolbarOptions(
        cut: true,
        copy: true,
        selectAll: true,
        paste: true,
      ),
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      onSaved: onSave,
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      style: TextStyle(
        // fontFamily: 'Ubuntu',
        color: isDarkMode
            ? DarkColorsManager.whiteColor
            : ColorsManager.primaryColor,
        fontSize: FontSize.textFontSize + 2,
      ),
    );
  }
}
