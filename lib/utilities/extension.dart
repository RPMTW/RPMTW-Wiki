// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:firebase_analytics/firebase_analytics.dart';
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

extension ModSearchTypeExtension on ModSortType {
  String get i18n {
    switch (this) {
      case ModSortType.createTime:
        return localizations.modSortTypeCreateTime;
      case ModSortType.viewCount:
        return localizations.modSortTypeViewCount;
      case ModSortType.name:
        return localizations.modSortTypeName;
      case ModSortType.lastUpdate:
        return localizations.modSortTypeLastUpdate;
    }
  }
}

extension FirebaseAnalyticsExtension on FirebaseAnalytics {
  Future<void> logPageView({
    String? pageClass,
    String? pageName,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) {
    return logEvent(
      name: 'page_view',
      parameters: filterOutNulls(<String, Object?>{
        "page_title": pageName,
        "page_class": pageClass,
      }..addAll(parameters ?? {})),
      callOptions: callOptions,
    );
  }

  Future<void> logViewMod({
    required String uuid,
    AnalyticsCallOptions? callOptions,
  }) async {
    await logPageView(
      pageClass: "ViewModPage",
      pageName: "View Mod",
    );
    await logEvent(
      name: 'view_mod',
      parameters: filterOutNulls(<String, Object?>{
        "uuid": uuid,
      }),
      callOptions: callOptions,
    );
  }

  Future<void> logEditMod({
    required String uuid,
    AnalyticsCallOptions? callOptions,
  }) async {
    await logPageView(
      pageClass: "EditModPage",
      pageName: "Edit Mod",
    );
    await logEvent(
      name: 'edit_mod',
      parameters: filterOutNulls(<String, Object?>{
        "uuid": uuid,
      }),
      callOptions: callOptions,
    );
  }
}
