import 'package:flutter/material.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/models/account.dart';
import 'package:rpmtw_wiki/screen/home_page.dart';
import 'package:rpmtw_wiki/utilities/account_handler.dart';
import 'package:rpmtw_wiki/utilities/data.dart';
import 'package:rpmtw_wiki/widget/ok_close.dart';
import 'package:rpmtw_wiki/widget/seo_text.dart';

class AuthSuccessDialog extends StatefulWidget {
  final String token;
  const AuthSuccessDialog({Key? key, required this.token}) : super(key: key);

  @override
  _AuthSuccessDialogState createState() => _AuthSuccessDialogState();
}

class _AuthSuccessDialogState extends State<AuthSuccessDialog> {
  Future<Account> logInIng() async {
    RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
    apiClient.setGlobalToken(widget.token);
    User user = await apiClient.authResource.getUserByUUID("me");
    return AccountHandler.setByUser(user, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Account>(
        future: logInIng(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            Account account = snapshot.data!;
            return AlertDialog(
              title: SEOText(localizations.guiSuccess),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SEOText(localizations.authSuccess),
                  SEOText(account.username),
                ],
              ),
              actions: [
                OkClose(
                  onOk: () {
                    navigation.pushNamed(HomePage.route);
                  },
                )
              ],
            );
          } else {
            return AlertDialog(
              title: SEOText(localizations.authLogInIng),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
