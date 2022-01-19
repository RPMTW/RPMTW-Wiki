import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/row_scroll_view.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_text_field.dart';
import 'package:undo/undo.dart';

class EditorToolbar extends StatelessWidget implements PreferredSizeWidget {
  final List<ToolbarButton> children;
  final double toolBarHeight;
  final Color? color;

  const EditorToolbar({
    required this.children,
    this.toolBarHeight = 40,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
          color: Colors.white10,
          constraints: BoxConstraints.tightFor(
              height: preferredSize.height, width: (children.length * 40) + 30),
          child: RowScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight);

  factory EditorToolbar.basic(
      {Key? key,
      required TextEditingController controller,
      required StateSetter setState,
      required SimpleStack changeController,
      required BuildContext context}) {
    /// 替換 Markdown 格式文字後將回傳修改後的文字
    String wrapWith({required String leftSide, String? rightSide}) {
      final String text = controller.value.text;
      final TextSelection selection = controller.selection;
      late final String middle;
      try {
        middle = selection.textInside(text);
      } catch (e) {
        middle = '';
      }
      late final String newText;

      /// 如果已經有套用此格式了，就取消套用
      if (middle.startsWith(leftSide) &&
          (rightSide == null || middle.endsWith(rightSide))) {
        String _text = middle.replaceFirst(leftSide, "");
        if (rightSide != null) {
          _text = _text.replaceFirst(rightSide, "");
        }
        newText = _text;
      } else {
        newText = selection.textBefore(text) +
            '$leftSide$middle${rightSide ?? ""}' +
            selection.textAfter(text);
      }

      controller.value = controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.baseOffset + leftSide.length + middle.length,
        ),
      );

      changeController.modify(newText);
      setState(() {});
      return newText;
    }

    return EditorToolbar(
      key: key,
      children: [
        ToolbarButton(
            icon: FontAwesomeIcons.heading,
            tooltip: "標題",
            onPressed: () => wrapWith(leftSide: '# ')),
        ToolbarButton(
          icon: FontAwesomeIcons.bold,
          tooltip: "粗體",
          onPressed: () => wrapWith(
            leftSide: '**',
            rightSide: '**',
          ),
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.italic,
          tooltip: "斜體",
          onPressed: () => wrapWith(
            leftSide: '*',
            rightSide: '*',
          ),
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.underline,
          tooltip: "下劃線",
          onPressed: () => wrapWith(
            leftSide: '__',
            rightSide: '__',
          ),
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.strikethrough,
          tooltip: "刪除線",
          onPressed: () => wrapWith(
            leftSide: '~~',
            rightSide: '~~',
          ),
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.link,
          tooltip: "連結",
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => _InsertLink(wrapWith: wrapWith));
          },
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.list,
          tooltip: "清單",
          onPressed: () => wrapWith(leftSide: '- '),
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.image,
          tooltip: "圖片",
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => _InsertImage(wrapWith: wrapWith));
          },
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.code,
          tooltip: "程式碼方塊",
          onPressed: () => wrapWith(leftSide: '```\n', rightSide: '\n```'),
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.quoteLeft,
          tooltip: "引用",
          onPressed: () {
            wrapWith(leftSide: '> ');
          },
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.undo,
          tooltip: "復原",
          onPressed: () {
            if (changeController.canUndo) {
              changeController.undo();
              controller.text = changeController.state;
            }
          },
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.redo,
          tooltip: "取消復原",
          onPressed: () {
            if (changeController.canRedo) {
              changeController.redo();
              controller.text = changeController.state;
            }
          },
        ),
        ToolbarButton(
          icon: FontAwesomeIcons.trashAlt,
          tooltip: "清除",
          onPressed: () {
            controller.clear();
            setState(() {});
          },
        ),
      ],
    );
  }
}

class _InsertImage extends StatefulWidget {
  final String Function({required String leftSide, String? rightSide}) wrapWith;
  const _InsertImage({
    Key? key,
    required this.wrapWith,
  }) : super(key: key);

  @override
  State<_InsertImage> createState() => _InsertImageState();
}

class _InsertImageState extends State<_InsertImage> {
  String? url;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return AlertDialog(
        title: const Text("插入圖片"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RPMTextField(
              hintText: "圖片網址",
              onChanged: (value) {
                setState(() {
                  url = value;
                });
              },
            ),
            Builder(builder: (context) {
              if (url != null) {
                return Column(
                  children: [
                    SizedBox(height: kSplitHight),
                    Image.network(
                      url!,
                      errorBuilder: ((context, error, stackTrace) =>
                          const Text("無效的圖片網址")),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            })
          ],
        ),
        actions: [
          TextButton(
            child: Text(localizations.guiCancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(localizations.guiConfirm),
            onPressed: () {
              widget.wrapWith(
                leftSide: '![]($url)',
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}

class _InsertLink extends StatelessWidget {
  final String Function({required String leftSide, String? rightSide}) wrapWith;
  const _InsertLink({Key? key, required this.wrapWith}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "";
    String url = "";
    return AlertDialog(
      title: const Text("插入連結"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RPMTextField(
            hintText: "網址標題",
            onChanged: (value) => title = value,
          ),
          SizedBox(height: kSplitHight),
          RPMTextField(
            hintText: "網址連結",
            onChanged: (value) => url = value,
          )
        ],
      ),
      actions: [
        TextButton(
          child: Text(localizations.guiCancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(localizations.guiConfirm),
          onPressed: () {
            wrapWith(
              leftSide: '[$title]($url)',
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ToolbarButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final void Function()? onPressed;
  const ToolbarButton(
      {Key? key,
      required this.tooltip,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
          onPressed: () {
            onPressed?.call();
          },
          icon: Icon(
            icon,
            color: Colors.white,
            size: 20,
          )),
    );
  }
}
