import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../res/colors.dart';

class ButtonSubmitForm extends StatefulWidget {
  final bool isLoading;
  final String text;
  final GlobalKey<FormState> formKey;
  final Function onAction;

  const ButtonSubmitForm({
    Key? key,
    required this.isLoading,
    required this.text,
    required this.formKey,
    required this.onAction
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ButtonSubmitForm();
}

class _ButtonSubmitForm extends State<ButtonSubmitForm> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: widget.isLoading
                  ? () {}
                  : () {
                if (widget.formKey.currentState!.validate()) {
                  widget.onAction();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: widget.isLoading
                  ? const CircularProgressIndicator(
                color: ThemeColors.whiteColor,
                ) : Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: ThemeColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

