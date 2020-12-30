import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ezayak/src/data/advice/advice.dart';
import 'package:ezayak/src/data/authenticate_data.dart';
import 'package:ezayak/src/data/calendar/calendar-mode.dart';
import 'package:ezayak/src/data/chatBotToken/chatBot_token.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/familyData/family_data.dart';
import 'package:ezayak/src/data/login_data.dart';
import 'package:ezayak/src/data/moods/mood.dart';
import 'package:ezayak/src/data/otp_response.dart';
import 'package:ezayak/src/data/user_family/get_cities.dart';
import 'package:ezayak/src/data/user_family/get_governorates.dart';
import 'package:ezayak/src/data/webViewsModel/customWebView_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

import '../../app_constants.dart';
import '../AppLocalizations.dart';
import '../app_utils.dart';

enum RequestType {
  FetchAuthenticateToken,
  FetchLoginToken,
  FetchSingUpTemp,
  FetchForgetPassword,
  FetchChangPasswordToken,
  FetchChangTempPasswordToken,
  FetchOtp,
  FetchActionList,
  FetchVendor,
  FetchCalibrationTypes,
  FetchSiteIdValidationResult,
  FetchAutoCompleteResult,
  FetchRequestIdForAllDevices,
  FetchRequestIdForFaultyDevices,
  FetchAllDevicesResult,
  FetchFaultyDevicesResult,
  FetchRequestIdForCalibratedDevices,
  FetchRequestIdForCalibratedFaultyDevices,
  FetchRequestIdForCalibratedSiteDevices,
  FetchAllDevicesCalibratedResult,
  FetchFaultyDevicesCalibratedResult,
  FetchSiteDevicesCalibratedResult,
  FetchPin,
  FetchGovernorates,
  FetchCities,
  FetchAddMember,
  FetchAdvices,
  FetchMoods,
  FetchFamilyMembers,
  FetchCalendarMood,
  fetchCustomWebViewList,
  FetchEditMember,
  DeleteFamilyMember,
  DeleteMyProfile,
  FetchChatBotToken,
}

dynamic getRequestBody(String requestBody) {
  return requestBody;
}

Future<dynamic> postCallService(String url, RequestType requestType,
    dynamic requestBody, String headerToken) async {
  logD('requestBody $requestBody');
  logD('headerToken $headerToken');
  logD('post url $url');

  try {
    final result = await InternetAddress.lookup(GOOGLE_COM);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      try {
        final response = await http
            .post('$url',
                headers: {
                  HttpHeaders.contentTypeHeader: APPLICATION_JSON,
                  HttpHeaders.authorizationHeader: '$BEARER $headerToken'
                },
                body: getRequestBody(requestBody))
            .timeout(const Duration(seconds: 180),
                onTimeout: () =>
                    throw ErrorResponse(message: CODE_2, error: TIME_OUT));
        final statusCode = response.statusCode;
        logD('statusCode $statusCode');
        logD('response ${utf8.decode(response.bodyBytes)}');
        if (!(statusCode >= 200 && statusCode <= 201)) {
          logD('error response ${response.body}');
          if (statusCode > 500 && statusCode < 599) {
            throw ErrorResponse(
                message: CODE_2, error: STATUS_CODE + statusCode.toString());
          } else if (statusCode == 401) {
            var errorResponse = errorResponseFromJson(response.body);
            throw ErrorResponse(
                code: CODE_401,
                key: errorResponse.key,
                message: errorResponse.message,
                error: errorResponse.error);
          } else {
            var errorResponse = errorResponseFromJson(response.body);
            throw ErrorResponse(
                code: errorResponse.code,
                key: errorResponse.key,
                message: errorResponse.message,
                error: errorResponse.error);
          }
        }
        switch (requestType) {
          case RequestType.FetchAuthenticateToken:
            return postAuthenticateResponseFromJson(response.body);
            break;
          case RequestType.FetchLoginToken:
            return postLoginResponseFromJson(response.body);
            break;
          case RequestType.FetchChangPasswordToken:
            return response.body;
            break;
          case RequestType.FetchAddMember:
            return statusCode;
          case RequestType.DeleteFamilyMember:
            return statusCode;
            break;
          case RequestType.DeleteMyProfile:
            return statusCode;
            break;

          default:
            {}
        }
      } on NoSuchMethodError catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.toString() + NO_SUCH_METHOD_ERROR);
      } on SocketException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + SOCKET_EXCEPTION);
      } on TimeoutException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + TIMEOUT_EXCEPTION);
      } on HandshakeException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + HANDSHAKE_EXCEPTION);
      } on FormatException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + FORMAT_EXCEPTION);
      } on TypeError catch (e) {
        logD('error here $e');
        throw ErrorResponse(message: CODE_2, error: e.toString() + TYPE_ERROR);
      }
    }
  } on SocketException catch (_) {
    throw ErrorResponse(message: CODE_1);
  }
}

