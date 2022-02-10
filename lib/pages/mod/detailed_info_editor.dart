import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/extension.dart';
import 'package:rpmtw_wiki/utilities/rpmtw_theme.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/form_field.dart';
import 'package:rpmtw_wiki/widget/mod_select_menu.dart';
import 'package:rpmtw_wiki/widget/relation_mod_view.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class DetailedInfoEditor extends StatefulWidget {
  final List<RelationMod>? relationMods;
  final ModIntegrationPlatform integration;
  final List<ModSide> side;

  const DetailedInfoEditor({
    Key? key,
    this.relationMods,
    this.integration = const ModIntegrationPlatform(),
    this.side = const [],
  }) : super(key: key);

  factory DetailedInfoEditor.fromMinecraftMod(MinecraftMod mod, {Key? key}) {
    return DetailedInfoEditor(
        relationMods: mod.relationMods,
        integration: mod.integration,
        side: mod.side,
        key: key);
  }

  @override
  State<DetailedInfoEditor> createState() => DetailedInfoEditorState();
}

class DetailedInfoEditorState extends State<DetailedInfoEditor> {
  late List<RelationMod>? relationMods;
  late ModIntegrationPlatform integration;
  late List<ModSide> side;

  @override
  void initState() {
    relationMods = widget.relationMods != null
        ? List<RelationMod>.from(widget.relationMods!)
        : null;

    integration = ModIntegrationPlatform.fromMap(widget.integration.toMap());
    side = List.from(widget.side);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(builder: (context) {
      return Column(
        children: [
          SizedBox(height: kSplitHight),
          SEOText(localizations.addModDetailedIntegration,
              style: RPMTWTheme.titleTextStyle),
          RPMTWFormField(
            fieldName: localizations.addModDetailedCurseForgeField,
            hintText: localizations.addModDetailedCurseForgeHint,
            defaultValue: integration.curseForgeID,
            onSaved: (value) {
              integration = integration.copyWith(
                curseForgeID: value,
              );
            },
          ),
          RPMTWFormField(
            fieldName: localizations.addModDetailedModrinthField,
            hintText: localizations.addModDetailedModrinthHint,
            defaultValue: integration.modrinthID,
            onSaved: (value) {
              integration = integration.copyWith(
                modrinthID: value,
              );
            },
          ),
          SizedBox(height: kSplitHight),
          SEOText(localizations.addModDetailedEnvironment,
              style: RPMTWTheme.titleTextStyle),
          _ModSideChoice(
              environment: ModSideEnvironment.client,
              requireType: parseDefaultRequireType(ModSideEnvironment.client),
              onSaved: (value) => _saveSideData(
                  value: value, environment: ModSideEnvironment.client)),
          _ModSideChoice(
              environment: ModSideEnvironment.server,
              requireType: parseDefaultRequireType(ModSideEnvironment.server),
              onSaved: (value) => _saveSideData(
                  value: value, environment: ModSideEnvironment.server)),
          SizedBox(height: kSplitHight),
          SEOText(localizations.addModDetailedRelation,
              style: RPMTWTheme.titleTextStyle),
          SizedBox(height: kSplitHight),
          _RelationMod(
            defaultValue: relationMods,
            onSaved: (value) => relationMods = value,
          ),
          SizedBox(height: kSplitHight),
        ],
      );
    });
  }

  ModRequireType? parseDefaultRequireType(ModSideEnvironment environment) {
    try {
      final ModSide _side = side.firstWhere(
        (side) => side.environment == environment,
      );
      return _side.requireType;
    } catch (e) {
      return null;
    }
  }

  void _saveSideData(
      {required ModSide value, required ModSideEnvironment environment}) {
    if (side.any((e) => e.environment == environment)) {
      /// 如果已經選擇過相同執行環境則刪除
      side.removeWhere((e) => e.environment == environment);
    }

    side.add(value);
  }
}

class _RelationMod extends StatefulWidget {
  final List<RelationMod>? defaultValue;
  final void Function(List<RelationMod>?) onSaved;
  const _RelationMod({Key? key, required this.onSaved, this.defaultValue})
      : super(key: key);

  @override
  _RelationModState createState() => _RelationModState();
}

class _RelationModState extends State<_RelationMod> {
  List<RelationMod>? relationMods;

