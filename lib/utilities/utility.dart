import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/data.dart';

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
}
