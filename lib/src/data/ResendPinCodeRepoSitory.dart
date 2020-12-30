import 'package:ezayak/src/data/ResendPinRepo.dart';
import 'package:ezayak/src/data/api_client.dart';
import 'package:http/src/response.dart';

import '../../app_constants.dart';
import '../../base_url.dart';

class ResendPinRepository implements ResendPinRepo {
  //String loginUrl = authUrl + LOGIN_URL;
  String resendPinUrl = '$AUTH_URL/resendcode';

  @override
  Future<Response> fetchPin(String headerToken) async {

    return await getCallService(resendPinUrl, RequestType.FetchPin, headerToken);
  }

}