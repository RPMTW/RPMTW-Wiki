import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';

class SEOText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  const SEOText(this.data,
      {Key? key, this.style, this.textAlign, this.overflow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextRenderer(
        text:
            Text(data, style: style, textAlign: textAlign, overflow: overflow));
  }
}
