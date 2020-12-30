import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:ezayak/src/ui/widgets/baseScreen.dart';
import 'package:ezayak/src/ui/widgets/bottomBar.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/material.dart';

import '../../app_constants.dart';
import '../AppLocalizations.dart';
import 'chatbot.dart';
import 'help_desk.dart';
import 'landingPage.dart';

class CovidHelper extends StatefulWidget {
  CovidHelper({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CovidHelperState();
  }
}

class _CovidHelperState extends State<CovidHelper> {
  bool _isVisible = false;
  String text = '';

  List<IconView> list = [
    IconView(
      image: 'assets/fever.png',
      text: 'حمي',
      subtitle: "sasdasxa",
    ),
    IconView(
        image: 'assets/cough.png',
        text: 'كحة جافة',
        subtitle:
            "this is coough ,this is coough ,this is coough ,this is coough ,this is coough ,this is coough ,"),
    IconView(
        image: 'assets/bed.png',
        text: 'اعياء',
        subtitle:
            "this is bed ,this is bed ,this is bed ,this is bed ,this is bed ,this is bed ,"),
  ];

  int selectedSymptom;

  Widget button(String text, BuildContext context, Function route) {
    return Container(
      width: MediaQuery.of(context).size.width * BUTTON_WIDTH_PERCENTAGE,
      height: GENERAL_BUTTON_HEIGHT,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS)),
        color: Theme.of(context).primaryColor,
        onPressed: route,
        child: Text(text,
            style: TextStyle(
                fontSize: BUTTON_FONT_SIZE,
                color: VODA_WHITE,
                fontFamily: AR_VODAFONE_MID)),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return
      BaseScreen(
        onWillPop: () {
          return onWillPop(context);
        },
        topBar: MyTopBar(
          showBack: true,
          navToLandingPage: true,
        ),
        bottomBar: BottomBar(
          showProfile: true,
          showSos: false,
        ),
        child: buildContent(context),
      )


    ;
  }

  Future<bool> onWillPop(BuildContext context) {
    if(true ==_isVisible)
    {
      setState(() {
        _isVisible = false;
        selectedSymptom = null;
      });
    }else{
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LandingPage(),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)),
              (route) => false);
    }
    return Future(() => false);
  }

  Widget buildContent(BuildContext context) {
    return Container(
      height: double.infinity,
      child:
      Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildHeader(),
                showOrHideSymptoms(),
                Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildFeverWidget(),
                        buildcoughWidget(),
                      ],
                    )),

                buildBedWidget(),
                buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showOrHideSymptoms() {
    return Flexible(
                child: Visibility(
                  visible: !_isVisible ==  false ? true : false,
                  child:
                  Container(
                    margin: EdgeInsets.only(right: 8.0,left: 8.0),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
                      border: Border.all(color: GREY), color: VODA_WHITE,),

                    child: Text(
                      text,
                      softWrap: true,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontSize: LABEL_FONT_SIZE,
                          color: VODA_RED,
                          fontFamily: AR_VODAFONE_MID),
                    ),
                  ),

                ),
              );
  }

  Widget buildFeverWidget() {
    return Container(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedSymptom = 1;
                              _isVisible = true;
                              text =
                              AppLocalizations.of(context).translate(You_have_a_high_body_temperature_that_exceeds_37_4_degrees);
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                'assets/fever.png',
                                height: 50,
                                width: 50,
                                color: selectedSymptom == 1 ? VODA_RED : BLACK,
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 125,
                                child: Text(
                                  AppLocalizations.of(context).translate(Fever),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: ICON_FONT_SIZE,
                                      color: selectedSymptom == 1 ? VODA_RED : BLACK,
                                      fontFamily: AR_VODAFONE_MID),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
  }

  Widget buildBedWidget() {
    return Container(
                margin: EdgeInsets.only(right: 8.0,left: 8.0),

                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedSymptom = 3;
                      _isVisible = true;
                      text =
                      AppLocalizations.of(context).translate(You_feel_highly_exhausted_with_some_aches_and_pains);
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        'assets/bed.png',
                        height: 50,
                        width: 50,
                        color: selectedSymptom == 3 ? VODA_RED : BLACK,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 125,
                        child: Text(
                         AppLocalizations.of(context).translate(Tiredness) ,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: ICON_FONT_SIZE,
                              color: selectedSymptom == 3 ? VODA_RED : BLACK,
                              fontFamily: AR_VODAFONE_MID),
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  Widget buildcoughWidget() {
    return Container(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedSymptom = 2;
                              _isVisible = true;
                              text =
                              AppLocalizations.of(context).translate(You_have_a_continuous_dry_cough);
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                'assets/cough.png',
                                height: 50,
                                width: 50,
                                color: selectedSymptom == 2 ? VODA_RED : BLACK,
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 125,
                                child: Text(
                                 AppLocalizations.of(context).translate(Dry_cough) ,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: ICON_FONT_SIZE,
                                      color: selectedSymptom == 2 ? VODA_RED : BLACK,
                                      fontFamily: AR_VODAFONE_MID),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
  }
  Widget buildFooter(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          button(
             AppLocalizations.of(context).translate(No),
              context,
                  () => Navigator.of(context).push(
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          ChatBot(),
                      transitionsBuilder: (_, anim, __, child) =>
                          Container(child: child),
                      transitionDuration: Duration(seconds: 1)))
          ),
          button(
               AppLocalizations.of(context).translate(Yes),
              context,
                  () => Navigator.of(context).push(
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          HelpDesk(),
                      transitionsBuilder: (_, anim, __, child) =>
                          Container(child: child),
                      transitionDuration: Duration(seconds: 1)))
          ),
        ],
      ),
    );
  }

  Column buildHeader() {
    return Column(
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: TITLE_FONT_SIZE,
                          color: BLACK,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: AppLocalizations.of(context).translate(We_are_here_to_help_you),
                              style: TextStyle(
                                  fontFamily: AR_VODAFONE_MID,
                                  fontSize: TITLE_FONT_SIZE)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: SUBTITLE_FONT_SIZE,
                          color: BLACK,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: AppLocalizations.of(context).translate(Do_you_have_COVID_19_symptoms),
                              style: TextStyle(
                                  fontFamily: AR_VODAFONE_MID,
                                  fontSize: SUBTITLE_FONT_SIZE)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
  }
}

class IconView {
  final String image;
  final String text;
  final String subtitle;
  IconView({this.subtitle, this.image, this.text});
}
