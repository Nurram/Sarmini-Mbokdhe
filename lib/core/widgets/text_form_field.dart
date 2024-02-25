import 'package:flutter/material.dart';

import '../colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function? validator;
  final TextInputType? inputType;
  final String? label;
  final String? hint;
  final bool? obscureText;
  final String? prefix;
  final String? suffix;
  final bool? readOnly;
  final int? maxLines;
  final EdgeInsets? padding;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsets? contentPadding;
  final Function(String value)? onChange;
  final bool? focuseBordered;
  final Function()? onTap;

  const CustomTextFormField(
      {Key? key,
      this.focusNode,
      required this.controller,
      this.validator,
      this.inputType,
      this.label,
      this.hint,
      this.obscureText,
      this.prefix,
      this.suffix,
      this.readOnly,
      this.maxLines,
      this.padding,
      this.suffixIcon,
      this.prefixIcon,
      this.contentPadding,
      this.onChange,
      this.focuseBordered,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 6,
        shadowColor: Colors.blue.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          onTap: () => onTap != null ? onTap!() : null,
          focusNode: focusNode,
          controller: controller,
          keyboardType: inputType ?? TextInputType.text,
          obscureText: obscureText ?? false,
          readOnly: readOnly ?? false,

          // ignore: prefer_if_null_operators
          maxLines: maxLines == null
              ? obscureText != null && obscureText!
                  ? 1
                  : null
              : maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly != null
                ? readOnly!
                    ? Colors.grey.shade100
                    : Colors.white
                : Colors.white,
            hintText: hint,
            prefix: Text(prefix ?? ''),
            suffix: Text(suffix ?? ''),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            prefixIconColor: Colors.grey,
            labelText: label,
            contentPadding: contentPadding,
            focusColor: CustomColors.primaryColor,
            floatingLabelStyle:
                const TextStyle(color: CustomColors.primaryColor),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: focuseBordered != null
                      ? focuseBordered!
                          ? CustomColors.primaryColor
                          : Colors.transparent
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: CustomColors.errorColor,
                ),
                borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Field harus diisi!';
            }

            if (validator != null) {
              return validator!(value);
            }

            return null;
          },
          onChanged: ((value) => onChange != null ? onChange!(value) : null),
        ),
      ),
    );
  }
}
