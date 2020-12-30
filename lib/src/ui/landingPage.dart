import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/moods/mood.dart';
import 'package:ezayak/src/presenter/moods_presenter.dart';
import 'package:ezayak/src/ui/moodsWidget.dart';
import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:ezayak/src/ui/widgets/bottomBar.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

import '../../app_constants.dart';
import '../AppLocalizations.dart';
import '../app_utils.dart';
import 'login.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin implements MoodsContract {

  MoodsPresenter _moodsPresenter;

  List<Moods> items = [Moods(fullName: "...")];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  var currentPage = 0;

  var _isLoading;

  BuildContext landingPageContext;


  void _showToast(message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message, textAlign: TextAlign.center,
        style: TextStyle(fontFamily: isArabicString(message)? AR_VODAFONE_MID : ExBd))));
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      landingPageContext = context;
    });
    return WillPopScope(
      onWillPop:_onWillPop,
      child: SafeArea(
        top: true,
        child: Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: <Widget>[
              BaseBackGround(),
              Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: MyTopBar(
                    showBack: true,
                    isLogout: true,
//                  showTutorial: true,
                  ),
                  bottomNavigationBar: BottomBar(
                    showProfile: true,
                    showSos: true,
                    showTutorial: true,
                    showCovid: true,
                  ),
                  body: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: GREY),
                                right: BorderSide(color: GREY),
                                left: BorderSide(color: GREY),
                              ),
                              color: VODA_WHITE),
                          child: _buildPageView()))),
            ],
          ),
        ),
      ),
    );
  }

  _buildPageView() {
    return Container(
      height: double.infinity,
      child:  Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                    itemCount: items.length,
                    controller: _pageController,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Flexible(
                              child: MoodWidget(
                                  this,
                                      (int mode) => {
                                    if (mounted)
                                      {
                                        setState(() {
                                          items[index].lastMood =
                                          mode;
                                        })
                                      }
                                  },
                                      (String error) =>
                                  {
                                    _showToast(error)
                                  }
                          )),
                        ],
                      );
                    },
                    onPageChanged: (int index) {
                      _currentPageNotifier.value = index;
                      setState(() {
                        currentPage = index;
                      });
                    }),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    CirclePageIndicator(
                      itemCount: items.length,
                      currentPageNotifier: _currentPageNotifier,
                      dotColor: GREY,
                      selectedDotColor: VODA_RED,
                    ),
                  ],
                ),
              ),
            ],
          ),
          _isLoading
              ? new Center(
              child: new CircularProgressIndicator()):Container(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _moodsPresenter = MoodsPresenter(this);
    _moodsPresenter.loadMoods();
    _isLoading = true;
  }

  @override
  void onLoadMoodsComplete(List<Moods> moods) {
    setState(() {
      moods.map((item) => {
          if(item.memberType == 1){
        items[0] = item
      }else{
      items.add(item)
      }
      } ).toList();
      _isLoading = false;
    });
  }

  @override
  void onLoadMoodsError(ErrorResponse err) async{
    setState(() {
      _isLoading = false;
    });
    if(CODE_401 == err.code){
      final storage = FlutterSecureStorage();
      await storage.delete(key: TOKEN).then((value) => {navigateToLogin(scaffoldKey, context)});

    }
    else if (err.message == CODE_1) {
      _showToast(AppLocalizations.of(context).translate(Make_sure_that_you_are_connected_to_the_internet));
    } else if (err.message == CODE_2) {
      _showToast(AppLocalizations.of(context).translate(Server_error_please_try_again) +
          LINE_BREAK +
          err.error);
    } else {
      _showToast(err.message != null ? err.message : err.key != null
          ? err.key : err.error != null ? err.error : "error");
    }
  }



  Future<bool> _onWillPop() {
    showCustomDialog(context:context);
    return Future(() => false);
  }
}

class Dependant {
  String type;
  String name;
  int lastSelectedMood;
  List<int> lastSelectedActivity;
  List<int> lastSelectedSymptoms;
  bool isVisibleActivities;
  bool isVisibleSymptoms;
  int mood;
  List<String> activities;
  List<String> symptoms;

  Dependant({
    this.type,
    this.name,
    this.lastSelectedMood,
    this.lastSelectedActivity,
    this.isVisibleActivities,
    this.isVisibleSymptoms,
    this.mood,
    this.activities,
    this.symptoms,
  });
}
