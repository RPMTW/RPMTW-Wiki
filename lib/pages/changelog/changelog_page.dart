import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/row_scroll_view.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:rpmtw_wiki/widget/seo_selectable_text.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';

class ChangelogPage extends StatefulWidget {
  static const String route = '/changelog';
  final String? dataUUID;
  const ChangelogPage({Key? key, this.dataUUID}) : super(key: key);

  @override
  State<ChangelogPage> createState() => _ChangelogPageState();
}

class _ChangelogPageState extends State<ChangelogPage> {
  RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;

  Future<List<WikiChangelog>> load() async {
    List<WikiChangelog> changelogs = await apiClient.minecraftResource
        .filterChangelogs(dataUUID: widget.dataUUID);
    return changelogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(
        title: localizations.changelogTitle,
        onBackPressed: () => navigation.pop(),
      ),
      body: BasePage(
          child: FutureBuilder<List<WikiChangelog>>(
        future: load(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<WikiChangelog> changelogs = snapshot.data!;
            return SizedBox(
              height: Utility.getSize(context).height * 0.8,
              width: Utility.getSize(context).width,
              child: Column(
                children: [
                  SizedBox(height: kSplitHight),
                  Expanded(
                    child: ListView.builder(
                        itemCount: changelogs.length,
                        itemBuilder: (context, index) {
                          WikiChangelog changelog = changelogs[index];

                          return FutureBuilder<User>(
                              future: changelog.user,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  User user = snapshot.data!;
                                  WikiChangelogType type = changelog.type;

                                  Widget _buildChangelogType() {
                                    if (type == WikiChangelogType.addedMod) {
                                      return Tooltip(
                                          child: const Icon(Icons.add),
                                          message: localizations
                                              .changelogTypeAddedMod);
                                    } else if (type ==
                                        WikiChangelogType.editedMod) {
                                      return Tooltip(
                                          child: const Icon(Icons.edit),
                                          message: localizations
                                              .changelogTypeEditedMod);
                                    } else if (type ==
                                        WikiChangelogType.removedMod) {
                                      return Tooltip(
                                          child: const Icon(Icons.delete),
                                          message: localizations
                                              .changelogTypeRemovedMod);
                                    } else {
                                      return const Icon(Icons.error);
                                    }
                                  }

                                  Widget _buildDataView() {
                                    if (type == WikiChangelogType.addedMod ||
                                        type == WikiChangelogType.editedMod ||
                                        type == WikiChangelogType.removedMod) {
                                      MinecraftMod mod = MinecraftMod.fromMap(
                                          changelog.changedData);
                                      String name = mod.name;

                                      if (mod.translatedName != null) {
                                        name += " (${mod.translatedName!})";
                                      }
                                      if (type == WikiChangelogType.editedMod) {
                                        return SEOSelectableText(localizations
                                            .changelogEditedData(name));
                                      } else if (type ==
                                          WikiChangelogType.addedMod) {
                                        return SEOSelectableText(localizations
                                            .changelogCreatedData(name));
                                      } else {
                                        return SEOSelectableText(localizations
                                            .changelogRemovedData(name));
                                      }
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }

                                  Widget _buildDataCompare() {
                                    if (type == WikiChangelogType.addedMod ||
                                        type == WikiChangelogType.editedMod ||
                                        type == WikiChangelogType.removedMod) {
                                      String data1 =
                                          changelog.changedData.toString();

                                      String? data2 =
                                          changelog.unchangedData?.toString();

                                      if (data2 == null) {
                                        return SEOSelectableText(
                                            "+${data1.length}");
                                      }

                                      DiffMatchPatch dmp = DiffMatchPatch();
                                      List<Diff> diffs = dmp.diff(data1, data2);
                                      int result = 0;

                                      for (Diff diff in diffs) {
                                        if (diff.operation == DIFF_INSERT) {
                                          result += diff.text.length;
                                        } else if (diff.operation ==
                                            DIFF_DELETE) {
                                          result -= diff.text.length;
                                        }
                                      }

                                      String str;

                                      if (result == 0) {
                                        str = localizations.changelogNone;
                                      } else if (result > 0) {
                                        str = "+$result";
                                      } else {
                                        str = "-$result";
                                      }

                                      return SEOSelectableText(str);
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }

                                  Widget _buildUserImage() {
                                    return Tooltip(
                                        child: user.avatar(),
                                        message: user.username);
                                  }

                                  return ListTile(
                                    leading: _buildUserImage(),
                                    title: SizedBox(
                                      height: 25,
                                      child: RowScrollView(
                                        center: false,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SEOSelectableText(
                                                changelog.changelog ?? ""),
                                            const RPMTWVerticalDivider(),
                                            _buildDataView(),
                                            const RPMTWVerticalDivider(),
                                            _buildDataCompare()
                                          ],
                                        ),
                                      ),
                                    ),
                                    subtitle: SEOSelectableText(
                                        Utility.dateFormat(changelog.time)),
                                    trailing: _buildChangelogType(),
                                  );
                                } else {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: kSplitHight),
                                      const CircularProgressIndicator(),
                                      SizedBox(height: kSplitHight),
                                    ],
                                  );
                                }
                              });
                        }),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )),
    );
  }
}
