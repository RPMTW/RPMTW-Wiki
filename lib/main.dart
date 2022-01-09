// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/account_manage_button.dart';
import 'package:rpmtw_wiki/widget/auth_success_dialog.dart';

void main() async {
  AccountHandler.init();
  href = window.location.href;
  RPMTWApiClient.init(development: true); // Initialize RPMTWApiClient
  runApp(const WikiApp());
}

class WikiApp extends StatelessWidget {
  const WikiApp({Key? key}) : super(key: key);

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
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            fontFamily: "font"),
        initialRoute: HomePage.route,
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

class HomePage extends StatefulWidget {
  static const route = '/';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: Utility.isWebMobile
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkResponse(
                  onTap: () =>
                      window.open("https://www.rpmtw.com", "RPMTW Website"),
                  child: Image.asset(
                    'assets/images/RPMTW_Logo.gif',
                    fit: BoxFit.contain,
                    width: 40,
                  ),
                ),
                const SizedBox(width: 8),
                Text(localizations.title, overflow: TextOverflow.ellipsis)
              ],
            ),
            bottom: TabBar(
              isScrollable: Utility.isWebMobile,
              tabs: [
                Tab(
                    icon: const FaIcon(FontAwesomeIcons.home),
                    text: localizations.tabHome),
                Tab(
                    icon: const FaIcon(FontAwesomeIcons.puzzlePiece),
                    text: localizations.tabMod),
                Tab(
                    icon: const FaIcon(FontAwesomeIcons.globe),
                    text: localizations.tabWorld),
                Tab(
                    icon: const FaIcon(FontAwesomeIcons.palette),
                    text: localizations.tabResourcePack),
                Tab(
                    icon: const FaIcon(FontAwesomeIcons.gamepad),
                    text: localizations.tabVanilla),
                Tab(
                    icon: const FaIcon(FontAwesomeIcons.server),
                    text: localizations.tabServer),
              ],
            ),
            actions: const [AccountManageButton()],
          ),
          body: TabBarView(children: [
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ])),
    );
  }
}