  @override
  void initState() {
    relationMods = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton.icon(
            onPressed: () {
              ModSelectMenu menu = ModSelectMenu(
                  title: localizations.addModDetailedRelationMenu,
                  onSelected: (mod) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return _RelationModInfoDialog(
                              mod: mod,
                              onSaved: (relationMod) {
                                relationMods ??= [];
                                relationMods!.add(relationMod);
                                widget.onSaved(relationMods);
                                setState(() {});
                              });
                        });
                  });
              menu.show(context);
            },
            icon: const FaIcon(FontAwesomeIcons.staylinked),
            label: SEOText(localizations.addModDetailedRelationAdd)),
        SizedBox(height: kSplitHight),
        if (relationMods != null)
          RelationModView(
            relationMods: relationMods!,
            onRelationModChanged: (value) => relationMods = value,
            isEditable: true,
          )
      ],
    );
  }
}

class _RelationModInfoDialog extends StatefulWidget {
  final MinecraftMod mod;
  final ValueChanged<RelationMod>? onSaved;
  const _RelationModInfoDialog({Key? key, required this.mod, this.onSaved})
      : super(key: key);

  @override
  State<_RelationModInfoDialog> createState() => _RelationModInfoDialogState();
}

class _RelationModInfoDialogState extends State<_RelationModInfoDialog> {
  String? condition;
  RelationType type = RelationType.dependency;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return AlertDialog(
        title: Text(localizations.addModDetailedRelationInfo),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.mod.name),
          RPMTWFormField(
            fieldName: localizations.addModDetailedRelationCondition,
            helperText: localizations.addModDetailedRelationHelper,
            seo: false,
            onChanged: (value) {
              condition = value;
            },
          ),
          SizedBox(height: kSplitHight),
          Text(localizations.addModDetailedRelationType,
              style: RPMTWTheme.titleTextStyle),
          DropdownButton<RelationType>(
              value: type,
              items: RelationType.values
                  .map((e) => DropdownMenuItem<RelationType>(
                      value: e, child: Text(e.i18n)))
                  .toList(),
              onChanged: (_type) {
                setState(() {
                  type = _type!;
                });
              })
        ]),
        actions: [
          TextButton(
            child: Text(localizations.guiCancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(localizations.guiSubmit),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onSaved?.call(RelationMod(
                modUUID: widget.mod.uuid,
                type: type,
                condition: condition,
              ));
            },
          ),
        ],
      );
    });
  }
}

class _ModSideChoice extends StatefulWidget {
  final ModSideEnvironment environment;
  final void Function(ModSide) onSaved;
  final ModRequireType? requireType;

  const _ModSideChoice(
      {Key? key,
      required this.environment,
      required this.onSaved,
      this.requireType})
      : super(key: key);

  @override
  State<_ModSideChoice> createState() => _ModSideChoiceState();
}

class _ModSideChoiceState extends State<_ModSideChoice> {
  bool isRequired = false;
  bool isOptional = false;
  bool isUnsupported = false;

  @override
  void initState() {
    if (widget.requireType != null) {
      switch (widget.requireType!) {
        case ModRequireType.required:
          isRequired = true;
          break;
        case ModRequireType.optional:
          isOptional = true;
          break;
        case ModRequireType.unsupported:
          isUnsupported = true;
          break;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SEOText(
          toI18nEnvironmentString(widget.environment),
          style: const TextStyle(fontSize: 18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SEOText(localizations.modSideRequire),
                Checkbox(
                    value: isRequired,
                    onChanged: (value) => onChanged(
                        value: value!, requireType: ModRequireType.required)),
              ],
            ),
            Row(
              children: [
                SEOText(localizations.modSideOptional),
                Checkbox(
                    value: isOptional,
                    onChanged: (value) => onChanged(
                        value: value!, requireType: ModRequireType.optional)),
              ],
            ),
            Row(
              children: [
                SEOText(localizations.modSideUnsupported),
                Checkbox(
                    value: isUnsupported,
                    onChanged: (value) => onChanged(
                        value: value!,
                        requireType: ModRequireType.unsupported)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void onChanged({required bool value, required ModRequireType requireType}) {
    switch (requireType) {
      case ModRequireType.required:
        isRequired = value;
        isOptional = false;
        isUnsupported = false;
        break;
      case ModRequireType.optional:
        isOptional = value;
        isRequired = false;
        isUnsupported = false;
        break;
      case ModRequireType.unsupported:
        isUnsupported = value;
        isRequired = false;
        isOptional = false;
        break;
    }
    widget.onSaved(ModSide(
      environment: widget.environment,
      requireType: requireType,
    ));
    setState(() {});
  }

  String toI18nEnvironmentString(ModSideEnvironment environment) {
    switch (environment) {
      case ModSideEnvironment.client:
        return localizations.modSideClient;
      case ModSideEnvironment.server:
        return localizations.modSideServer;
    }
  }
}
