import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import "package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart";
import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/models/mod_info.dart';

import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/extension.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/keep_alive_wrapper.dart';
import 'package:rpmtw_wiki/widget/relation_mod_view.dart';
import 'package:rpmtw_wiki/widget/seo_selectable_text.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';

const TextStyle _titleStyle = TextStyle(fontSize: 25, color: Colors.blue);

class ViewModPage extends StatefulWidget {
  static const String route = "/mod/view/";

  /// [MinecraftMod]'s uuid
  final String uuid;
  const ViewModPage({Key? key, required this.uuid}) : super(key: key);

  @override
  _ViewModPageState createState() => _ViewModPageState();
}

class _ViewModPageState extends State<ViewModPage> {
  bool loading = true;
  late MinecraftMod mod;
  late WikiModData wikiData;

  @override
  void initState() {
    super.initState();

    load();
  }

  Future<void> load() async {
    RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
    mod = await apiClient.minecraftResource.getMinecraftMod(widget.uuid);
    wikiData =
        await apiClient.minecraftResource.getWikiModDataByModUUID(mod.uuid);

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

    ModInfo modInfo = ModInfo(mod: mod, wikiData: wikiData);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TitleBar(
          title: "${localizations.viewModTitle} - ${mod.name}",
          logo: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: wikiData.imageWidget(width: 50, height: 50)),
          onBackPressed: () => navigation.pop(),
          bottom: TabBar(
            isScrollable: Utility.isWebMobile,
            tabs: [
              Tab(
                text: localizations.addModBaseTitle,
              ),
              Tab(
                text: localizations.viewModComment,
              ),
              Tab(
                text: localizations.addModDetailedTitle,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            KeepAliveWrapper(
              child: _BaseInfo(modInfo: modInfo),
            ),
            KeepAliveWrapper(child: SEOText(localizations.guiWIP)),
            KeepAliveWrapper(child: _DetailsInfo(modInfo: modInfo)),
          ],
        ),
      ),
    );
  }
}

class _DetailsInfo extends StatefulWidget {
  final ModInfo modInfo;
  const _DetailsInfo({
    Key? key,
    required this.modInfo,
  }) : super(key: key);

  @override
  State<_DetailsInfo> createState() => _DetailsInfoState();
}

class _DetailsInfoState extends State<_DetailsInfo> {
  MinecraftMod get mod => widget.modInfo.mod;
  WikiModData get wikiData => widget.modInfo.wikiData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildModID(),
        _buildIntegration(),
        _buildDateTime(),
        SizedBox(height: kSplitHight),
        _buildRelationMod(),
      ],
    );
  }

  Widget _buildRelationMod() {
    if (mod.relationMods.isNotEmpty) {
      return Column(
        children: [
          SEOText(localizations.addModDetailedRelation),
          RelationModView(relationMods: mod.relationMods),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildDateTime() {
    DateFormat format = DateFormat.yMMMMEEEEd(locale.toString()).add_jms();
    return Column(
      children: [
        SEOText(localizations.viewModCreateAt, style: _titleStyle),
        SEOText(format.format(mod.createTime)),
        SizedBox(height: kSplitHight),
        SEOText(localizations.viewModLastUpdate, style: _titleStyle),
        SEOText(format.format(mod.lastUpdate)),
      ],
    );
  }

  Widget _buildModID() {
    if (mod.id != null && mod.id!.isNotEmpty) {
      return Column(
        children: [
          SEOText(localizations.addModIdField, style: _titleStyle),
          SEOSelectableText(mod.id!),
          SizedBox(height: kSplitHight),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildIntegration() {
    if (mod.integration.isCurseForge || mod.integration.isModrinth) {
      return Column(
        children: [
          SEOText(localizations.addModDetailedIntegration, style: _titleStyle),
          ...mod.integration.curseForgeID != null
              ? [
                  SEOText(localizations.addModDetailedCurseForgeField),
                  SEOSelectableText(mod.integration.curseForgeID!),
                  SizedBox(height: kSplitHight),
                ]
              : [],
          ...mod.integration.modrinthID != null
              ? [
                  SEOText(localizations.addModDetailedModrinthField),
                  SEOSelectableText(mod.integration.modrinthID!),
                  SizedBox(height: kSplitHight),
                ]
              : [],
        ],
      );
    } else {
      return Container();
    }
  }
}

class _BaseInfo extends StatefulWidget {
  const _BaseInfo({
    Key? key,
    required this.modInfo,
  }) : super(key: key);

  final ModInfo modInfo;

  @override
  State<_BaseInfo> createState() => _BaseInfoState();
}

class _BaseInfoState extends State<_BaseInfo> {
  MinecraftMod get mod => widget.modInfo.mod;
  WikiModData get wikiData => widget.modInfo.wikiData;

  @override
  Widget build(BuildContext context) {
    return BasePage(
        child: Column(
      children: [
        SizedBox(height: kSplitHight),
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: wikiData.imageWidget(width: 150, height: 150)),
        SizedBox(height: kSplitHight),
        SEOSelectableText(mod.name, style: const TextStyle(fontSize: 20)),
        wikiData.translatedName != null
            ? SEOSelectableText(wikiData.translatedName!,
                style: const TextStyle(fontSize: 20))
            : Container(),
        SizedBox(height: kSplitHight),
        _buildDescription(),
        SizedBox(height: kSplitHight),
        _buildModLoaders(),
        SizedBox(height: kSplitHight),
        _buildSupportVersions(),
        SizedBox(height: kSplitHight),
        SEOText(localizations.viewModCount, style: _titleStyle),
        SEOSelectableText(wikiData.viewCount.toString()),
        SizedBox(height: kSplitHight),
        _buildIntroduction(),
      ],
    ));
  }

  Widget _buildDescription() {
    if (mod.description != null && mod.description!.isNotEmpty) {
      return SEOSelectableText(mod.description!);
    } else {
      return Container();
    }
  }

  Widget _buildModLoaders() {
    if (mod.loader != null && mod.loader!.isNotEmpty) {
      return Column(
        children: [
          SEOText(localizations.addModLoader, style: _titleStyle),
          SEOText(mod.loader!
              .map((e) => e.name.toCapitalized())
              .join(localizations.guiSeparator)),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildSupportVersions() {
    List<MinecraftVersion> supportVersions = mod.supportVersions;

    return Column(
      children: [
        SEOText(localizations.addModSupportedVersionField, style: _titleStyle),
        SEOText(
            supportVersions.map((e) => e.id).join(localizations.guiSeparator))
      ],
    );
  }

  Widget _buildIntroduction() {
    if (wikiData.introduction != null) {
      double width =
          kIsWebDesktop ? MediaQuery.of(context).size.width / 3 : kSplitWidth;
      return Column(
        children: [
          SEOText(localizations.addModIntroductionTitle, style: _titleStyle),
          Row(
            children: [
              SizedBox(width: width),
              Expanded(
                child: MarkdownBody(
                  selectable: true,
                  data: wikiData.introduction!,
                  onTapLink: (String text, String? href, String title) {
                    if (href != null) {
                      Utility.openUrl(href,
                          name: title.isNotEmpty ? title : text);
                    }
                  },
                ),
              ),
              SizedBox(width: width),
            ],
          ),
          SizedBox(height: kSplitHight),
        ],
      );
    } else {
      return Container();
    }
  }
}
