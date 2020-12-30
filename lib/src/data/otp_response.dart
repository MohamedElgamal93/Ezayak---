import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../app_constants.dart';

class OtpResponse {
  String code;
  String key;
  String message;

  OtpResponse({this.code, this.key, this.message});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      code: json[CODE],
      key: json[KEY],
      message: json[MESSAGE],
    );
  }
}

OtpResponse postOtpResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return OtpResponse.fromJson(jsonData);
}

List<OtpResponse> allPostsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<OtpResponse>.from(
      jsonData.map((x) => OtpResponse.fromJson(x)));
}

Future<OtpResponse> fetchPost(http.Response response) async {
  // If the call to the server was successful, parse the JSON.
  return OtpResponse.fromJson(json.decode(response.body));
}
