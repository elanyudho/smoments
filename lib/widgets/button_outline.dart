import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/colors.dart';

class ButtonOutline extends StatelessWidget {
  final bool isLoading;
  final String text;
  final Function onClick;
  final double maxWidth;

  const ButtonOutline(
      {Key? key,
      required this.isLoading,
      required this.text,
      required this.onClick,
      required this.maxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: maxWidth),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isLoading
                  ? () {}
                  : () { onClick();},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: const BorderSide(color: ThemeColors.primaryColor)
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: ThemeColors.whiteColor,
                    )
                  : Text(
                      text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: ThemeColors.primaryColor,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
