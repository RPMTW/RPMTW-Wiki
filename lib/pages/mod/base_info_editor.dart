import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/pages/mod/minecraft_version_choice.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/rpmtw_theme.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/form_field.dart';
import 'package:rpmtw_wiki/widget/mod_select_menu.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class BaseInfoEditor extends StatefulWidget {
  final bool isForge;
  final bool isFabric;

  final String? name;
  final String? translatedName;
  final String? id;
  final String? description;
  final List<String> supportVersions;
  final String? imageStorageUUID;

  const BaseInfoEditor({
    Key? key,
    this.isForge = false,
    this.isFabric = false,
    this.name,
    this.translatedName,
    this.id,
    this.description,
    this.supportVersions = const [],
    this.imageStorageUUID,
  }) : super(key: key);

  factory BaseInfoEditor.fromMinecraftMod(MinecraftMod mod, {Key? key}) {
    return BaseInfoEditor(
      isForge: mod.loader?.any((e) => e == ModLoader.forge) ?? false,
      isFabric: mod.loader?.any((e) => e == ModLoader.fabric) ?? false,
      name: mod.name,
      translatedName: mod.translatedName,
      id: mod.id,
      description: mod.description,
      supportVersions: mod.supportVersions.map((e) => e.id).toList(),
      imageStorageUUID: mod.imageStorageUUID,
      key: key,
    );
  }

  @override
  BaseInfoEditorState createState() => BaseInfoEditorState();
}

class BaseInfoEditorState extends State<BaseInfoEditor> {
  bool _loading = true;
  List<MinecraftVersion> _allMinecraftVersions = [];

  late bool isForge;
  late bool isFabric;

  late String? name;
  late String? translatedName;
  late String? id;
  late String? description;
  late List<String> supportVersions = [];
  Uint8List? imageBytes;
  String? imageStorageUUID;

  @override
  void initState() {
    isForge = widget.isForge;
    isFabric = widget.isFabric;
    name = widget.name;
    translatedName = widget.translatedName;
    id = widget.id;
    description = widget.description;
    supportVersions = widget.supportVersions;
    imageStorageUUID = widget.imageStorageUUID;

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      MinecraftVersionManifest manifest = await RPMTWApiClient
          .lastInstance.minecraftResource
          .getMinecraftVersionManifest();
      _allMinecraftVersions = manifest.versions
          .where((v) => v.type == MinecraftVersionType.release) //僅顯示正式發行版
          .toList();
      await Future.delayed(
          const Duration(milliseconds: 300)); // 故意小延遲，避免畫面看起來卡頓
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      loading: _loading,
      child: Column(
        children: [
          RPMTWFormField(
            fieldName: localizations.addModOriginalNameField,
            hintText: localizations.addModOriginalNameHintText,
            onSaved: (value) => name = value,
            defaultValue: name,
            validator: (value) {
              if (value!.isEmpty) {
                return localizations.addModOriginalNameValidator;
              }
              return null;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kSplitHight),
                Row(
                  children: [
                    SizedBox(width: kSplitWidth),
                    OutlinedButton.icon(
                        onPressed: () {
                          ModSelectMenu menu = ModSelectMenu(
                              title: localizations.addModBaseCheckExists,
                              onSelected: (mod) {
                                // TODO: 開啟模組的詳細資訊
                              });

                          menu.show(context);
                        },
                        icon: const Icon(Icons.rule),
                        label: Text(localizations.addModBaseCheckExists)),
                  ],
                ),
                SizedBox(height: kSplitHight),
                const RPMTWDivider(),
              ],
            ),
          ),
          RPMTWFormField(
            fieldName: localizations.addModTranslatedNameField,
            hintText: localizations.addModTranslatedNameHintText,
            helperText: localizations.addModTranslatedNameTooltip,
            defaultValue: translatedName,
            onSaved: (value) {
              if (value.isEmpty) {
                translatedName = null;
              } else {
                translatedName = value;
              }
            },
          ),
          RPMTWFormField(
            fieldName: localizations.addModIdField,
            hintText: localizations.addModIdHintText,
            helperText: localizations.addModIdTooltip,
            defaultValue: id,
            onSaved: (value) {
              if (value.isEmpty) {
                id = null;
              } else {
                id = value;
              }
            },
          ),
          RPMTWFormField(
            fieldName: localizations.addModDescriptionField,
            helperText: localizations.addModDescriptionTooltip,
            lockLine: false,
            defaultValue: description,
            onSaved: (value) {
              if (value.isEmpty) {
                description = null;
              } else {
                description = value;
              }
            },
          ),
          _buildLoaderCheckbox(),
          MinecraftVersionChoice(
            allVersions: _allMinecraftVersions,
            defaultValue: supportVersions,
            onChanged: (versions) => supportVersions = versions,
          ),
          SizedBox(height: kSplitHight),
          _buildModImage(),
        ],
      ),
    );
  }

  Column _buildModImage() {
    return Column(
      children: [
        SEOText(localizations.addModBaseImageTitle,
            style: RPMTWTheme.titleTextStyle),
        SizedBox(height: kSplitHight),
        ElevatedButton.icon(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );

              if (result != null) {
                setState(() {
                  imageBytes = result.files.first.bytes;
                });
              }
            },
            icon: const Icon(Icons.file_upload),
            label: Text(localizations.addModBaseImageUpload)),
        SizedBox(height: kSplitHight),
        Builder(builder: (context) {
          if (imageBytes != null || imageStorageUUID != null) {
            return Column(
              children: [
                Stack(
                  children: [
                    imageStorageUUID != null
                        ? Image.network(
                            Storage.getDownloadUrl(imageStorageUUID!))
                        : Image.memory(imageBytes!, width: 350, height: 350),
                    Positioned(
                        right: 1,
                        top: 1,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                /// 如果沒有來自伺服器的圖片則清除本機的 bytes
                                if (imageStorageUUID == null) {
                                  imageBytes = null;
                                } else {
                                  imageStorageUUID = null;
                                }
                              });
                            },
                            tooltip: localizations.addModBaseImageRemove,
                            icon: const Icon(Icons.close))),
                  ],
                ),
                SizedBox(height: kSplitHight),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        })
      ],
    );
  }

  Widget _buildLoaderCheckbox() {
    return StatefulBuilder(builder: (context, _setState) {
      return Column(
        children: [
          SEOText(localizations.addModLoader, style: RPMTWTheme.titleTextStyle),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: kSplitWidth),
              Checkbox(
                  value: isForge,
                  onChanged: (value) {
                    _setState(() {
                      isForge = value!;
                    });
                  }),
              const SEOText("Forge"),
              Checkbox(
                  value: isFabric,
                  onChanged: (value) {
                    _setState(() {
                      isFabric = value!;
                    });
                  }),
              const SEOText("Fabric"),
            ],
          ),
        ],
      );
    });
  }
}
