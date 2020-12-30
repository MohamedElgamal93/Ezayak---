import 'dart:async';
import 'dart:convert';
import 'package:ezayak/src/app_utils.dart';
import 'package:ezayak/src/data/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:ezayak/src/data/user_family/add_member.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ezayak/src/data/error_data.dart';
import '../../../base_url.dart';
import 'family_data.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ezayak/app_constants.dart';


class ProdFamilyMemberRepository implements  FamilyMemberRepository{

  String familyMemberURL = "$APIs_URL/members";
  String deleteMemberUrl = "$APIs_URL/members/";

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
  Future<List<FamilyMember>> fetchFamilyMembers() async{
    headerToken = await getToken();

//    http.Response response = await http.get(familyMemberURL,headers:{
//      HttpHeaders.contentTypeHeader: APPLICATION_JSON,
//      HttpHeaders.authorizationHeader: '$BEARER $headerToken'
//    }).timeout(const Duration(seconds: 180),
//        onTimeout: () => throw ErrorResponse(message: CODE_2, error: TIME_OUT));
//    final List responseBody = json.decode(response.body);
//    final statusCode = response.statusCode;
//
//    if (statusCode != 200 || responseBody == null) {
//      throw new FetchDataExeption("Error Fetching data, [status code $statusCode]");
//    }
//    logD(responseBody.map((c)=>new AddMember.fromMap(c)).toList());
//
//    return responseBody.map((c)=>new AddMember.fromMap(c)).toList();

    return await getCallService(familyMemberURL,
        RequestType.FetchFamilyMembers, headerToken);

  }

  @override
  Future<int> deleteMember(int memberId) async {
    // TODO: implement deleteMember
    return await deleteCallService("$deleteMemberUrl$memberId",RequestType.DeleteFamilyMember,null,headerToken,);
  }

  @override
  Future<dynamic> deleteProfile(int memberId) {
    // TODO: implement deleteProfile
    return deleteCallService("$deleteMemberUrl$memberId",RequestType.DeleteMyProfile,null,headerToken,);
  }




}