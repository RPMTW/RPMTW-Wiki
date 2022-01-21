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
