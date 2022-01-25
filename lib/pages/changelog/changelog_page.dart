import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:rpmtw_wiki/widget/seo_selectable_text.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';

class ChangelogPage extends StatefulWidget {
  static const String route = '/changelog';
  const ChangelogPage({Key? key}) : super(key: key);

  @override
  State<ChangelogPage> createState() => _ChangelogPageState();
}

class _ChangelogPageState extends State<ChangelogPage> {
  RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;

  Future<List<WikiChangeLog>> load() async {
    List<WikiChangeLog> changelogs =
        await apiClient.minecraftResource.filterChangelogs();
    return changelogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(
        title: "編輯紀錄",
        onBackPressed: () => navigation.pop(),
      ),
      body: BasePage(
          child: FutureBuilder<List<WikiChangeLog>>(
        future: load(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<WikiChangeLog> changelogs = snapshot.data!;
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
                          WikiChangeLog changelog = changelogs[index];

                          return FutureBuilder<User>(
                              future: changelog.user,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  User user = snapshot.data!;
                                  WikiChangeLogType type = changelog.type;

                                  Widget _buildChangelogType() {
                                    if (type == WikiChangeLogType.addedMod) {
                                      return const Tooltip(
                                          child: Icon(Icons.add),
                                          message: "建立模組");
                                    } else if (type ==
                                        WikiChangeLogType.editedMod) {
                                      return const Tooltip(
                                          child: Icon(Icons.edit),
                                          message: "編輯模組");
                                    } else if (type ==
                                        WikiChangeLogType.removedMod) {
                                      return const Tooltip(
                                          child: Icon(Icons.delete),
                                          message: "移除模組");
                                    } else {
                                      return const Icon(Icons.error);
                                    }
                                  }

                                  Widget _buildUserImage() {
                                    return Tooltip(
                                        child: user.avatar(),
                                        message: user.username);
                                  }

                                  return ListTile(
                                    leading: _buildUserImage(),
                                    title: SEOSelectableText(
                                        changelog.changelog ?? ""),
                                    subtitle: SEOSelectableText(
                                        Utility.dateFormat(changelog.time)),
                                    trailing: _buildChangelogType(),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
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
