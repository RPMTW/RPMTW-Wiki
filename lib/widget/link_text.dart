// ignore: avoid_web_libraries_in_flutter
import 'package:universal_html/html.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';

class LinkText extends StatelessWidget {
  final String text;
  final String link;
  final TextAlign? textAlign;
  final double? fontSize;
  final bool seo;

  const LinkText(
      {Key? key,
      required this.link,
      required this.text,
      this.textAlign,
      this.fontSize,
      this.seo = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Text textWidget = Text.rich(
      TextSpan(
        style: TextStyle(
            color: Colors.lightBlue,
            fontSize: fontSize,
            decoration: TextDecoration.underline),
        text: text,
        recognizer: TapGestureRecognizer()..onTap = () => window.open(link, ""),
      ),
      textAlign: textAlign,
    );

    if (seo) {
      return LinkRenderer(
        anchorText: text,
        link: link,
        child: TextRenderer(
          text: textWidget,
        ),
      );
    } else {
      return textWidget;
    }
  }
}
