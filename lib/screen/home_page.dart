// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/account_manage_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        body: const TabBarView(children: [
          const _WIPTab(),
          const _WIPTab(),
          const _WIPTab(),
          const _WIPTab(),
          const _WIPTab(),
          const _WIPTab(),
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
        child: Text(localizations.guiWIP, style: const TextStyle(fontSize: 30)),
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
          Text(localizations.guiCopyright, textAlign: TextAlign.center),
          const SizedBox(height: 5)
        ],
      ),
    );
  }
}
