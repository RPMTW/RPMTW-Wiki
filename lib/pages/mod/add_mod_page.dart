import 'package:flutter/material.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/pages/mod/base_info_editor.dart';
import 'package:rpmtw_wiki/pages/mod/detailed_info_editor.dart';
import 'package:rpmtw_wiki/pages/mod/introduction_editor.dart';
import 'package:rpmtw_wiki/pages/mod/submit_button.dart';
import 'package:rpmtw_wiki/pages/mod/submit_mod_dialog.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/keep_alive_wrapper.dart';
import 'package:rpmtw_wiki/widget/title_bar.dart';

class AddModPage extends StatefulWidget {
  static const String route = '/mod/add';
  const AddModPage({Key? key}) : super(key: key);

  @override
  _AddModPageState createState() => _AddModPageState();
}

class _AddModPageState extends State<AddModPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<BaseInfoEditorState> _baseInfoKey = GlobalKey();
  final GlobalKey<IntroductionEditorState> _introductionKey = GlobalKey();
  final GlobalKey<DetailedInfoEditorState> _detailedInfoKey = GlobalKey();

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
        builder: (context) => SubmitModDialog(
              submitType: SubmitModDialogType.create,
              name: baseInfoState.name!,
              supportVersions: supportVersions,
              id: baseInfoState.id,
              description: baseInfoState.description,
              loaders: loaders,
              relationMods: detailedInfoState?.relationMods,
              integration: detailedInfoState?.integration,
              side: detailedInfoState?.side,
              imageBytes: baseInfoState.imageBytes,
              introduction: introductionState?.introduction,
              translatedName: baseInfoState.translatedName,
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
              KeepAliveWrapper(child: BaseInfoEditor(key: _baseInfoKey)),
              KeepAliveWrapper(
                  child: IntroductionEditor(key: _introductionKey)),
              KeepAliveWrapper(child: DetailedInfoEditor(key: _detailedInfoKey))
            ],
          ),
        ),
      ),
    );
  }
}
