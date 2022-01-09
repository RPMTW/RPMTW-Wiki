// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  final String text;
  final String link;
  final TextAlign? textAlign;
  final double? fontSize;

  const LinkText(
      {Key? key,
      required this.link,
      required this.text,
      this.textAlign,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: Colors.lightBlue,
          fontSize: fontSize,
        ),
        text: text,
        recognizer: TapGestureRecognizer()..onTap = () => window.open(link, ""),
      ),
      textAlign: textAlign,
    );
  }
}
