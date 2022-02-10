import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/pages/changelog/changelog_page.dart';
import 'package:rpmtw_wiki/pages/mod/add_mod_page.dart';
import 'package:rpmtw_wiki/pages/mod/view_mod_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/extension.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/mouse_scale.dart';
import 'package:rpmtw_wiki/widget/non_scrollable_grid.dart';
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
    Size size = Utility.getScreenSize(context);
    return BasePage(builder: (context) {
      return SizedBox(
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
      );
    });
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
  ModSortType sortType = ModSortType.createTime;

  @override
  void initState() {
    apiClient = RPMTWApiClient.lastInstance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final debouncedAutocompleteSearch = debounce(
      (String _filter, ModSortType _sortType) async {
        if (_filter.isEmpty) {
          filter = null;
        } else {
          filter = _filter;
        }
        sortType = _sortType;
        setState(() {});
      },
      const Duration(milliseconds: 500),
      // 延遲 500 毫秒搜尋
    );

    return Column(
      children: [
        _Search(debouncedAutocompleteSearch: debouncedAutocompleteSearch),
        SizedBox(height: kSplitHight),
        FutureBuilder<List<MinecraftMod>>(
            future: apiClient.minecraftResource
                .search(filter: filter, sort: sortType),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                List<MinecraftMod> mods = snapshot.data!;
                return NonScrollableGrid(
                  columnCount: MediaQuery.of(context).size.width ~/ 180,
                  children: mods.map((e) => _ModItem(mod: e)).toList(),
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [CircularProgressIndicator()],
                );
              }
            }),
      ],
    );
  }
}

class _Search extends StatefulWidget {
  const _Search({
    Key? key,
    required this.debouncedAutocompleteSearch,
  }) : super(key: key);

  final Debounce debouncedAutocompleteSearch;

  @override
  State<_Search> createState() => _SearchState();
}

class _SearchState extends State<_Search> {
  ModSortType sortType = ModSortType.createTime;
  String filter = "";

  void search() {
    widget.debouncedAutocompleteSearch([filter, sortType]);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SEOText(localizations.viewModSearch,
              style: const TextStyle(fontSize: 20)),
          SizedBox(width: kSplitWidth),
          SizedBox(
            height: 50,
            width: 400,
            child: RPMTextField(
              hintText: localizations.viewModSearchHint,
              onChanged: (value) {
                filter = value;
                search();
              },
            ),
          ),
          SizedBox(width: kSplitWidth),
          _buildSortDropdownButton()
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SEOText(localizations.viewModSearch,
              style: const TextStyle(fontSize: 20)),
          SizedBox(height: kSplitHight),
          SizedBox(
            height: 50,
            width: 350,
            child: RPMTextField(
              hintText: localizations.viewModSearchHint,
              onChanged: (value) {
                filter = value;
                search();
              },
            ),
          ),
          SizedBox(height: kSplitHight),
          _buildSortDropdownButton(),
        ],
      );
    }
  }

  Widget _buildSortDropdownButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SEOText(localizations.modSortType,
            style: const TextStyle(fontSize: 20)),
        SizedBox(width: kSplitWidth),
        SizedBox(
          width: kIsDesktop ? 150 : 120,
          child: DropdownButton<ModSortType>(
            value: sortType,
            style: const TextStyle(color: Colors.lightBlue),
            onChanged: (_sortType) {
              setState(() {
                sortType = _sortType!;
              });
              search();
            },
            isExpanded: true,
            items: ModSortType.values
                .map<DropdownMenuItem<ModSortType>>((ModSortType _sortType) {
              return DropdownMenuItem<ModSortType>(
                value: _sortType,
                alignment: Alignment.center,
                child: SEOText(_sortType.i18n,
                    style: const TextStyle(fontSize: 16, fontFamily: 'font'),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ModItem extends StatefulWidget {
  const _ModItem({
    Key? key,
    required this.mod,
  }) : super(key: key);

  final MinecraftMod mod;

  @override
  State<_ModItem> createState() => _ModItemState();
}

class _ModItemState extends State<_ModItem> {
  @override
  Widget build(BuildContext context) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.bodyText2!;
    subtitleStyle = subtitleStyle.copyWith(color: Colors.white54);

    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: MouseScale(
        child: GridTile(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.mod.imageStorageUUID != null)
              widget.mod.imageWidget(width: 100, height: 100)!
            else
              const Icon(Icons.image, size: 100),
            SEOSelectableText(widget.mod.name,
                style: const TextStyle(fontSize: 16)),
            if (widget.mod.translatedName != null)
              SEOSelectableText(widget.mod.translatedName!,
                  style: subtitleStyle),
            SEOText(
                "${localizations.viewModCount} ${(widget.mod.viewCount).toString()}",
                style: subtitleStyle),
          ],
        )),
      ),
      onTap: () {
        navigation.pushNamed("${ViewModPage.route}${widget.mod.uuid}");
      },
    );
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
            child: SEOText(localizations.addModTitle),
            onPressed: () => AccountHandler.checkHasAccount(
                () => navigation.pushNamed(AddModPage.route))),
        const RPMTWVerticalDivider(),
        OutlinedButton(
            child: const SEOText("查看編輯紀錄"),
            onPressed: () => navigation.pushNamed(ChangelogPage.route)),
      ],
    );
  }
}
