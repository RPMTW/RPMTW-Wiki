import 'package:flutter/material.dart';
import 'package:rpmtw_wiki/pages/base_page.dart';
import 'package:rpmtw_wiki/pages/mod/add_mod_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/utilities/utility.dart';
import 'package:rpmtw_wiki/widget/rpmtw-design/rpmtw_divider.dart';

class ModTab extends StatefulWidget {
  const ModTab({Key? key}) : super(key: key);

  @override
  _ModTabState createState() => _ModTabState();
}

class _ModTabState extends State<ModTab> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
        child: Column(
      children: [
        SizedBox(height: kSplitHight),
        const _Action(),
        SizedBox(height: kSplitHight)
      ],
    ));
  }
}

class _Action extends StatelessWidget {
  const _Action({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RPMTWVerticalDivider(),
        OutlinedButton(
            child: Text(localizations.addModTitle),
            onPressed: () => AccountHandler.checkHasAccount(
                () => navigation.pushNamed(AddModPage.route))),
      ],
    );
  }
}
