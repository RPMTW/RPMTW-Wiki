import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/editor_tool_bar.dart';
import 'package:rpmtw_wiki/widget/link_text.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';
import 'package:split_view/split_view.dart';
import 'package:undo/undo.dart';

class IntroductionEditor extends StatefulWidget {
  final String? defaultIntroduction;

  const IntroductionEditor({
    Key? key,
    this.defaultIntroduction,
  }) : super(key: key);

  @override
  State<IntroductionEditor> createState() => IntroductionEditorState();
}

class IntroductionEditorState extends State<IntroductionEditor> {
  late final TextEditingController _controller;
  late final SimpleStack _changeController;

  final TextStyle _textStyle = const TextStyle(fontSize: 25);

  String? introduction;

  @override
  void initState() {
    introduction = widget.defaultIntroduction;
    _controller = TextEditingController(text: introduction);
    _changeController = SimpleStack(_controller.text, limit: 20);

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
    Size size = Utility.getSize(context);

    return BasePage(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: SplitView(
          viewMode:
              kIsDesktop ? SplitViewMode.Horizontal : SplitViewMode.Vertical,
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
                    maxLines: kIsDesktop ? 30 : 10,
                    maxLength: null,
                    onChanged: (value) {
                      _changeController.modify(value);
                      if (value.isNotEmpty) {
                        introduction = value;
                      } else {
                        introduction = null;
                      }
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
                        Utility.openUrl(href,
                            name: title.isNotEmpty ? title : text);
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
