import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:picture_verification_code/picture_verification_code.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/home_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/link_text.dart';
import 'package:rpmtw_wiki/widget/ok_close.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_text_field.dart';

class SubmitModDialog extends StatefulWidget {
  final String name;
  final List<String> supportVersions;
  final String? id;
  final String? description;
  final List<RelationMod>? relationMods;
  final ModIntegrationPlatform? integration;
  final List<ModSide>? side;
  final List<ModLoader>? loaders;
  final Uint8List? imageBytes;
  final String? introduction;
  final String? translatedName;
  final SubmitModDialogType submitType;
  final MinecraftMod? editMod;

  const SubmitModDialog({
    Key? key,
    required this.name,
    required this.supportVersions,
    required this.submitType,
    this.id,
    this.description,
    this.relationMods,
    this.integration,
    this.side,
    this.loaders,
    this.imageBytes,
    this.introduction,
    this.translatedName,
    this.editMod,
  }) : super(key: key);

  @override
  State<SubmitModDialog> createState() => _SubmitModDialogState();
}

class _SubmitModDialogState extends State<SubmitModDialog> {
  String inputCode = "";
  String? changelog;
  late int code;

  @override
  void initState() {
    code = Random.secure().nextInt(999999);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(localizations.addModSubmit),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(localizations.addModVerificationCode),
        SizedBox(height: kSplitHight),
        Tooltip(
          message: localizations.addModVerificationCodeRegenerate,
          child: InkResponse(
            child: PictureVerificationCode(code: code.toString()),
            onTap: () {
              setState(() {
                code = Random.secure().nextInt(999999);
              });
            },
          ),
        ),
        SizedBox(height: kSplitHight),
        RPMTextField(
          hintText: localizations.addModVerificationCodeInput,
          onChanged: (value) => inputCode = value,
        ),
        ...widget.submitType == SubmitModDialogType.edit
            ? [
                SizedBox(height: kSplitHight),
                Text(localizations.editModChangelog),
                SizedBox(height: kSplitHight),
                RPMTextField(
                  hintText: localizations.editModChangelogHint,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      changelog = null;
                    } else {
                      changelog = value;
                    }
                  },
                ),
              ]
            : [],
      ]),
      actions: [
        TextButton(
          child: Text(localizations.guiCancel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(localizations.guiConfirm),
          onPressed: () {
            if (int.tryParse(inputCode) == code) {
              if (widget.submitType == SubmitModDialogType.edit &&
                  changelog == null) {
                Utility.showErrorFlushbar(
                    context, localizations.editModChangelogNull);
                return;
              }
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => _buildHandlingDialog());
            } else {
              Utility.showErrorFlushbar(
                  context, localizations.addModVerificationCodeWrong);
            }
          },
        ),
      ],
    );
  }

  Future<MinecraftMod> _handler() async {
    RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
    apiClient.setGlobalToken(AccountHandler.token!);

    Storage? imageStorage;
    if (widget.imageBytes != null) {
      /// 上傳模組封面圖
      imageStorage = await apiClient.storageResource
          .createStorageByBytes(widget.imageBytes!);
    }

    late MinecraftMod mod;

    if (widget.submitType == SubmitModDialogType.create) {
      mod = await apiClient.minecraftResource.createMinecraftMod(
          name: widget.name,
          supportVersions: widget.supportVersions,
          id: widget.id,
          description: widget.description,
          relationMods: widget.relationMods,
          integration: widget.integration,
          side: widget.side,
          loader: widget.loaders,
          translatedName: widget.translatedName,
          introduction: widget.introduction,
          imageStorageUUID: imageStorage?.uuid);
    } else if (widget.submitType == SubmitModDialogType.edit) {
      assert(widget.editMod != null, "editModUUID is null");

      MinecraftMod _mod = widget.editMod!;

      mod = await apiClient.minecraftResource.editMinecraftMod(
        uuid: _mod.uuid,
        changelog: changelog,
        name: _mod.name != widget.name ? widget.name : null,
        supportVersions: _mod.supportVersions.map((e) => e.id).toList() !=
                widget.supportVersions
            ? widget.supportVersions
            : null,
        id: _mod.id != widget.id ? widget.id : null,
        description:
            _mod.description != widget.description ? widget.description : null,
        relationMods: _mod.relationMods != widget.relationMods
            ? widget.relationMods
            : null,
        integration:
            _mod.integration != widget.integration ? widget.integration : null,
        side: _mod.side != widget.side ? widget.side : null,
        loader: _mod.loader != widget.loaders ? widget.loaders : null,
        translatedName: _mod.translatedName != widget.translatedName
            ? widget.translatedName
            : null,
        introduction: _mod.introduction != widget.introduction
            ? widget.introduction
            : null,
        imageStorageUUID: imageStorage?.uuid,
      );
    }

    return mod;
  }

  FutureBuilder<MinecraftMod> _buildHandlingDialog() {
    bool isCreate = widget.submitType == SubmitModDialogType.create;
    return FutureBuilder<MinecraftMod>(
        future: _handler(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            MinecraftMod mod = snapshot.data!;
            return AlertDialog(
              title: Text(localizations.guiSuccess),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(isCreate
                    ? localizations.addModCreateSuccess
                    : localizations.editModSuccess),
                LinkText(
                    link: "$rpmtwWikiUrl/mod/view/${mod.uuid}",
                    text: localizations.addModCreateBrowse,
                    seo: false),
              ]),
              actions: [
                OkClose(
                  onOk: () => navigation.pushNamed(HomePage.route),
                  seo: false,
                )
              ],
            );
          } else {
            return AlertDialog(
              title: Text(localizations.submitModProcessing),
              content: Column(mainAxisSize: MainAxisSize.min, children: const [
                CircularProgressIndicator(),
              ]),
            );
          }
        }));
  }
}

enum SubmitModDialogType { create, edit }
