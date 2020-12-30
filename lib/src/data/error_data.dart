import 'dart:convert';

import '../../app_constants.dart';

class ErrorResponse {
  String code;
  String key;
  String message;
  String error;

  ErrorResponse({this.code, this.key, this.message, this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      code: json[CODE],
      key: json[TIME_STAMP],
      message: json[MESSAGE],
      error: json[ERROR],
    );
  }
}

ErrorResponse errorResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return ErrorResponse.fromJson(jsonData);
}
