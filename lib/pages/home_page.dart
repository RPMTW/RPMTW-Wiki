import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/main.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/pages/tabs/home_tab.dart';
import 'package:rpmtw_wiki/pages/tabs/mod_tab.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpmtw_wiki/widget/keep_alive_wrapper.dart';

import 'package:rpmtw_wiki/widget/seo_text.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';
  final int tabIndex;
  const HomePage({Key? key, this.tabIndex = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RouteAware {
  late final TabController _controller;
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = widget.tabIndex;
    _controller = TabController(
      vsync: this,
      length: 6,
      initialIndex: selectedIndex,
    );
    _controller.addListener(() {
      setState(() {
        if (selectedIndex != _controller.index) {
          selectedIndex = _controller.index;
          _sendCurrentTabToAnalytics();
        }
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WikiApp.observer.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    WikiApp.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(
        title: localizations.title,
        bottom: TabBar(
          controller: _controller,
          isScrollable: Utility.isMobile,
          tabs: [
            Tab(
                icon: const FaIcon(FontAwesomeIcons.home),
                text: localizations.tabHome),
            Tab(
                icon: const FaIcon(FontAwesomeIcons.puzzlePiece),
                text: localizations.tabMod),
            Tab(
                icon: const FaIcon(FontAwesomeIcons.box),
                text: localizations.tabModpack),
            Tab(
                icon: const FaIcon(FontAwesomeIcons.globe),
                text: localizations.tabWorld),
            Tab(
                icon: const FaIcon(FontAwesomeIcons.palette),
                text: localizations.tabResourcePack),
            Tab(
                icon: const FaIcon(FontAwesomeIcons.gamepad),
                text: localizations.tabVanilla),
          ],
        ),
      ),
      body: TabBarView(controller: _controller, children: const [
        KeepAliveWrapper(child: HomeTab()),
        KeepAliveWrapper(child: ModTab()),
        _WIPTab(),
        _WIPTab(),
        _WIPTab(),
        _WIPTab(),
      ]),
    );
  }

  void _sendCurrentTabToAnalytics() {
    int index = _controller.index;
    late String tabName;
    switch (index) {
      case 0:
        tabName = 'home';
        break;
      case 1:
        tabName = 'mod';
        break;
      case 2:
        tabName = 'modpack';
        break;
      case 3:
        tabName = 'world';
        break;
      case 4:
        tabName = 'resourcePack';
        break;
      case 5:
        tabName = 'vanilla';
        break;
    }

    WikiApp.analytics.setCurrentScreen(
      screenName: '${HomePage.route}/tab/$tabName',
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
      builder: (context) {
        return Center(
          child: SEOText(localizations.guiWIP,
              style: const TextStyle(fontSize: 30)),
        );
      },
    );
  }
}
