import "package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart";
import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/pages/mod/base_info_editor.dart';
import 'package:rpmtw_wiki/pages/mod/detailed_info_editor.dart';
import 'package:rpmtw_wiki/pages/mod/introduction_editor.dart';
import 'package:rpmtw_wiki/pages/mod/submit_button.dart';
import 'package:rpmtw_wiki/pages/mod/submit_mod_dialog.dart';

import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/keep_alive_wrapper.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';

class EditModPage extends StatefulWidget {
  static const String route = "/mod/edit/";

  /// [MinecraftMod]'s uuid
  final String uuid;
  const EditModPage({Key? key, required this.uuid}) : super(key: key);

  @override
  _EditModPageState createState() => _EditModPageState();
}

class _EditModPageState extends State<EditModPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<BaseInfoEditorState> _baseInfoKey = GlobalKey();
  final GlobalKey<IntroductionEditorState> _introductionKey = GlobalKey();
  final GlobalKey<DetailedInfoEditorState> _detailedInfoKey = GlobalKey();

  bool loading = true;
  late MinecraftMod mod;

  @override
  void initState() {
    super.initState();

    load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Material(
        child: Center(
          child: Transform.scale(
              child: const CircularProgressIndicator(), scale: 2),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TitleBar(
            title: "${localizations.editModTitle} - ${mod.name}",
            logo: const Icon(Icons.edit),
            onBackPressed: () => navigation.pop(),
            bottom: TabBar(
              isScrollable: Utility.isMobile,
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
            actions: [SubmitButton(onPressed: () => _submit())],
          ),
          body: TabBarView(
            children: [
              KeepAliveWrapper(
                  child:
                      BaseInfoEditor.fromMinecraftMod(mod, key: _baseInfoKey)),
              KeepAliveWrapper(
                  child: IntroductionEditor(
                      defaultIntroduction: mod.introduction,
                      key: _introductionKey)),
              KeepAliveWrapper(
                  child: DetailedInfoEditor.fromMinecraftMod(mod,
                      key: _detailedInfoKey)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> load() async {
    RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
    mod = await apiClient.minecraftResource
        .getMinecraftMod(widget.uuid, recordViewCount: true);

    setState(() {
      loading = false;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final BaseInfoEditorState baseInfoState = _baseInfoKey.currentState!;
    final DetailedInfoEditorState? detailedInfoState =
        _detailedInfoKey.currentState;
    final IntroductionEditorState? introductionState =
        _introductionKey.currentState;

    List<ModLoader> loaders = [];
    if (baseInfoState.isFabric) {
      loaders.add(ModLoader.fabric);
    }
    if (baseInfoState.isForge) {
      loaders.add(ModLoader.forge);
    }

    showDialog(
        context: context,
        builder: (context) => SubmitModDialog(
              submitType: SubmitModDialogType.edit,
              name: baseInfoState.name!,
              supportVersions: baseInfoState.supportVersions,
              id: baseInfoState.id,
              description: baseInfoState.description,
              loaders: loaders,
              relationMods: detailedInfoState?.relationMods,
              integration: detailedInfoState?.integration,
              side: detailedInfoState?.side,
              imageBytes: baseInfoState.imageBytes,
              introduction: introductionState?.introduction,
              translatedName: baseInfoState.translatedName,
              editMod: mod,
            ));
  }
}
