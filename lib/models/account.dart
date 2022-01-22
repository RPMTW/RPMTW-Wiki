import 'package:flutter/material.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';
import 'package:seo_renderer/seo_renderer.dart';

class Account extends User {
  final String token;
  Account(
      {required String uuid,
      required String username,
      required String email,
      required bool emailVerified,
      required String? avatarStorageUUID,
      required this.token})
      : super(
            uuid: uuid,
            username: username,
            email: email,
            emailVerified: emailVerified,
            avatarStorageUUID: avatarStorageUUID,
    );

  Widget seoAvatar({double fontSize = 18}) => ImageRenderer(
      child: avatar(fontSize: fontSize),
      link: avatarUrl(RPMTWApiClient.lastInstance.baseUrl)!,
      alt: "$username's avatar");

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        uuid: map['uuid'],
        username: map['username'],
        email: map['email'],
        emailVerified: map['emailVerified'],
        avatarStorageUUID: map['avatarStorageUUID'],
        token: map['token']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
        'uuid': uuid,
        'username': username,
        'email': email,
        'emailVerified': emailVerified,
        'avatarStorageUUID': avatarStorageUUID,
        'token': token
    };
  }
}
