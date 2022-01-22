import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:rpmtw_wiki/utilities/data.dart';

extension I18nRelationType on RelationType {
  String get i18n {
    switch (this) {
      case RelationType.dependency:
        return localizations.addModDetailedRelationDependency;
      case RelationType.conflict:
        return localizations.addModDetailedRelationConflict;
      case RelationType.integration:
        return localizations.addModDetailedRelationIntegration;
      case RelationType.other:
        return localizations.addModDetailedRelationOther;
      case RelationType.reforged:
        return localizations.addModDetailedRelationReforged;
    }
  }
}

extension StringCasingExtension on String {
  /// 將字串第一個字轉為大寫
  /// hello world -> Hello world
  String toCapitalized() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  /// 將字串每個開頭字母轉成大寫
  /// hello world -> Hello World
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");

  bool get isEnglish {
    RegExp regExp = RegExp(r'\w+\s*$');
    return regExp.hasMatch(this);
  }

  bool toBool() => this == "true";
}
