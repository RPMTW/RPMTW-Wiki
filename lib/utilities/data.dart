// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

NavigatorState get navigation => NavigationService.navigationKey.currentState!;
AppLocalizations get localizations => AppLocalizations.of(navigation.context)!;

bool development = false;

const String developmentRPMWikiUrl = "http://localhost:45213";
const String productionRPMWikiUrl = "https://wiki.rpmtw.com";
const String developmentRPMTWAccountUrl = "http://localhost:41351";
const String productionRPMTWAccountUrl = "https://account.rpmtw.com";

String get rpmtwAccountUrl =>
    development ? developmentRPMTWAccountUrl : productionRPMTWAccountUrl;
String get rpmtwAccountOauth2 =>
    "$rpmtwAccountUrl?rpmtw_auth_callback=${development ? developmentRPMWikiUrl : productionRPMWikiUrl}"
    r"/auth?auth_token=${token}";
String get rpmtwWikiUrl =>
    development ? developmentRPMWikiUrl : productionRPMWikiUrl;

late String href;

late Locale _locale;

Locale get locale => _locale;
set locale(Locale value) {
  _locale = value;
  window.localStorage['rpmtw_locale_languageCode'] = value.languageCode;
  if (value.countryCode != null) {
    window.localStorage['rpmtw_locale_countryCode'] = value.countryCode!;
  }
  if (value.scriptCode != null) {
    window.localStorage['rpmtw_locale_scriptCode'] = value.scriptCode!;
  }
}
