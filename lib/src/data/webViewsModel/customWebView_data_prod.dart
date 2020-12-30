import 'dart:async';
import 'dart:convert';
import 'package:ezayak/src/app_utils.dart';
import 'package:ezayak/src/data/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:ezayak/src/data/user_family/add_member.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ezayak/src/data/error_data.dart';
import '../../../base_url.dart';
import 'customWebView_data.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ezayak/app_constants.dart';


class ProdCustomWebViewRepository implements  CustomWebViewRepository{

  String URL = "$APIs_URL/advices?";

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
  Future<List<CustomWebView>> fetchCustomWebViewList(int userId,String actions) async{
    headerToken = await getToken();

    return await getCallService(URL+"memberId=$userId&actions=$actions",
        RequestType.fetchCustomWebViewList, headerToken);

  }




}