Future<dynamic> getCallService(
    String url, RequestType requestType, String headerToken) async {
  logD('headerToken $headerToken');
  logD('get url $url');

  try {
    final result = await InternetAddress.lookup(GOOGLE_COM);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      try {
        http.Response response = await http.get(url, headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          HttpHeaders.authorizationHeader: '$BEARER $headerToken'
        }).timeout(const Duration(seconds: 180),
            onTimeout: () =>
                throw ErrorResponse(message: CODE_2, error: TIME_OUT));
        final statusCode = response.statusCode;
        logD('statusCode $statusCode');
        logD('response ${utf8.decode(response.bodyBytes)}');
        if (!(statusCode >= 200 && statusCode <= 204)) {
          logD('error response ${response.body}');
          if (statusCode > 500 && statusCode < 599) {
            throw ErrorResponse(
                message: CODE_2, error: STATUS_CODE + statusCode.toString());
          } else if (statusCode == 401) {
            var errorResponse = errorResponseFromJson(response.body);
            throw ErrorResponse(
                code: CODE_401,
                key: errorResponse.key,
                message: errorResponse.message,
                error: errorResponse.error);
          } else {
            var errorResponse = errorResponseFromJson(response.body);
            throw ErrorResponse(
                code: errorResponse.code,
                key: errorResponse.key,
                message: errorResponse.message,
                error: errorResponse.error);
          }
        }
        if (statusCode == 204) {
          BuildContext context;
                    throw ErrorResponse(
                        message: AppLocalizations.of(context).translate(No_content), error: statusCode.toString());
        }
        switch (requestType) {
          case RequestType.FetchOtp:
            return postOtpResponseFromJson(response.body);
            break;
          case RequestType.FetchSiteIdValidationResult:
            return errorResponseFromJson(response.body);
            break;
          case RequestType.FetchAutoCompleteResult:
            var resBody = json.decode(response.body);
            return resBody;
            break;
          case RequestType.FetchPin:
            break;
          case RequestType.FetchGovernorates:
            final List responseBody =
                json.decode(utf8.decode(response.bodyBytes));
            return responseBody
                .map((c) => GetGovernorates.fromJson(c))
                .toList();
            break;
          case RequestType.FetchCities:
            final List responseBody =
                json.decode(utf8.decode(response.bodyBytes));
            return responseBody.map((c) => GetCities.fromJson(c)).toList();
            break;
          case RequestType.FetchAdvices:
            final List responseBody = json.decode(response.body);
            return responseBody.map((c) => Advice.fromJson(c)).toList();
            break;
          case RequestType.FetchFamilyMembers:
            final List responseBody =
                json.decode(utf8.decode(response.bodyBytes));
            return responseBody.map((c) => FamilyMember.fromJson(c)).toList();
            break;
          case RequestType.fetchCustomWebViewList:
            final List responseBody = json.decode(response.body);
            return responseBody.map((c) => CustomWebView.fromJson(c)).toList();
            break;
          case RequestType.FetchMoods:
            final List responseBody =
                json.decode(utf8.decode(response.bodyBytes));
            return responseBody.map((c) => Moods.fromJson(c)).toList();
            break;
          case RequestType.FetchCalendarMood:
            return getCalendarMoodPerMonth(response.body);
            break;
          case RequestType.FetchChatBotToken:
            return getChatBotToken(response.body);
            break;

          default:
            {}
        }
      } on NoSuchMethodError catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.toString() + NO_SUCH_METHOD_ERROR);
      } on SocketException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + SOCKET_EXCEPTION);
      } on TimeoutException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + TIMEOUT_EXCEPTION);
      } on HandshakeException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + HANDSHAKE_EXCEPTION);
      } on FormatException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + FORMAT_EXCEPTION);
      } on TypeError catch (e) {
        logD('error here $e');
        throw ErrorResponse(message: CODE_2, error: e.toString() + TYPE_ERROR);
      }
    }
  } on SocketException catch (_) {
    throw ErrorResponse(message: CODE_1);
  }
}

