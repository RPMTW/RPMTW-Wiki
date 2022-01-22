import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';

class SEOSelectableText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  const SEOSelectableText(this.data,
      {Key? key, this.style, this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextRenderer(
        text:
            SelectableText(data, style: style, textAlign: textAlign));
  }
}
