import 'package:rpmtw_wiki/pages/changelog/changelog_page.dart';
import 'package:rpmtw_wiki/pages/mod/edit_mod_page.dart';
import 'package:universal_html/html.dart';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';
import 'package:rpmtw_wiki/pages/home_page.dart';
import 'package:rpmtw_wiki/pages/mod/add_mod_page.dart';
import 'package:rpmtw_wiki/pages/mod/view_mod_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';

import 'package:rpmtw_wiki/widget/auth_success_dialog.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  /// Remove the leading hash (#) from the URL
  setPathUrlStrategy();
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
  RPMTWApiClient.init(development: development); // Initialize RPMTWApiClient
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
    /// https://github.com/flutter/flutter/issues/81215
    TextStyle fontStyle = const TextStyle(
        fontFeatures: [ui.FontFeature.proportionalFigures()],
        fontFamily: "font");

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
            fontFamily: "font",
            textTheme: TextTheme(
              bodyText2: fontStyle,
              bodyText1: fontStyle,
              headline6: fontStyle,
              headline5: fontStyle,
              headline4: fontStyle,
              headline3: fontStyle,
              headline2: fontStyle,
              headline1: fontStyle,
              caption: fontStyle,
              button: fontStyle,
              subtitle2: fontStyle,
              subtitle1: fontStyle,
              overline: fontStyle,
            ),
            tooltipTheme: const TooltipThemeData(
                textStyle: TextStyle(fontFamily: "font", color: Colors.black))),
        initialRoute: HomePage.route,
        locale: locale,
        onGenerateRoute: (settings) {
          try {
            Uri hrefUri = Uri.parse(href);
            String name = settings.name ?? hrefUri.path;
            Uri routeUri = Uri.parse(name);

            if (hrefUri.path.startsWith("/auth")) {
              Map<String, String> query = hrefUri.queryParameters;
              String token = query['auth_token']!;
              href = hrefUri.replace(path: settings.name).toString();

              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) {
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AuthSuccessDialog(token: token));
                    });
                    return const HomePage();
                  });
            }
            if (name.startsWith(HomePage.route)) {
              int tabIndex = 0;
              if (routeUri.queryParameters.containsKey("tab_index")) {
                tabIndex = int.parse(routeUri.queryParameters["tab_index"]!);
              }

              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => HomePage(tabIndex: tabIndex));
            } else if (name == AddModPage.route) {
              return MaterialPageRoute(
                  settings: settings, builder: (context) => const AddModPage());
            } else if (name.startsWith(ViewModPage.route)) {
              String uuid = routeUri.pathSegments[2];

              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => ViewModPage(uuid: uuid));
            } else if (name.startsWith(EditModPage.route)) {
              String uuid = routeUri.pathSegments[2];

              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => EditModPage(uuid: uuid));
            } else if (name.startsWith(ChangelogPage.route)) {
              Map<String, String> query = routeUri.queryParameters;
              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) =>
                      ChangelogPage(dataUUID: query['data_uuid']));
            } else {
              return MaterialPageRoute(
                  settings: settings, builder: (context) => const HomePage());
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            return MaterialPageRoute(
                settings: settings, builder: (context) => const HomePage());
          }
        });
  }
}
