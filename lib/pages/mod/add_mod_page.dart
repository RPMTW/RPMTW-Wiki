import 'dart:html';
import 'dart:math';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:picture_verification_code/picture_verification_code.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/pages/home_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/extension.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/editor_tool_bar.dart';
import 'package:rpmtw_wiki/widget/form_field.dart';
import 'package:rpmtw_wiki/widget/link_text.dart';
import 'package:rpmtw_wiki/widget/mod_select_menu.dart';
import 'package:rpmtw_wiki/widget/ok_close.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_text_field.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';
import 'package:split_view/split_view.dart';
import 'package:undo/undo.dart';

final GlobalKey<FormState> _formKey = GlobalKey();
const TextStyle _titleTextStyle = TextStyle(fontSize: 20, color: Colors.blue);

class AddModPage extends StatefulWidget {
  static const String route = '/mod/add';
  const AddModPage({Key? key}) : super(key: key);

  @override
  _AddModPageState createState() => _AddModPageState();
}

class _AddModPageState extends State<AddModPage> {
  final GlobalKey<_BaseInfoState> _baseInfoKey = GlobalKey();
  final GlobalKey<_DetailedInfoState> _detailedInfoKey = GlobalKey();

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final _BaseInfoState baseInfoState = _baseInfoKey.currentState!;
    final _DetailedInfoState? detailedInfoState = _detailedInfoKey.currentState;

    final List<String> supportVersions = baseInfoState.supportVersions;
    List<ModLoader> loaders = [];
    if (baseInfoState.isFabric) {
      loaders.add(ModLoader.fabric);
    }
    if (baseInfoState.isForge) {
      loaders.add(ModLoader.forge);
    }

