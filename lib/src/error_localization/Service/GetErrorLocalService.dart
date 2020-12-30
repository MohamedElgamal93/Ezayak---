import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ezayak/src/app_utils.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/error_localization/data/model/error_localization_data.dart';

import '../../../app_constants.dart';

class GetErrorLocalService {
  final String url = LOCALISATION_URL;

  Future<List<ErrorLocalization>> getErrorLocalization() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String headerToken;
//    if (prefs != null && prefs.getString('Token') != null) {
//      headerToken = prefs.getString('Token');
//    }

    try {
      final result = await InternetAddress.lookup(GOOGLE_COM);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          http.Response response = await http.get(url, headers: {
            HttpHeaders.contentTypeHeader: APPLICATION_JSON,
            HttpHeaders.authorizationHeader: ''
          });
          final statusCode = response.statusCode;
          if (statusCode != 200) {
            var errorResponse = errorResponseFromJson(response.body);
            throw ErrorResponse(
                code: errorResponse.code,
                key: errorResponse.key,
                message: errorResponse.message,
                error: errorResponse.error);
          }
          final List responseBody = jsonDecode(response.body);

          return responseBody
              .map((c) => ErrorLocalization.fromMap(c))
              .toList();
        } on NoSuchMethodError catch (e) {
          logD('error here $e');
          throw ErrorResponse(message: CODE_2, error: e.toString() + NO_SUCH_METHOD_ERROR);
        } on SocketException catch (e) {
          logD('error here $e');
          throw ErrorResponse(message: CODE_2, error: e.message + SOCKET_EXCEPTION);
        } on TimeoutException catch (e) {
          logD('error here $e');
          throw ErrorResponse(message: CODE_2, error: e.message + TIMEOUT_EXCEPTION);
        } on HandshakeException catch (e) {
          logD('error here $e');
          throw ErrorResponse(message: CODE_2, error: e.message + HANDSHAKE_EXCEPTION);
        }
      }
    } on SocketException catch (_) {
      throw ErrorResponse(message: CODE_1);
    }
    return null;
  }
}
