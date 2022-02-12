import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import "package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart";
import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/main.dart';

import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/pages/changelog/changelog_page.dart';
import 'package:rpmtw_wiki/pages/mod/edit_mod_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/extension.dart';
import 'package:rpmtw_wiki/utilities/rpmtw_theme.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/keep_alive_wrapper.dart';
import 'package:rpmtw_wiki/widget/relation_mod_view.dart';
import 'package:rpmtw_wiki/widget/seo_selectable_text.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';
import 'package:share_plus/share_plus.dart';

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

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
    mod = await apiClient.minecraftResource
        .getMinecraftMod(widget.uuid, recordViewCount: true);
    WikiApp.analytics.logViewMod(uuid: widget.uuid);

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
          title: "${localizations.viewModTitle} - ${mod.name}",
          onBackPressed: () => navigation.pop(),
          bottom: TabBar(
            isScrollable: Utility.isMobile,
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
          actions: _buildActions(),
        ),
        body: TabBarView(
          children: [
            KeepAliveWrapper(
              child: _BaseInfo(mod: mod),
            ),
            KeepAliveWrapper(child: SEOText(localizations.guiWIP)),
            KeepAliveWrapper(child: _DetailsInfo(mod: mod)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    void edit() => AccountHandler.checkHasAccount(() => navigation.pushNamed(
          EditModPage.route + mod.uuid,
        ));

    void share() {
      String url = rpmtwWikiUrl + "/mod/view/" + mod.uuid;
      if (kIsDesktop) {
        Clipboard.setData(ClipboardData(text: url));
      } else {
        Share.share(url);
      }
    }

    void copyUUID() => Clipboard.setData(ClipboardData(text: mod.uuid));

    void viewHistory() => navigation.pushNamed(
          "${ChangelogPage.route}?dataUUID=${mod.uuid}",
        );

    if (kIsMobile) {
      return [
        PopupMenuButton(
            tooltip: localizations.guiOptional,
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(localizations.editModTitle),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text(localizations.guiShare),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: Text(localizations.viewModCopyUUID),
                    value: 3,
                  ),
                  PopupMenuItem(
                    child: Text(localizations.viewModHistory),
                    value: 4,
                  )
                ],
            onSelected: (int index) {
              switch (index) {
                case 1:
                  edit();
                  break;
                case 2:
                  share();
                  break;
                case 3:
                  copyUUID();
                  break;
                case 4:
                  viewHistory();
                  break;
                default:
                  break;
              }
            })
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: localizations.editModTitle,
          onPressed: edit,
        ),
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: localizations.guiCopyLink,
          onPressed: share,
        ),
        IconButton(
          icon: const Icon(Icons.content_copy),
          tooltip: localizations.viewModCopyUUID,
          onPressed: copyUUID,
        ),
        IconButton(
          icon: const Icon(Icons.history),
          tooltip: localizations.viewModHistory,
          onPressed: viewHistory,
        ),
      ];
    }
  }
}

class _DetailsInfo extends StatefulWidget {
  final MinecraftMod mod;
  const _DetailsInfo({
    Key? key,
    required this.mod,
  }) : super(key: key);

  @override
  State<_DetailsInfo> createState() => _DetailsInfoState();
}

class _DetailsInfoState extends State<_DetailsInfo> {
  MinecraftMod get mod => widget.mod;

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
    return Column(
      children: [
        SEOText(localizations.viewModCreateAt,
            style: RPMTWTheme.titleTextStyle),
        SEOText(Utility.dateFormat(mod.createTime)),
        SizedBox(height: kSplitHight),
        SEOText(localizations.viewModLastUpdate,
            style: RPMTWTheme.titleTextStyle),
        SEOText(Utility.dateFormat(mod.lastUpdate)),
      ],
    );
  }

  Widget _buildModID() {
    if (mod.id != null && mod.id!.isNotEmpty) {
      return Column(
        children: [
          SEOText(localizations.addModIdField,
              style: RPMTWTheme.titleTextStyle),
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
          SEOText(localizations.addModDetailedIntegration,
              style: RPMTWTheme.titleTextStyle),
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
    required this.mod,
  }) : super(key: key);

  final MinecraftMod mod;

  @override
  State<_BaseInfo> createState() => _BaseInfoState();
}

class _BaseInfoState extends State<_BaseInfo> {
  MinecraftMod get mod => widget.mod;

  @override
  Widget build(BuildContext context) {
    return BasePage(builder: (context) {
      return Column(
        children: [
          SizedBox(height: kSplitHight),
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: mod.imageWidget(width: 150, height: 150)),
          SizedBox(height: kSplitHight),
          SEOSelectableText(mod.name, style: const TextStyle(fontSize: 20)),
          (mod.translatedName != null && mod.translatedName != "")
              ? SEOSelectableText(mod.translatedName!,
                  style: const TextStyle(fontSize: 20))
              : Container(),
          SizedBox(height: kSplitHight),
          _buildDescription(),
          SizedBox(height: kSplitHight),
          _buildModLoaders(),
          SizedBox(height: kSplitHight),
          _buildSupportVersions(),
          SizedBox(height: kSplitHight),
          SEOText(localizations.viewModCount, style: RPMTWTheme.titleTextStyle),
          SEOSelectableText(mod.viewCount.toString()),
          SizedBox(height: kSplitHight),
          _buildIntroduction(),
        ],
      );
    });
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
          SEOText(localizations.addModLoader, style: RPMTWTheme.titleTextStyle),
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
        SEOText(localizations.addModSupportedVersionField,
            style: RPMTWTheme.titleTextStyle),
        SEOText(
            supportVersions.map((e) => e.id).join(localizations.guiSeparator))
      ],
    );
  }

  Widget _buildIntroduction() {
    if (mod.introduction != null) {
      double width =
          kIsDesktop ? MediaQuery.of(context).size.width / 3 : kSplitWidth;
      return Column(
        children: [
          SEOText(localizations.addModIntroductionTitle,
              style: RPMTWTheme.titleTextStyle),
          Row(
            children: [
              SizedBox(width: width),
              Expanded(
                child: MarkdownBody(
                  selectable: true,
                  data: mod.introduction!,
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
