import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/pages/tabs/home_tab.dart';
import 'package:rpmtw_wiki/pages/tabs/mod_tab.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rpmtw_wiki/widget/seo_text.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';
  final int tabIndex;
  const HomePage({Key? key, this.tabIndex = 0}) : super(key: key);

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
      initialIndex: widget.tabIndex,
      length: 6,
      child: Scaffold(
        appBar: TitleBar(
          title: localizations.title,
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
        ),
        body: const TabBarView(children: [
          HomeTab(),
          ModTab(),
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
    return BasePage(
      child: Center(
        child:
            SEOText(localizations.guiWIP, style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}
