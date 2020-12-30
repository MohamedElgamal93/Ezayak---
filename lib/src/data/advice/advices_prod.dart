import 'package:ezayak/src/data/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../app_constants.dart';
import '../../../base_url.dart';
import 'advice.dart';

class ProdAdvicesRepository implements AdvicesRepository{

  String advicesUrl = '$APIs_URL/members/';
  String headerToken;
  final storage = FlutterSecureStorage();
  Future<String> getToken() async {
    if (storage != null && storage.read(key: 'Token') != null) {
      headerToken = await storage.read(key: "Token");
      return headerToken;
    } else {
      return "";
    }
  }
  @override
  Future<List<Advice>> fetchAdvices(int memberId,int moodId,int date) async {
    headerToken = await getToken();
    return await getCallService(advicesUrl+"$memberId"+"/moods/"+"$moodId/"+"$date", RequestType.FetchAdvices, headerToken);
  }

}