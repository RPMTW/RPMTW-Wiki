import 'package:flutter_svg/flutter_svg.dart';
import 'package:universal_html/html.dart';

import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/account_manage_button.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class TitleBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final Function()? onBackPressed;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Widget? logo;
  final double toolbarHeight = 65;

  const TitleBar({
    this.title,
    this.onBackPressed,
    this.bottom,
    this.actions,
    this.logo,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));
  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: widget.title ?? localizations.title,
      color: Colors.blue,
      child: AppBar(
        leading: widget.onBackPressed != null
            ? BackButton(
                onPressed: () => widget.onBackPressed!.call(),
              )
            : const SizedBox.shrink(),
        leadingWidth: widget.onBackPressed != null ? 38.0 : 0.0,
        centerTitle: Utility.isDesktop,
        title: _buildTitle(),
        toolbarHeight: widget.toolbarHeight,
        bottom: widget.bottom,
        actions: [
          ...?widget.actions?.map((widget) => Row(
                /// 將每個動作 widget 間隔 8 pixel
                children: [
                  widget,
                  const SizedBox(width: 8),
                ],
              )),
          const AccountManageButton()
        ],
      ),
    );
  }

  Row _buildTitle() {
    return Row(
      mainAxisAlignment:
          Utility.isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.logo ??
            InkResponse(
              onTap: () {
                window.open("https://www.rpmtw.com", "RPMTW Website");
              },
              child: SvgPicture.asset(
                'assets/images/RPMWiki_Logo.svg',
                fit: BoxFit.contain,
                width: 40,
                semanticsLabel: "RPMWiki Logo",
              ),
            ),
        const SizedBox(width: 8),
        Expanded(
            child: SEOText(widget.title ?? localizations.title,
                overflow: TextOverflow.ellipsis))
      ],
    );
  }
}
