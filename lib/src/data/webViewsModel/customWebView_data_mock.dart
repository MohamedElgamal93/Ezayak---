import 'dart:async';
import 'package:ezayak/src/data/user_family/add_member.dart';

import 'customWebView_data.dart';

class MockCustomWebViewRepository implements  CustomWebViewRepository {



  @override
  Future<List<CustomWebView>> fetchCustomWebViewList(int userId,String actions) {
    return new Future.value(CustomWebViewsArray);
  }

}

var CustomWebViewsArray = <CustomWebView>[

  CustomWebView(actionId: 3,url: "https://google.com",id: 1 ),
  CustomWebView(actionId: 2,url: "https://facebook.com",id: 4 ),
  CustomWebView(actionId: 4,url: "https://youtube.com",id: 3 )

];