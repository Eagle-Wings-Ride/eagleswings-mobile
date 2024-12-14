import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles/styles.dart';
import 'package:google_fonts/google_fonts.dart';

//button style

// ignore: must_be_immutable
class Button extends StatefulWidget {
  dynamic onTap;
  final String text;
  dynamic color;
  dynamic borcolor;
  dynamic textcolor;
  dynamic width;

  Button(
      {super.key,
      required this.onTap,
      required this.text,
      this.color,
      this.borcolor,
      this.textcolor,
      this.width});

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: media.width * 0.12,
        width: (widget.width != null) ? widget.width : null,
        padding: EdgeInsets.only(
            left: media.width * twenty, right: media.width * twenty),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: (widget.color != null) ? widget.color : buttonColor,
            border: Border.all(
              color: (widget.borcolor != null) ? widget.borcolor : buttonColor,
              width: 1,
            )),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            widget.text,
            style: GoogleFonts.roboto(
                fontSize: media.width * sixteen,
                color:
                    (widget.textcolor != null) ? widget.textcolor : buttonText,
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}

//input field style

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  dynamic icon;
  dynamic onTap;
  final String text;
  final TextEditingController textController;
  dynamic inputType;
  dynamic maxLength;
  dynamic color;

  // ignore: use_key_in_widget_constructors
  InputField(
      {this.icon,
      this.onTap,
      required this.text,
      required this.textController,
      this.inputType,
      this.maxLength,
      this.color});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return TextFormField(
      maxLength: (widget.maxLength == null) ? null : widget.maxLength,
      keyboardType: (widget.inputType == null)
          ? TextInputType.emailAddress
          : widget.inputType,
      controller: widget.textController,
      decoration: InputDecoration(
          counterText: '',
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: inputfocusedUnderline,
            width: 1.2,
            style: BorderStyle.solid,
          )),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: (widget.color == null) ? inputUnderline : widget.color,
            width: 1.2,
            style: BorderStyle.solid,
          )),
          prefixIcon: (widget.icon != null)
              ? Icon(
                  widget.icon,
                  size: media.width * 0.064,
                  color: textColor,
                )
              : null,
          hintText: widget.text,
          hintStyle: GoogleFonts.roboto(
            fontSize: media.width * sixteen,
            color: hintColor,
          )),
      onChanged: widget.onTap,
    );
  }
}

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget(
      {super.key,
      this.labelText,
      this.textAlign = TextAlign.start,
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
      this.maxLengthEnforcement,
      this.autoValidateMode,
      this.suffix,
      this.suffixIconColor});
  final String? labelText;
  final TextAlign? textAlign;
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
  final MaxLengthEnforcement? maxLengthEnforcement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h, left: 3.w, right: 3.w),
          child: Text(
            labelText!,
            style: GoogleFonts.dmSans(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        TextFormField(
          autovalidateMode: autoValidateMode,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: true,
          enableSuggestions: true,
          keyboardType: keyboardType,
          obscureText: obscureText,
          controller: controller,
          cursorColor: textColor,
          textAlign: textAlign!,
          cursorHeight: 14,
          enableInteractiveSelection: enableInteractiveSelection,
          style: GoogleFonts.dmSans(color: textColor, fontSize: 14),

          inputFormatters: [],
          maxLength: maxLength,
          decoration: InputDecoration(
            filled: filled,
            // fillColor: Colors.black12,
            fillColor: Theme.of(context).canvasColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color(0xffE0E0E0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: backgroundColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color(0xffE0E0E0),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            hintText: hintText,
            errorStyle: GoogleFonts.dmSans(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: GoogleFonts.dmSans(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            errorText: errorText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            suffix: suffix,
            suffixIconColor: suffixIconColor,

            contentPadding: EdgeInsets.all(14.sp),
          ),
          maxLines: 1,

          validator: validator,
          //  onChanged: onChanged,
        ),
      ],
    );
  }
}
