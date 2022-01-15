import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:picture_verification_code/picture_verification_code.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/pages/home_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/form_field.dart';
import 'package:rpmtw_wiki/widget/link_text.dart';
import 'package:rpmtw_wiki/widget/ok_close.dart';
import 'package:rpmtw_wiki/widget/row_scroll_view.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_text_field.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';

class AddModPage extends StatefulWidget {
  static const String route = '/mod/add';
  const AddModPage({Key? key}) : super(key: key);

  @override
  _AddModPageState createState() => _AddModPageState();
}

class _AddModPageState extends State<AddModPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool loading = true;
  bool isForge = false;
  bool isFabric = false;

  List<MinecraftVersion> allMinecraftVersions = [];

  String? name;
  String? id;
  String? description;
  List<MinecraftVersion> supportVersions = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      MinecraftVersionManifest manifest = await RPMTWApiClient
          .lastInstance.minecraftResource
          .getMinecraftVersionManifest();
      allMinecraftVersions = manifest.versions
          .where((v) => v.type == MinecraftVersionType.release) //僅顯示正式發行版
          .toList();
      await Future.delayed(
          const Duration(milliseconds: 300)); // 故意小延遲，避免畫面看起來卡頓
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TitleBar(
          title: localizations.addModTitle,
          onBackPressed: () => navigation.pushNamed(HomePage.route),
          bottom: TabBar(
            isScrollable: Utility.isWebMobile,
            tabs: [
              Tab(
                text: localizations.addModBaseTitle,
              ),
              const Tab(
                text: "詳細資訊",
              )
            ],
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: localizations.addModSubmitTooltip,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();
                        if (supportVersions.isEmpty) {
                          Flushbar(
                            title: localizations.guiError,
                            message: localizations.addModSupportedVersionNull,
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ).show(context);
                          return;
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => _SubmitModDialog(
                                    name: name!,
                                    supportVersions: supportVersions,
                                  ));
                        }
                      },
                      icon: const Icon(Icons.send),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                      label: Text(localizations.guiSubmit)),
                )
              ],
            )
          ],
        ),
        body: TabBarView(
          children: [_buildBaseInfo(), const Text("test")],
        ),
      ),
    );
  }

  Widget _buildBaseInfo() {
    return BasePage(
      loading: loading,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            RPMTWFormField(
              fieldName: localizations.addModOriginalNameField,
              hintText: localizations.addModOriginalNameHintText,
              onSaved: (value) => name = value,
              validator: (value) {
                if (value!.isEmpty) {
                  return "模組名稱不得為空";
                }
                return null;
              },
            ),
            RPMTWFormField(
              fieldName: localizations.addModTranslatedNameField,
              hintText: localizations.addModTranslatedNameHintText,
              helperText: localizations.addModTranslatedNameTooltip,
            ),
            RPMTWFormField(
              fieldName: localizations.addModIdField,
              hintText: localizations.addModIdHintText,
              helperText: localizations.addModIdTooltip,
              onSaved: (value) => id = value,
            ),
            RPMTWFormField(
              fieldName: localizations.addModDescriptionField,
              helperText: localizations.addModDescriptionTooltip,
              lockLine: false,
              onSaved: (value) {
                description = value;
              },
            ),
            _buildLoaderCheckbox(),
            _VersionChoice(
              allVersions: allMinecraftVersions,
              onChanged: (versions) => supportVersions = versions,
            ),
            const SEOText("模組封面："),
          ],
        ),
      ),
    );
  }

  Column _buildLoaderCheckbox() {
    return Column(
      children: [
        SEOText(localizations.addModLoader),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: kSplitWidth),
            Checkbox(
                value: isForge,
                onChanged: (value) {
                  setState(() {
                    isForge = value!;
                  });
                }),
            const SEOText("Forge"),
            Checkbox(
                value: isFabric,
                onChanged: (value) {
                  setState(() {
                    isFabric = value!;
                  });
                }),
            const SEOText("Fabric"),
          ],
        ),
      ],
    );
  }
}

class _SubmitModDialog extends StatefulWidget {
  final String name;
  final List<MinecraftVersion> supportVersions;
  final String? id;
  final String? description;
  final List<RelationMod>? relationMods;
  final ModIntegrationPlatform? integration;
  final List<ModSide>? side;

  const _SubmitModDialog({
    Key? key,
    required this.name,
    required this.supportVersions,
    this.id,
    this.description,
    this.relationMods,
    this.integration,
    this.side,
  }) : super(key: key);

  @override
  State<_SubmitModDialog> createState() => _SubmitModDialogState();
}

class _SubmitModDialogState extends State<_SubmitModDialog> {
  String inputCode = "";
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
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
        RPMTextField(
          hintText: localizations.addModVerificationCodeInput,
          onChanged: (value) => inputCode = value,
        ),
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
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => _buildCreatingDialog());
            } else {
              Flushbar flushbar = Flushbar(
                title: localizations.guiError,
                message: localizations.addModVerificationCodeWrong,
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red,
              );
              flushbar.show(context);
            }
          },
        ),
      ],
    );
  }

  Future<MinecraftMod> _creating() async {
    RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
    apiClient.setGlobalToken(AccountHandler.token!);
    return apiClient.minecraftResource.createMinecraftMod(
      name: widget.name,
      supportVersions: widget.supportVersions,
      id: widget.id,
      description: widget.description,
      relationMods: widget.relationMods,
      integration: widget.integration,
      side: widget.side,
    );
  }

  FutureBuilder<MinecraftMod> _buildCreatingDialog() {
    return FutureBuilder<MinecraftMod>(
        future: _creating(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return AlertDialog(
              title: Text(localizations.guiSuccess),
              content: Column(mainAxisSize: MainAxisSize.min, children: const [
                Text("模組建立成功！"),
                LinkText(link: "https://", text: "瀏覽此模組", seo: false),
              ]),
              actions: [
                OkClose(
                  onOk: () => navigation.pushNamed(HomePage.route),
                )
              ],
            );
          } else {
            return AlertDialog(
              title: const Text("請稍後，正在建立模組中..."),
              content: Column(mainAxisSize: MainAxisSize.min, children: const [
                CircularProgressIndicator(),
              ]),
            );
          }
        }));
  }
}

class _VersionChoice extends StatefulWidget {
  final List<MinecraftVersion> allVersions;
  final void Function(List<MinecraftVersion>) onChanged;
  const _VersionChoice(
      {Key? key, required this.allVersions, required this.onChanged})
      : super(key: key);

  @override
  State<_VersionChoice> createState() => _VersionChoiceState();
}

class _VersionChoiceState extends State<_VersionChoice> {
  late List<MinecraftVersion> versions;

  @override
  void initState() {
    versions = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: kSplitWidth),
        SEOText(localizations.addModSupportedVersionField),
        RowScrollView(
          child: Column(
            children: [
              ChipsChoice<MinecraftVersion>.multiple(
                value: versions,
                onChanged: (value) {
                  setState(() {
                    versions = value;
                  });
                  widget.onChanged.call(value);
                },
                choiceItems:
                    C2Choice.listFrom<MinecraftVersion, MinecraftVersion>(
                  source: widget.allVersions,
                  value: (i, v) => v,
                  label: (i, v) => v.id,
                ),
                choiceStyle: const C2ChoiceStyle(color: Colors.green),
              ),
              ...?kIsWebDesktop
                  ? [
                      const SizedBox(height: 10) // 放置可滾動 widget 中滾軸的位置
                    ]
                  : null,
            ],
          ),
        ),
      ],
    );
  }
}
