import 'dart:convert';

import '../../app_constants.dart';

class LoginRequestModel {
  String pinCode;


  LoginRequestModel({this.pinCode});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      pinCode: json[OTP_TOKEN],
    );
  }

  Map<String, dynamic> toJson() => {
        OTP_TOKEN: pinCode,
      };
}

String postToJsonLogin(LoginRequestModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class LoginResponse {
  bool firstLogin;
  String jwttoken;
  String userName;
  String phoneNumber;

  LoginResponse({this.jwttoken, this.userName,this.firstLogin,this.phoneNumber});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        jwttoken: json[LOGIN_JWT_TOKEN],
        userName: json[LOGIN_USER_NAME],
      firstLogin: json['firstLogin'],
      phoneNumber: json['phoneNumber']
    );
  }
}

LoginResponse postLoginResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return LoginResponse.fromJson(jsonData);
}

abstract class LoginRepo {
  Future<LoginResponse> fetchLoginToken(LoginRequestModel login, String headerToken);
}
