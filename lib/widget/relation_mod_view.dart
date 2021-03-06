import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/extension.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class RelationModView extends StatefulWidget {
  final List<RelationMod> relationMods;
  final ValueChanged<List<RelationMod>>? onRelationModChanged;
  final bool isEditable;

  const RelationModView(
      {Key? key,
      required this.relationMods,
      this.onRelationModChanged,
      this.isEditable = false})
      : super(key: key);

  @override
  _RelationModViewState createState() => _RelationModViewState();
}

class _RelationModViewState extends State<RelationModView> {
  late List<RelationMod> relationMods;

  @override
  void initState() {
    relationMods = widget.relationMods;
    super.initState();
  }

  Future<MinecraftMod> load(String modUUID) async {
    RPMTWApiClient apiClient = RPMTWApiClient.instance;
    return await apiClient.minecraftResource.getMinecraftMod(modUUID);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: relationMods
          .map((relationMod) => FutureBuilder<MinecraftMod>(
              future: load(relationMod.modUUID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  MinecraftMod mod = snapshot.data!;

                  return ExpansionTile(
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.expand_more),
                        ...widget.isEditable
                            ? [
                                SizedBox(width: kSplitWidth),
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.trash),
                                  tooltip: localizations.guiDelete,
                                  onPressed: () {
                                    relationMods.remove(relationMod);
                                    widget.onRelationModChanged
                                        ?.call(relationMods);
                                    setState(() {});
                                  },
                                )
                              ]
                            : []
                      ],
                    ),
                    leading: mod.imageWidget(width: 50, height: 50) ??
                        const Icon(Icons.image),
                    title: SEOText(mod.name, textAlign: TextAlign.center),
                    subtitle: SEOText(relationMod.type.i18n,
                        textAlign: TextAlign.center),
                    children: [
                      SEOText(relationMod.condition ??
                          localizations.addModDetailedRelationConditionCommon),
                      if (mod.description != null) SEOText(mod.description!),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }))
          .toList(),
    );
  }
}
