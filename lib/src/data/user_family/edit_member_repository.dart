import 'package:ezayak/src/data/api_client.dart';
import 'package:ezayak/src/data/user_family/add_member.dart';
import 'package:ezayak/src/data/user_family/edit_member_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../app_constants.dart';
import '../../../base_url.dart';

class EditMemberRepository implements EditMemberRepo {
  String addMemberUrl = '$APIs_URL/members/';

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
  Future<String> editMember(AddMember addMember, int userId) async {
    headerToken = await getToken();
    return await putCallService(addMemberUrl + "$userId",
        RequestType.FetchEditMember, putEditMember(addMember), headerToken);
  }
}
