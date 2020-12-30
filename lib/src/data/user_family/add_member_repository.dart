import 'package:ezayak/src/data/api_client.dart';
import 'package:ezayak/src/data/user_family/add_member.dart';
import 'package:ezayak/src/data/user_family/add_member_repo.dart';
import 'package:ezayak/src/data/user_family/get_governorates.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../app_constants.dart';
import '../../../base_url.dart';
import 'get_cities.dart';

class AddMemberRepository implements AddMemberRepo {
  String citiesUrl = '$APIs_URL/governorates/';
  String governoratesUrl =
      '$APIs_URL/governorates';
  String addMemberUrl = '$APIs_URL/members';

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
  Future<List<GetCities>> fetchCities(
      int governoratesId) async {
    headerToken = await getToken();
    return await getCallService(citiesUrl + "$governoratesId" + "/cities",
        RequestType.FetchCities, headerToken);
  }

  @override
  Future<List<GetGovernorates>> fetchGovernorates() async {
    headerToken = await getToken();
    return await getCallService(
        governoratesUrl, RequestType.FetchGovernorates, headerToken);
  }

  @override
  Future<int> addMember(List<AddMember> addMember) async {
    headerToken = await getToken();
    return await postCallService(addMemberUrl, RequestType.FetchAddMember,
        postAddMember(addMember), headerToken);
  }
}
