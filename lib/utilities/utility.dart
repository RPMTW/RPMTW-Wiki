import 'package:intl/intl.dart';
import 'package:universal_html/html.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:url_launcher/url_launcher.dart';

bool get kIsMobile => Utility.isMobile;
bool get kIsDesktop => Utility.isDesktop;
double get kSplitWidth => Utility.isMobile ? 12 : 25;
double get kSplitHight => Utility.isMobile ? 6 : 8;

class Utility {
  static final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  static final isDesktop = defaultTargetPlatform == TargetPlatform.fuchsia ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows;

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

  static String dateFormat(DateTime time) {
    DateFormat format = DateFormat.yMMMMEEEEd(locale.toString()).add_jms();
    return format.format(time);
  }
}
