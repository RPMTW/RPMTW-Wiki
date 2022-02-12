// ignore: avoid_web_libraries_in_flutter
import 'dart:math';

import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/main.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';

NavigatorState get navigation => NavigationService.navigationKey.currentState!;
AppLocalizations get localizations => AppLocalizations.of(navigation.context)!;

bool development =
    const bool.fromEnvironment("wiki.development", defaultValue: false);

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
  html.window.localStorage['rpmtw_locale_languageCode'] = value.languageCode;
  if (value.countryCode != null) {
    html.window.localStorage['rpmtw_locale_countryCode'] = value.countryCode!;
  }
  if (value.scriptCode != null) {
    html.window.localStorage['rpmtw_locale_scriptCode'] = value.scriptCode!;
  }
}

class Data {
  static Future<void> init() async {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
      projectId: 'rpmwiki-e318f',
      messagingSenderId: '192104675713',
      appId: '1:192104675713:web:ed21f3ed56c6e766f21080',
      measurementId: 'G-EDV902NYW0',
    ));
    html.Storage localStorage = html.window.localStorage;

    List<Locale> _locales;
    if (localStorage.containsKey("rpmtw_locale_languageCode")) {
      _locales = [
        Locale.fromSubtags(
            languageCode: localStorage['rpmtw_locale_languageCode']!,
            scriptCode: localStorage['rpmtw_locale_scriptCode'],
            countryCode: localStorage['rpmtw_locale_countryCode']),
      ];
    } else {
      _locales = WidgetsBinding.instance!.window.locales;
    }
    locale =
        basicLocaleListResolution(_locales, AppLocalizations.supportedLocales);

    AccountHandler.init();
    if (AccountHandler.hasAccount) {
      await WikiApp.analytics.setUserId(id: AccountHandler.account?.uuid);
      await WikiApp.analytics
          .setUserProperty(name: "development", value: development.toString());
    }
    href = html.window.location.href;
    RPMTWApiClient.init(development: development); // Initialize RPMTWApiClient

    html.Element? base = html.document.querySelector('base');

    if (base != null) {
      base.setAttribute("href", "/");
    } else {
      html.document.createElement('base').setAttribute("href", "/");
    }

    setPathUrlStrategy();
  }
}
