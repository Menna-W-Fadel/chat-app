import 'package:flutter/material.dart';

class AppRichText extends StatelessWidget {
  const AppRichText({
    super.key,
    required this.coloredText,
    required this.coloredTextStyle,
    required this.normalText,
    required this.normalTextStyle,
  });

  final String coloredText;
  final TextStyle coloredTextStyle;
  final String normalText;
  final TextStyle normalTextStyle;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: normalText,
        children: [TextSpan(text: coloredText, style: coloredTextStyle)],
        style: normalTextStyle,
      ),
    );
  }
}