import 'dart:convert';
import 'dart:html' as html;

import 'package:rpmtw_api_client/rpmtw_api_client.dart';
import 'package:rpmtw_wiki/models/account.dart';
import 'package:rpmtw_wiki/utilities/data.dart';

class AccountHandler {
  static late html.Storage storage;
  static Account? account;

  static void init() {
    storage = html.window.localStorage;
    if (storage.containsKey('rpmtw_account')) {
      try {
        Map<String, dynamic> accountMap =
            json.decode(storage['rpmtw_account']!).cast<String, dynamic>();
        account = Account.fromMap(accountMap);
      } catch (e) {
        storage.remove('rpmtw_account');
      }
    }
  }

  static bool get hasAccount => account != null;

  static String? get token => account?.token;

  static Account set(Account _account) {
    account = _account;
    save();
    return _account;
  }

  static Account setByUser(User user, String token) {
    Account account = Account(
        uuid: user.email,
        username: user.username,
        email: user.email,
        emailVerified: user.emailVerified,
        avatarStorageUUID: user.avatarStorageUUID,
        token: token);
    return set(account);
  }

  static void remove() {
    account = null;
    save();
  }

  static void save() {
    if (account != null) {
      Map<String, dynamic> accountJson = account!.toMap();
      html.window.localStorage['rpmtw_account'] = json.encode(accountJson);
    } else {
      storage.remove('rpmtw_account');
    }
  }

  static void login() {
    html.window.location.href = rpmtwAccountOauth2;
  }

  static void checkHasAccount(Function function) {
    if (hasAccount) {
      function.call();
    } else {
      login();
    }
  }
}
