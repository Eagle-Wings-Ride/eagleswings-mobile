import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    required this.controller,
    this.suffixIcon,
    this.prefixIcon,
    required this.obscureText,
    this.maxLines,
    required this.filled,
    required this.keyboardType,
    this.errorText,
    this.maxLength,
    this.onChanged,
    this.enableInteractiveSelection,
    this.willContainPrefix,
    required this.readOnly,
    this.validator,
    this.onTap,
    this.autoValidateMode,
    this.suffix,
    this.suffixIconColor,
  });

  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Color? suffixIconColor;
  final bool obscureText;
  final int? maxLines;
  final bool filled;
  final TextInputType keyboardType;
  final String? errorText;
  final int? maxLength;
  final void Function(String)? onChanged;
  final bool? enableInteractiveSelection;
  final bool? willContainPrefix;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final AutovalidateMode? autoValidateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      enableSuggestions: true,
      keyboardType: keyboardType,
      obscureText: false,
      cursorHeight: 12,
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primary,
      enableInteractiveSelection: false,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: filled,
        fillColor: const Color(0xffF7F6F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xff616161),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: textColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xff616161),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        hintText: hintText,
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        // errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconColor: const Color(0xff616161),
        suffixIconColor: const Color(0xff616161),

        contentPadding: EdgeInsets.all(12.sp),
      ),
      maxLines: 1,

      // validator: validator,
      //  onChanged: onChanged,
    );
  }
}
