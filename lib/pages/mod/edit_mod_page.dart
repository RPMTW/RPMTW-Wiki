import "package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart";
import 'package:flutter/material.dart';

import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/keep_alive_wrapper.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';

class EditModPage extends StatefulWidget {
  static const String route = "/mod/edit/";

  /// [MinecraftMod]'s uuid
  final String uuid;
  const EditModPage({Key? key, required this.uuid}) : super(key: key);

  @override
  _EditModPageState createState() => _EditModPageState();
}

class _EditModPageState extends State<EditModPage> {
  bool loading = true;
  late MinecraftMod mod;

  @override
  void initState() {
    super.initState();

    load();
  }

  Future<void> load() async {
    RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
    mod = await apiClient.minecraftResource
        .getMinecraftMod(widget.uuid, recordViewCount: true);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Material(
        child: Center(
          child: Transform.scale(
              child: const CircularProgressIndicator(), scale: 2),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TitleBar(
          title: "${localizations.editModTitle} - ${mod.name}",
          logo: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: mod.imageWidget(width: 50, height: 50)),
          onBackPressed: () => navigation.pop(),
          bottom: TabBar(
            isScrollable: Utility.isMobile,
            tabs: [
              Tab(
                text: localizations.addModBaseTitle,
              ),
              Tab(
                text: localizations.addModIntroductionTitle,
              ),
              Tab(
                text: localizations.addModDetailedTitle,
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            KeepAliveWrapper(
              child: Container(),
            ),
            KeepAliveWrapper(child: Container()),
            KeepAliveWrapper(child: Container()),
          ],
        ),
      ),
    );
  }
}
