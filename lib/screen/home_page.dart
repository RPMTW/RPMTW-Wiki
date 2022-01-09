// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/account_manage_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpmtw_wiki/widget/link_text.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              SEOText(localizations.title, overflow: TextOverflow.ellipsis)
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
        body: const TabBarView(children: [
          _WIPTab(),
          _WIPTab(),
          _WIPTab(),
          _WIPTab(),
          _WIPTab(),
          _WIPTab(),
        ]),
      ),
    );
  }
}

class _WIPTab extends StatelessWidget {
  const _WIPTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseTab(
      child: Center(
        child:
            SEOText(localizations.guiWIP, style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}

class BaseTab extends StatelessWidget {
  final Widget child;
  const BaseTab({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          child,
          const SizedBox(height: 5),
          const _Footer(),
          const SizedBox(height: 5)
        ],
      ),
    );
  }
}

class _Footer extends StatefulWidget {
  const _Footer({
    Key? key,
  }) : super(key: key);

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor, width: 2)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 2),
          LinkText(
              link: "https://www.rpmtw.com", text: localizations.guiWebsite),
          const _CreativeCommons(),
          SEOText(localizations.guiCopyright, textAlign: TextAlign.center),
          SizedBox(
            width: 150,
            child: DropdownButton<Locale>(
              value: locale,
              style: const TextStyle(color: Colors.lightBlue),
              onChanged: (_locale) {
                locale = _locale!;
                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                  window.location.reload();
                });
              },
              isExpanded: true,
              items: AppLocalizations.supportedLocales
                  .where((locale) => !(locale.languageCode == "zh" &&
                      locale.scriptCode == null &&
                      locale.countryCode == null))
                  .map<DropdownMenuItem<Locale>>((Locale locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  alignment: Alignment.center,
                  child: Text(lookupAppLocalizations(locale).languageName,
                      style:
                          const TextStyle(fontSize: 17.5, fontFamily: 'font'),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 2)
        ],
      ),
    );
  }
}

class _CreativeCommons extends StatelessWidget {
  const _CreativeCommons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String localeName = WidgetsBinding.instance!.window.locale.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            SEOText(localizations.footerCC1),
            const SizedBox(width: 5),
            LinkText(
                link:
                    "https://creativecommons.org/licenses/by-nc-sa/4.0/deed.$localeName",
                text: localizations.footerCC2),
          ],
        ),
        const SizedBox(width: 5),
        Image.asset("assets/images/cc-by-nc-sa.png"),
      ],
    );
  }
}
