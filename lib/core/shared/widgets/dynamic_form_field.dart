import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_my_way/core/styles/app_colors.dart';

class DynamicFormField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;
  final ValueChanged<String>? onChange;
  final void Function()? onTap;
  final bool obscureText;
  final FocusNode? focusNode;

  final bool isFilled;
  final bool isBoarder;
  final Color? labelColor;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final String? labelText;
  final String? hintText;
  final IconData? prefix;
  final Widget? suffix;
  final Color? suffixIconColor;
  final Function? suffixPressed;
  final double borderRadius;
  final Widget? prefixIcon;
  final int? maxLines;
  final bool readOnly;
  final void Function(PointerDownEvent)? onTapOutside;

  const DynamicFormField({
    super.key,
    this.controller,
    this.keyboardType,
    this.onChange,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.isFilled = true,
    this.isBoarder = false,
    this.labelColor,
    this.fillColor,
    this.labelText,
    this.hintText,
    this.prefix,
    this.suffixIconColor,
    this.suffixPressed,
    this.borderRadius = 20.0,
    this.suffix,
    this.validator,
    this.autovalidateMode,
    this.prefixIcon,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLines,
    this.onTapOutside,
  });

  @override
  State<DynamicFormField> createState() => _DynamicFormFieldState();
}

class _DynamicFormFieldState extends State<DynamicFormField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      controller: widget.controller,
      onTapOutside: widget.onTapOutside ??
          (pointerDownEvent) {
            FocusScope.of(context).unfocus();
          },
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      onChanged: widget.onChange,
      focusNode: widget.focusNode,
      maxLines: widget.obscureText == true ? 1 : widget.maxLines ?? 1,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.autoMetalSaurus,
          ),
      keyboardType: widget.keyboardType,
      obscureText: obscureText,
      cursorColor: AppColors.pumpkinOrange,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.sen().copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.spanishGray,
        ),
        prefixIcon: widget.prefixIcon,
        labelText: widget.labelText,
        labelStyle: GoogleFonts.sen().copyWith(
          fontWeight: FontWeight.w400,
        ),
        alignLabelWithHint: true,
        filled: widget.isFilled,
        fillColor: widget.fillColor ?? AppColors.aliceBlue,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        suffix: null, // Won't be used because it messes field's size
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: obscureText
                    ? const Icon(
                        Icons.remove_red_eye_rounded,
                        color: AppColors.metallicSilver,
                      )
                    : const Icon(
                        Icons.visibility_off_rounded,
                        color: AppColors.metallicSilver,
                      ),
              )
            : widget.suffix,
      ),
    );
  }
}
