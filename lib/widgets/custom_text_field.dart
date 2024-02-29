import 'package:flutter/material.dart';
import 'package:smoments/utils/validator.dart';

import '../res/colors.dart';

enum TextFormType { name, email, password, confirmPassword }

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextFormType textFormType;
  final String? password;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.textFormType,
      this.password});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var _isObscure = false;

  @override
  void initState() {
    super.initState();
    //init obscureText
    if (widget.textFormType == TextFormType.password ||
        widget.textFormType == TextFormType.confirmPassword) {
      _isObscure = true;
    } else {
      _isObscure = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      controller: widget.controller,
      validator: (value) {
        return getValidator(widget.textFormType, value);
      },
      decoration: InputDecoration(
          errorMaxLines: 4,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(color: ThemeColors.primaryColor),
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              borderSide: BorderSide(color: ThemeColors.accentColor1)),
          hintStyle: const TextStyle(color: ThemeColors.accentColor1),
          fillColor: ThemeColors.accentColor2,
          filled: true,
          hintText: widget.hintText,
          suffixIcon: widget.textFormType == TextFormType.password ||
                  widget.textFormType == TextFormType.confirmPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: _isObscure
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off))
              : const SizedBox()),
      cursorColor: ThemeColors.primaryColor,
      style: const TextStyle(
        color: ThemeColors.whiteColor,
      ),
    );
  }

  String? getValidator(TextFormType textFormType, String? value) {
    switch (textFormType) {
      case TextFormType.name:
        return validateLength(value ?? '');
      case TextFormType.email:
        return validateEmail(value ?? '');
      case TextFormType.password:
        return validatePassword(value ?? '');
      case TextFormType.confirmPassword:
        validateConfirmPassword(widget.password!, widget.controller.text);
    }
    return null;
  }
}
