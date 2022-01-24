import 'package:universal_html/html.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:url_launcher/url_launcher.dart';

bool get kIsWebMobile => Utility.isWebMobile;
bool get kIsWebDesktop => Utility.isWebDesktop;
double get kSplitWidth => Utility.isWebMobile ? 12 : 25;
double get kSplitHight => Utility.isWebMobile ? 6 : 8;

class Utility {
  static final isWebMobile = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  static final isWebDesktop = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.fuchsia ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows);

  static Future<void> showErrorFlushbar(
      BuildContext context, String error) async {
    Flushbar flushbar = Flushbar(
      title: localizations.guiError,
      message: error,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    );
    await flushbar.show(context);
  }

  static Size getSize(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    Size _size = data.size;

    return Size(
        _size.width,
        (_size.height -
                data.padding.top -
                data.padding.bottom -
                data.viewPadding.top -
                data.viewPadding.bottom) *
            0.8);
  }

  static void openUrl(String url, {String? name}) {
    if (kIsWeb) {
      window.open(url, name ?? "");
    } else {
      launch(url);
    }
  }
}
