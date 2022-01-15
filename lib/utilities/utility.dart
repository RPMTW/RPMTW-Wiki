import 'package:flutter/foundation.dart';

bool get kIsWebMobile => Utility.isWebMobile;
bool get kIsWebDesktop => Utility.isWebDesktop;
double get kSplitWidth => Utility.isWebMobile ? 12 : 25;

class Utility {
  static final isWebMobile = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  static final isWebDesktop = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.fuchsia ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows);
}
