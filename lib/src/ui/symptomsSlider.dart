import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/webViewsModel/customWebView_data.dart';
import 'package:ezayak/src/presenter/webview_presenter.dart';
import 'package:ezayak/src/ui/chatbot.dart';
import 'package:ezayak/src/ui/help_desk.dart';
import 'package:ezayak/src/ui/login.dart';
import 'package:ezayak/src/ui/user_profile.dart';
import 'package:ezayak/src/ui/widgets/baseScreen.dart';
import 'dart:convert';

import 'package:ezayak/src/ui/widgets/bottomBar.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:li_webview/li_webview.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

import '../../app_constants.dart';
import '../app_utils.dart';

class Symptoms extends StatefulWidget {
  int id;
  List<int> actions = [];
  int type;
  var shouldShow = false;
  final Set<void> Function() removeActions;


  Symptoms({this.id, this.actions, this.type, this.removeActions});

  @override
  SymptomsState createState() => SymptomsState();
}

class SymptomsState extends State<Symptoms>
    implements CustomWebViewListContract {

  CustomWebViewListPresenter _presenter;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<CustomWebView> webviewsList = [];
  bool isLoading;
  String ActionArray = "";
  WebController webController;

  var myItems = [];

  SymptomsState() {
    _presenter = new CustomWebViewListPresenter(this);

  }


  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  var currentPage = 0;

  @override
  void initState() {
    super.initState();

    _presenter.loadCustomWebViews(widget.id, this);

  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      bottomMargin: 0,

      scaffoldKey: scaffoldKey,
      topBar: MyTopBar(
        showBack: true,
      ),
      bottomBar: BottomBar(
        showProfile: true,
        showSos: true,
        navigateToChatbot: widget.shouldShow ? true : false,
      ),
      child: _buildPageView(),
    );

  }

  _buildPageView() {
    return Stack(
      children: <Widget>[
        buildArrowIndicator(),
        buildWebView(),
      ],
    );
  }

  Widget buildWebView() {
    return Container(
        margin: EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CirclePageIndicator(
            itemCount: webviewsList.length,
            currentPageNotifier: this._currentPageNotifier,
            dotColor: GREY,
            selectedDotColor: VODA_RED,
          ),
        ),
      );
  }

  Widget buildArrowIndicator() {
    return ArrowPageIndicator(
        itemCount: webviewsList.length,
        currentPageNotifier: _currentPageNotifier,
        pageController: _pageController,
        isInside: true,
        child: Container(
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: webviewsList.length,
            itemBuilder: (BuildContext context, int index) {
              return myItems[index];
            },
            onPageChanged: (int index) {
              logD("index: $index");
              _currentPageNotifier.value = index;
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
      );
  }



  void showError(String error) {
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          error,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: isArabicString(error)? AR_VODAFONE_MID : ExBd)
        ),
      ),
    );
  }
}