    showDialog(
        context: context,
        builder: (context) => _SubmitModDialog(
              name: baseInfoState.name!,
              supportVersions: supportVersions,
              id: baseInfoState.id,
              description: baseInfoState.description,
              loaders: loaders,
              relationMods: detailedInfoState?.relationMods,
              integration: detailedInfoState?.integration,
              side: detailedInfoState?.side,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: DefaultTabController(
        length: 3,
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
                Tab(
                  text: localizations.addModIntroductionTitle,
                ),
                Tab(
                  text: localizations.addModDetailedTitle,
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
                        onPressed: () => _submit(),
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
            children: [
              _BaseInfo(key: _baseInfoKey),
              const _Introduction(),
              _DetailedInfo(key: _detailedInfoKey)
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailedInfo extends StatefulWidget {
  const _DetailedInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<_DetailedInfo> createState() => _DetailedInfoState();
}

class _DetailedInfoState extends State<_DetailedInfo> {
  List<RelationMod>? relationMods;
  ModIntegrationPlatform integration = ModIntegrationPlatform();
  List<ModSide> side = [];

  void _saveSideData(
      {required ModSide value, required ModSideEnvironment environment}) {
    if (side.any((e) => e.environment == environment)) {
      /// 如果已經選擇過相同執行環境則刪除
      side.removeWhere((e) => e.environment == environment);
    }

    side.add(value);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        child: Column(
      children: [
        SizedBox(height: kSplitHight),
        SEOText(localizations.addModDetailedIntegration,
            style: _titleTextStyle),
        RPMTWFormField(
          fieldName: "CurseForge Project ID",
          hintText: localizations.addModDetailedCurseForgeHint,
          onSaved: (value) {
            integration = integration.copyWith(
              curseForgeID: value,
            );
          },
        ),
        RPMTWFormField(
          fieldName: "Modrinth Project ID",
          hintText: localizations.addModDetailedModrinthHint,
          onSaved: (value) {
            integration = integration.copyWith(
              modrinthID: value,
            );
          },
        ),
        SizedBox(height: kSplitHight),
        SEOText(localizations.addModDetailedEnvironment,
            style: _titleTextStyle),
        _ModSideChoice(
            environment: ModSideEnvironment.client,
            onSaved: (value) => _saveSideData(
                value: value, environment: ModSideEnvironment.client)),
        _ModSideChoice(
            environment: ModSideEnvironment.server,
            onSaved: (value) => _saveSideData(
                value: value, environment: ModSideEnvironment.server)),
        SizedBox(height: kSplitHight),
        SEOText(localizations.addModDetailedRelation, style: _titleTextStyle),
        SizedBox(height: kSplitHight),
        _RelationMod(
          onSaved: (value) => relationMods = value,
        ),
        SizedBox(height: kSplitHight),
      ],
    ));
  }
}

class _RelationMod extends StatefulWidget {
  final void Function(List<RelationMod>?) onSaved;
  const _RelationMod({Key? key, required this.onSaved}) : super(key: key);

  @override
  _RelationModState createState() => _RelationModState();
}

class _RelationModState extends State<_RelationMod> {
  List<RelationMod>? relationMods;

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
          Column(
            children: relationMods!
                .map((relationMod) => FutureBuilder<MinecraftMod>(
                    future: RPMTWApiClient.lastInstance.minecraftResource
                        .getMinecraftMod(relationMod.modUUID),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        MinecraftMod mod = snapshot.data!;
                        return ExpansionTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.expand_more),
                              SizedBox(width: kSplitWidth),
                              IconButton(
                                icon: const FaIcon(FontAwesomeIcons.trash),
                                tooltip: localizations.guiDelete,
                                onPressed: () {
                                  relationMods!.remove(relationMod);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          title: SEOText(mod.name, textAlign: TextAlign.center),
                          subtitle: SEOText(relationMod.type.i18n,
                              textAlign: TextAlign.center),
                          children: [
                            SEOText(relationMod.condition ??
                                localizations
                                    .addModDetailedRelationConditionCommon),
                            if (mod.description != null)
                              SEOText(mod.description!),
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }))
                .toList(),
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
              style: _titleTextStyle),
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
  const _ModSideChoice(
      {Key? key, required this.environment, required this.onSaved})
      : super(key: key);

  @override
  State<_ModSideChoice> createState() => _ModSideChoiceState();
}

class _ModSideChoiceState extends State<_ModSideChoice> {
  bool isRequired = false;
  bool isOptional = false;
  bool isUnsupported = false;

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
}

class _BaseInfo extends StatefulWidget {
  const _BaseInfo({Key? key}) : super(key: key);

  @override
  _BaseInfoState createState() => _BaseInfoState();
}

class _BaseInfoState extends State<_BaseInfo>
    with AutomaticKeepAliveClientMixin {
  bool _loading = true;
  List<MinecraftVersion> _allMinecraftVersions = [];

  bool isForge = false;
  bool isFabric = false;

  String? name;
  String? id;
  String? description;
  List<String> supportVersions = [];
  Uint8List? imageBytes;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
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
    super.build(context);
    return BasePage(
      loading: _loading,
      child: Column(
        children: [
          RPMTWFormField(
            fieldName: localizations.addModOriginalNameField,
            hintText: localizations.addModOriginalNameHintText,
            onSaved: (value) => name = value,
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
            onSaved: (value) => description = value,
          ),
          _buildLoaderCheckbox(),
          _VersionChoice(
            allVersions: _allMinecraftVersions,
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
        SEOText(localizations.addModBaseImageTitle, style: _titleTextStyle),
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
          if (imageBytes != null) {
            return Column(
              children: [
                Stack(
                  children: [
                    Image.memory(imageBytes!, width: 350, height: 350),
                    Positioned(
                        right: 1,
                        top: 1,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                imageBytes = null;
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
          SEOText(localizations.addModLoader, style: _titleTextStyle),
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

class _Introduction extends StatefulWidget {
  const _Introduction({
    Key? key,
  }) : super(key: key);

  @override
  State<_Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<_Introduction> {
  late final TextEditingController _controller;
  late final SimpleStack _changeController;

  final TextStyle _textStyle = const TextStyle(fontSize: 25);

  @override
  void initState() {
    _controller = TextEditingController();
    _changeController = SimpleStack("", limit: 20);
    super.initState();

    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _githubMarkdownUrl() {
    Locale traditionalChinese = const Locale.fromSubtags(
        languageCode: 'zh', countryCode: 'TW', scriptCode: 'Hant');
    if (locale == traditionalChinese) {
      return "https://gist.github.com/billy3321/1001749662c370887c63bb30f26c9e6e";
    } else {
      return "https://docs.github.com/en/github/writing-on-github";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SplitView(
          viewMode:
              kIsWebDesktop ? SplitViewMode.Horizontal : SplitViewMode.Vertical,
          gripSize: 3,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.text_snippet),
                    SizedBox(width: kSplitWidth / 2),
                    SEOText(localizations.addModIntroductionOriginal,
                        style: _textStyle),
                  ],
                ),
                const RPMTWDivider(),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: kIsWebDesktop ? 30 : 10,
                    maxLength: null,
                    onChanged: (value) {
                      _changeController.modify(value);
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(height: kSplitHight),
                EditorToolbar.basic(
                    controller: _controller,
                    setState: setState,
                    changeController: _changeController,
                    context: context),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FaIcon(FontAwesomeIcons.markdown),
                    SizedBox(width: kSplitWidth / 2),
                    LinkText(
                      text: localizations.addModIntroductionMarkdown,
                      link: _githubMarkdownUrl(),
                    ),
                  ],
                )
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.preview),
                      SizedBox(width: kSplitWidth / 2),
                      SEOText(localizations.addModIntroductionPreview,
                          style: _textStyle),
                    ],
                  ),
                  const RPMTWDivider(),
                  MarkdownBody(
                    selectable: true,
                    data: _controller.text,
                    onTapLink: (String text, String? href, String title) {
                      if (href != null) {
                        window.open(href, title.isNotEmpty ? title : text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitModDialog extends StatefulWidget {
  final String name;
  final List<String> supportVersions;
  final String? id;
  final String? description;
  final List<RelationMod>? relationMods;
  final ModIntegrationPlatform? integration;
  final List<ModSide>? side;
  final List<ModLoader>? loaders;

  const _SubmitModDialog({
    Key? key,
    required this.name,
    required this.supportVersions,
    this.id,
    this.description,
    this.relationMods,
    this.integration,
    this.side,
    this.loaders,
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
      loader: widget.loaders,
    );
  }

  FutureBuilder<MinecraftMod> _buildCreatingDialog() {
    return FutureBuilder<MinecraftMod>(
        future: _creating(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            MinecraftMod mod = snapshot.data!;
            return AlertDialog(
              title: Text(localizations.guiSuccess),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(localizations.addModCreateSuccess),
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
              title: Text(localizations.addModCreating),
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
  final void Function(List<String>) onChanged;
  const _VersionChoice(
      {Key? key, required this.allVersions, required this.onChanged})
      : super(key: key);

  @override
  State<_VersionChoice> createState() => _VersionChoiceState();
}

class _VersionChoiceState extends State<_VersionChoice> {
  late List<String> versions;

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
        SEOText(localizations.addModSupportedVersionField,
            style: _titleTextStyle),
        FormField<List<String>>(
          initialValue: versions,
          validator: (value) {
            if (value!.isEmpty) {
              String error = localizations.addModSupportedVersionNull;
              Utility.showErrorFlushbar(context, error);

              return error;
            }
            return null;
          },
          builder: (field) {
            return UnmanagedRestorationScope(
                bucket: field.bucket,
                child: SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: versions.isNotEmpty
                          ? versions.reduce((a, b) => a + '、' + b)
                          : localizations.addModSupportedVersionHint,
                    ),
                    isDense: true,
                    onChanged: (x) {},
                    selectedItemBuilder: (context) {
                      return widget.allVersions
                          .map((e) => DropdownMenuItem(
                                child: Container(),
                              ))
                          .toList();
                    },
                    items: widget.allVersions.map((e) {
                      String versionID = e.id;

                      return DropdownMenuItem<String>(
                        enabled: false,
                        child: Row(
                          children: [
                            StatefulBuilder(
                                builder: (context, _setCheckBoxState) {
                              return Checkbox(
                                  value: versions.contains(versionID),
                                  onChanged: (isSelected) {
                                    if (isSelected!) {
                                      var ns = versions;
                                      ns.add(versionID);
                                      widget.onChanged(ns);
                                    } else {
                                      var ns = versions;
                                      ns.remove(versionID);
                                      widget.onChanged(ns);
                                    }
                                    _setCheckBoxState(() {});
                                    setState(() {});
                                  });
                            }),
                            SEOText(versionID)
                          ],
                        ),
                        value: versionID,
                      );
                    }).toList(),
                  ),
                ));
          },
        ),
      ],
    );
  }
}
