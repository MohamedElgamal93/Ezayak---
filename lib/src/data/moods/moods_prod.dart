import 'package:ezayak/src/data/api_client.dart';

import 'package:ezayak/src/data/moods/mood.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../app_constants.dart';
import '../../../base_url.dart';

class ProdMoodsRepository implements MoodsRepository{

  String moodsUrl = '$APIs_URL/members/moods';
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
  Future<List<Moods>> fetchMoods() async {
    headerToken = await getToken();
    return await getCallService(moodsUrl, RequestType.FetchMoods, headerToken);
  }

}