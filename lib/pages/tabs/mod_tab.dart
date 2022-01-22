import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/pages/mod/add_mod_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_text_field.dart';
import 'package:rpmtw_wiki/widget/seo_selectable_text.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class ModTab extends StatefulWidget {
  const ModTab({Key? key}) : super(key: key);

  @override
  _ModTabState createState() => _ModTabState();
}

class _ModTabState extends State<ModTab> {
  @override
  Widget build(BuildContext context) {
    Size size = Utility.getSize(context);
    return BasePage(
        child: SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          SizedBox(height: kSplitHight),
          const _Action(),
          SizedBox(height: kSplitHight),
          const RPMTWDivider(),
          SizedBox(height: kSplitHight),
          const Expanded(child: _ModsView()),
        ],
      ),
    ));
  }
}

class _ModsView extends StatefulWidget {
  const _ModsView({
    Key? key,
  }) : super(key: key);

  @override
  State<_ModsView> createState() => _ModsViewState();
}

class _ModsViewState extends State<_ModsView> {
  late RPMTWApiClient apiClient;
  String? filter;

  @override
  void initState() {
    apiClient = RPMTWApiClient.lastInstance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final debouncedAutocompleteSearch = debounce(
      (String _filter) async {
        if (_filter.isEmpty) {
          filter = null;
        } else {
          filter = _filter;
        }
        setState(() {});
      },
      const Duration(milliseconds: 500),
      // 延遲 500 毫秒搜尋
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SEOText(localizations.viewModSearch,
                style: const TextStyle(fontSize: 20)),
            SizedBox(width: kSplitWidth),
            SizedBox(
              height: 50,
              width: 300,
              child: RPMTextField(
                hintText: localizations.viewModSearchHint,
                onChanged: (value) {
                  debouncedAutocompleteSearch([value]);
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<MinecraftMod>>(
              future: apiClient.minecraftResource.search(filter: filter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<MinecraftMod> mods = snapshot.data!;
                  return GridView.builder(
                    itemCount: mods.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                    ),
                    itemBuilder: (context, index) {
                      MinecraftMod mod = mods[index];

                      return FutureBuilder<WikiModData>(
                        future: apiClient.minecraftResource
                            .getWikiModDataByModUUID(mod.uuid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final WikiModData? wikiData = snapshot.data;

                            return _ModItem(wikiData: wikiData, mod: mod);
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [CircularProgressIndicator()],
                  );
                }
              }),
        ),
      ],
    );
  }
}

class _ModItem extends StatefulWidget {
  const _ModItem({
    Key? key,
    required this.wikiData,
    required this.mod,
  }) : super(key: key);

  final WikiModData? wikiData;
  final MinecraftMod mod;

  @override
  State<_ModItem> createState() => _ModItemState();
}

class _ModItemState extends State<_ModItem> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.bodyText2!;
    subtitleStyle = subtitleStyle.copyWith(color: Colors.white54);

    return InkWell(
      child: MouseRegion(
        onEnter: (e) => _mouseEnter(true),
        onExit: (e) => _mouseEnter(false),
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 200),
          tween: Tween<double>(begin: 1.0, end: scale),
          builder: (BuildContext context, double value, _) {
            return Transform.scale(
                scale: value,
                child: GridTile(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.wikiData?.imageStorageUUID != null)
                      widget.wikiData!.imageWidget(width: 100, height: 100)!
                    else
                      const Icon(Icons.image, size: 100),
                    SEOSelectableText(widget.mod.name,
                        style: const TextStyle(fontSize: 16)),
                    if (widget.wikiData?.translatedName != null)
                      SEOSelectableText(widget.wikiData!.translatedName!,
                          style: subtitleStyle),
                    SEOText(
                        "${localizations.viewModCount} ${(widget.wikiData?.viewCount ?? 0).toString()}",
                        style: subtitleStyle),
                  ],
                )));
          },
        ),
      ),
      onTap: () {},
    );
  }

  void _mouseEnter(bool hover) {
    setState(() {
      if (hover) {
        scale = 1.15;
      } else {
        scale = 1.0;
      }
    });
  }
}

class _Action extends StatelessWidget {
  const _Action({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RPMTWVerticalDivider(),
        OutlinedButton(
            child: Text(localizations.addModTitle),
            onPressed: () => AccountHandler.checkHasAccount(
                () => navigation.pushNamed(AddModPage.route))),
        const RPMTWVerticalDivider(),
      ],
    );
  }
}