Future<dynamic> putCallService(String url, RequestType requestType,
    dynamic requestBody, String headerToken) async {
  logD('requestBody $requestBody');
  logD('headerToken $headerToken');
  logD('put url $url');
  try {
    final result = await InternetAddress.lookup(GOOGLE_COM);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      try {
        final response = await http
            .put('$url',
                headers: {
                  HttpHeaders.contentTypeHeader: APPLICATION_JSON,
                  HttpHeaders.authorizationHeader: '$BEARER $headerToken'
                },
                body: getRequestBody(requestBody))
            .timeout(const Duration(seconds: 180),
                onTimeout: () =>
                    throw ErrorResponse(message: CODE_2, error: TIME_OUT));
        final statusCode = response.statusCode;
        logD('statusCode $statusCode');
        logD('response ${utf8.decode(response.bodyBytes)}');
        if (!(statusCode >= 200 && statusCode <= 201)) {
          logD('error response ${response.body}');
          if (statusCode > 500 && statusCode < 599) {
            throw ErrorResponse(
                message: CODE_2, error: STATUS_CODE + statusCode.toString());
          } else if (statusCode == 401) {
            var errorResponse = errorResponseFromJson(response.body);
            throw ErrorResponse(
                code: CODE_401,
                key: errorResponse.key,
                message: errorResponse.message,
                error: errorResponse.error);
          } else {
            var errorResponse = errorResponseFromJson(response.body);
            throw ErrorResponse(
                code: errorResponse.code,
                key: errorResponse.key,
                message: errorResponse.message,
                error: errorResponse.error);
          }
        }
        switch (requestType) {
          case RequestType.FetchEditMember:
            return response.body;
            break;

          default:
            {}
        }
      } on NoSuchMethodError catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.toString() + NO_SUCH_METHOD_ERROR);
      } on SocketException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + SOCKET_EXCEPTION);
      } on TimeoutException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + TIMEOUT_EXCEPTION);
      } on HandshakeException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + HANDSHAKE_EXCEPTION);
      } on FormatException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + FORMAT_EXCEPTION);
      } on TypeError catch (e) {
        logD('error here $e');
        throw ErrorResponse(message: CODE_2, error: e.toString() + TYPE_ERROR);
      }
    }
  } on SocketException catch (_) {
    throw ErrorResponse(message: CODE_1);
  }
}

Future<dynamic> deleteCallService(String url, RequestType requestType,
    dynamic requestBody, String headerToken) async {
  logD('requestBody $requestBody');
  logD('headerToken $headerToken');
  logD('delete url $url');

  try {
    final result = await InternetAddress.lookup(GOOGLE_COM);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      try {
        final response = await http
            .delete('$url',
            headers: {
              HttpHeaders.contentTypeHeader: APPLICATION_JSON,
              HttpHeaders.authorizationHeader: '$BEARER $headerToken'
            },)
            .timeout(const Duration(seconds: 180),
            onTimeout: () =>
            throw ErrorResponse(message: CODE_2, error: TIME_OUT));
        final statusCode = response.statusCode;
        logD('statusCode $statusCode');
        logD('response ${utf8.decode(response.bodyBytes)}');
        if (!(statusCode >= 200 && statusCode <= 201)) {
          logD('error response ${response.body}');
          if (statusCode > 500 && statusCode < 599) {
            throw ErrorResponse(
                message: CODE_2, error: STATUS_CODE + statusCode.toString());
          } else if (statusCode == 401) {
            var errorResponse = errorResponseFromJson(response.body);
            throw ErrorResponse(
                code: CODE_401,
                key: errorResponse.key,
                message: errorResponse.message,
                error: errorResponse.error);
          } else {
            var errorResponse = errorResponseFromJson(response.body);
            throw ErrorResponse(
                code: errorResponse.code,
                key: errorResponse.key,
                message: errorResponse.message,
                error: errorResponse.error);
          }
        }
        switch (requestType) {
          case RequestType.DeleteFamilyMember:
            return statusCode;
            break;
          case RequestType.DeleteMyProfile:
            return statusCode;
            break;

          default:
            {}
        }
      } on NoSuchMethodError catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.toString() + NO_SUCH_METHOD_ERROR);
      } on SocketException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + SOCKET_EXCEPTION);
      } on TimeoutException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + TIMEOUT_EXCEPTION);
      } on HandshakeException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + HANDSHAKE_EXCEPTION);
      } on FormatException catch (e) {
        logD('error here $e');
        throw ErrorResponse(
            message: CODE_2, error: e.message + FORMAT_EXCEPTION);
      } on TypeError catch (e) {
        logD('error here $e');
        throw ErrorResponse(message: CODE_2, error: e.toString() + TYPE_ERROR);
      }
    }
  } on SocketException catch (_) {
    throw ErrorResponse(message: CODE_1);
  }
}
