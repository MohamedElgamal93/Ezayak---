import 'dart:convert';

import '../../app_constants.dart';

class AuthenticateRequest {
  String username;
  String password;


  AuthenticateRequest({this.username, this.password});

  factory AuthenticateRequest.fromJson(Map<String, dynamic> json) {
    return AuthenticateRequest(
      username: json[USER_NAME],
      password: json[PASSWORD],
    );
  }

  Map<String, dynamic> toJson() => {
    USER_NAME: username,
    PASSWORD: password,

      };
}

String postToJsonAuthenticate(AuthenticateRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AuthenticateResponse {
  String pinCode;
  String jwtToken;
  int isExpiredDate;

  AuthenticateResponse({this.pinCode, this.jwtToken, this.isExpiredDate});

  factory AuthenticateResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticateResponse(
      pinCode: json[OTP_TOKEN],
      jwtToken: json[JWT_TOKEN],
      isExpiredDate: json[IS_EXPIRED_DATE],
    );
  }
}

AuthenticateResponse postAuthenticateResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return AuthenticateResponse.fromJson(jsonData);
}

abstract class AuthenticateRepo {
  Future<AuthenticateResponse> fetchAuthenticateToken(
      AuthenticateRequest authenticate);
}
