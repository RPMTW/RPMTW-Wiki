import 'package:universal_html/html.dart';

import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/account_manage_button.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Function()? onBackPressed;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Widget? logo;

  const TitleBar({
    this.title,
    this.onBackPressed,
    this.bottom,
    this.actions,
    this.logo,
    Key? key,
  }) : super(key: key);

  double get toolbarHeight => 65;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBackPressed != null
          ? BackButton(
              onPressed: () => onBackPressed!.call(),
            )
          : const SizedBox.shrink(),
      leadingWidth: onBackPressed != null ? 38.0 : 0.0,
      centerTitle: Utility.isDesktop,
      title: _buildTitle(),
      toolbarHeight: toolbarHeight,
      bottom: bottom,
      actions: [
        ...?actions?.map((widget) => Row(
              /// 將每個動作 widget 間隔 8 pixel
              children: [
                widget,
                const SizedBox(width: 8),
              ],
            )),
        const AccountManageButton()
      ],
    );
  }

  Row _buildTitle() {
    return Row(
      mainAxisAlignment:
          Utility.isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        logo ??
            InkResponse(
              onTap: () {
                window.open("https://www.rpmtw.com", "RPMTW Website");
              },
              child: Image.asset(
                'assets/images/RPMTW_Logo.gif',
                fit: BoxFit.contain,
                width: 52,
              ),
            ),
        const SizedBox(width: 8),
        Expanded(
            child: SEOText(title ?? localizations.title,
                overflow: TextOverflow.ellipsis))
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));
}
