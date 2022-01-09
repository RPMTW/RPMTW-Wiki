import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

NavigatorState get navigation => NavigationService.navigationKey.currentState!;
AppLocalizations get localizations => AppLocalizations.of(navigation.context)!;

String developmentRPMWikiUrl = "http://localhost:45213";
String developmentRPMTWAccountUrl = "http://localhost:41351";

String rpmtwAccountOauth2 =
    "$developmentRPMTWAccountUrl?rpmtw_auth_callback=$developmentRPMWikiUrl"
    r"/auth?auth_token=${token}";
String rpmtwAccountUrl = developmentRPMTWAccountUrl;
late String href;
