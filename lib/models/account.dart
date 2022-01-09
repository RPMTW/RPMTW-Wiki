import 'package:rpmtw_api_client/rpmtw_api_client.dart';

class Account extends User {
  final String token;
  Account(
      {required String uuid,
      required String username,
      required String email,
      required bool emailVerified,
      required String? avatarStorageUUID,
      required int status,
      required String message,
      required this.token})
      : super(
            uuid: uuid,
            username: username,
            email: email,
            emailVerified: emailVerified,
            avatarStorageUUID: avatarStorageUUID,
            status: status,
            message: message);

  factory Account.fromMap(Map<String, dynamic> map) {
    Map data = map['data'];
    return Account(
        uuid: data['uuid'],
        username: data['username'],
        email: data['email'],
        emailVerified: data['emailVerified'],
        avatarStorageUUID: data['avatarStorageUUID'],
        status: map['status'],
        message: map['message'],
        token: data['token']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "message": message,
      "data": {
        'uuid': uuid,
        'username': username,
        'email': email,
        'emailVerified': emailVerified,
        'avatarStorageUUID': avatarStorageUUID,
        'token': token
      }
    };
  }
}
