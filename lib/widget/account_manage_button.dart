// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpmtw_wiki/models/account.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class AccountManageButton extends StatefulWidget {
  const AccountManageButton({Key? key}) : super(key: key);

  @override
  _AccountManageButtonState createState() => _AccountManageButtonState();
}

class _AccountManageButtonState extends State<AccountManageButton> {
  @override
  Widget build(BuildContext context) {
    if (AccountHandler.hasAccount) {
      Account account = AccountHandler.account!;
      return Tooltip(
        message: localizations.authManage,
        child: InkResponse(
          radius: 40,
          highlightShape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: Row(
            children: [
              SizedBox(width: 30, height: 30, child: account.seoAvatar()),
              ...Utility.isWebMobile //手機板將不顯示詳細名稱
                  ? []
                  : [
                      const SizedBox(
                        width: 5,
                      ),
                      SEOText(account.username),
                    ],
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(localizations.authManage),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 50, height: 50, child: account.seoAvatar()),
                    Text(account.username),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.signOutAlt),
                          tooltip: localizations.authLogout,
                          onPressed: () async {
                            AccountHandler.remove();
                            Navigator.of(context).pop();
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.userCog),
                          tooltip: localizations.authManage,
                          onPressed: () async {
                            window.open(rpmtwAccountUrl, "RPMTW Account");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Row(
        children: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.user),
            tooltip: localizations.authLogIn,
            onPressed: () {
              window.location.href = rpmtwAccountOauth2;
            },
          ),
          const SizedBox(width: 15)
        ],
      );
    }
  }
}
