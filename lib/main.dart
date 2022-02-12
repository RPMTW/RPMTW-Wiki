import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:rpmtw_wiki/pages/changelog/changelog_page.dart';
import 'package:rpmtw_wiki/pages/mod/edit_mod_page.dart';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:rpmtw_wiki/pages/home_page.dart';
import 'package:rpmtw_wiki/pages/mod/add_mod_page.dart';
import 'package:rpmtw_wiki/pages/mod/view_mod_page.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/extension.dart';

import 'package:rpmtw_wiki/widget/auth_success_dialog.dart';
import 'package:seo_renderer/seo_renderer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Data.init();
  runApp(const WikiApp());
}

class WikiApp extends StatefulWidget {
  const WikiApp({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

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
        title: 'RPMWiki',
        navigatorKey: NavigationService.navigationKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        navigatorObservers: [routeObserver, WikiApp.observer],
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
              WikiApp.analytics.logPageView(
                  pageClass: "HomePage",
                  pageName: "Home Page",
                  parameters: {"tab_index": tabIndex.toString()});
              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => HomePage(tabIndex: tabIndex));
            } else if (name == AddModPage.route) {
              WikiApp.analytics
                  .logPageView(pageClass: "AddModPage", pageName: "Add Mod");
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
              String? dataUUID = query["dataUUID"];
              WikiApp.analytics.logPageView(
                  pageClass: "ChangelogPage",
                  pageName: "View Changelog",
                  parameters: {
                    "dataUUID": dataUUID,
                  });
              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => ChangelogPage(dataUUID: dataUUID));
            } else {
              WikiApp.analytics
                  .logPageView(pageClass: "HomePage", pageName: "Home Page");
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
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
              settings: settings, builder: (context) => const HomePage());
        });
  }
}
