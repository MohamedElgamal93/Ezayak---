import 'dart:async';
import 'package:ezayak/src/data/api_client.dart';
import 'package:ezayak/src/data/authenticate_data.dart';
import 'package:ezayak/src/data/login_data.dart';
import '../../app_constants.dart';
import '../../base_url.dart';

class AuthenticateRepository implements AuthenticateRepo {
  //String authenticateUrl = authUrl + AUTHENTICATE_URL;
  String authenticateUrl = '$AUTH_URL/authenticate';


  @override
  Future<AuthenticateResponse> fetchAuthenticateToken(
      AuthenticateRequest authenticate) async {
    return await postCallService(authenticateUrl, RequestType.FetchAuthenticateToken,postToJsonAuthenticate(authenticate),'');
  }
}

class LoginRepository implements LoginRepo {
  //String loginUrl = authUrl + LOGIN_URL;
  String loginUrl = '$AUTH_URL/login';

  @override
  Future<LoginResponse> fetchLoginToken(
      LoginRequestModel login, String headerToken) async {
    return await postCallService(loginUrl, RequestType.FetchLoginToken, postToJsonLogin(login),headerToken);
  }
}
