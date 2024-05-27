// ignore: file_names
import 'package:flutter/material.dart';
import 'package:uniwayapp/colors/colors.dart';

class CustumTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool enabled;
  final TextEditingController? controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator? validator;
  final Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final Widget? icons;
  final IconButton? iconButton;
  final double? height;
  final double? width;
  final Color? colors;
  final void Function(String)? onChanged;
  final String? initialValue; // New property for initial value

  const CustumTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.onChanged,
    this.enabled = true,
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.validator,
    this.onFieldSubmitted,
    this.icons,
    this.height,
    this.width,
    this.iconButton,
    this.onSaved,
    this.colors,
    this.initialValue, // Add initial value property
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: height,
      width: width,
      child: TextFormField(
        initialValue: initialValue, // Set the initial value
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: colors ?? grey2,
        ),
        enabled: enabled,
        controller: controller,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors ?? grey, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(
            labelText,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: colors ?? grey2,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: colors ?? grey2,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              width: 2,
              color: colors ?? grey,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              width: 2,
              color: colors ?? grey,
            ),
          ),
          prefixIcon: icons,
        ),
      ),
    );
  }
}
