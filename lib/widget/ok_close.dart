import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class OkClose extends StatelessWidget {
  final Function? onOk;
  final String? title;
  final Color? color;
  final bool seo;
  const OkClose({
    Key? key,
    this.title,
    this.color,
    this.onOk,
    this.seo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
          if (onOk != null) {
            onOk!.call();
          }
        },
        child: seo
            ? SEOText(
                title ?? "OK",
                style: TextStyle(color: color),
              )
            : Text(
                title ?? "OK",
                style: TextStyle(color: color),
              ));
  }
}
