// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';
import 'package:rpmtw_wiki/screen/home_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';

import 'package:rpmtw_wiki/widget/auth_success_dialog.dart';
import 'package:seo_renderer/seo_renderer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<Locale> _locales;
  if (window.localStorage.containsKey("rpmtw_locale_languageCode")) {
    final storage = window.localStorage;
    _locales = [
      Locale.fromSubtags(
          languageCode: storage['rpmtw_locale_languageCode']!,
          scriptCode: storage['rpmtw_locale_scriptCode'],
          countryCode: storage['rpmtw_locale_countryCode']),
    ];
  } else {
    _locales = WidgetsBinding.instance!.window.locales;
  }
  locale =
      basicLocaleListResolution(_locales, AppLocalizations.supportedLocales);

  AccountHandler.init();
  href = window.location.href;
  RPMTWApiClient.init(development: true); // Initialize RPMTWApiClient
  runApp(const WikiApp());
}

class WikiApp extends StatefulWidget {
  const WikiApp({Key? key}) : super(key: key);

  @override
  State<WikiApp> createState() => _WikiAppState();
}

class _WikiAppState extends State<WikiApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RPMTW Wiki',
        navigatorKey: NavigationService.navigationKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        navigatorObservers: [routeObserver],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            fontFamily: "font"),
        initialRoute: HomePage.route,
        locale: locale,
        onGenerateRoute: (settings) {
          try {
            Uri uri = Uri.parse(href);
            String name = settings.name ?? uri.path;

            if (uri.path.startsWith("/auth")) {
              Map<String, String> query = uri.queryParameters;
              String token = query['auth_token']!;
              href = uri.replace(path: settings.name).toString();
              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => AuthSuccessDialog(token: token));
            }

            if (name == HomePage.route || name == '/index.html') {
              return MaterialPageRoute(
                  settings: settings, builder: (context) => const HomePage());
            } else {
              return MaterialPageRoute(
                  settings: settings, builder: (context) => const HomePage());
            }
          } catch (e) {
            return MaterialPageRoute(
                settings: settings, builder: (context) => const HomePage());
          }
        });
  }
}
