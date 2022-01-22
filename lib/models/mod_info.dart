import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';

class ModInfo {
  final MinecraftMod mod;
  final WikiModData wikiData;
  const ModInfo({
    required this.mod,
    required this.wikiData,
  });
}
