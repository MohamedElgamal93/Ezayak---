import 'package:ezayak/app_constants.dart';
import 'package:ezayak/src/ui/ProfilesHomePage.dart';
import 'package:ezayak/src/ui/covid_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ezayak/src/ui/onBoardingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppLocalizations.dart';
import '../chatbot.dart';

class BottomBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showSos;
  final bool showProfile;
  final bool showCovid;
  final bool callEmergency;
  final bool navigateToChatbot;
  final bool showTutorial;

  @override
  final Size preferredSize;

  BottomBar(
      {@required this.showSos,
      @required this.showProfile,
      this.showCovid,
      this.callEmergency,
      this.navigateToChatbot,
      this.showTutorial
      })
      : preferredSize = Size.fromHeight(40.0);

  @override
  _BottomBa createState()=>_BottomBa();




}
class _BottomBa extends State<BottomBar>{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height /12,
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: VODA_RED,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 80,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed:widget.showSos? (){
                    setState(() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => CovidHelper(),
                              transitionsBuilder: (_, anim, __, child) =>
                                  Container(child: child),
                              transitionDuration: Duration(seconds: 1)),(route)=>false);
                    });
                  }:null,
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        SOS,
                        height: 22,
                        width: 22,
                        fit: BoxFit.cover,
                      ),
                      FittedBox(
                        child: Text(AppLocalizations.of(context).translate(I_need_emergency_support),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AR_VODAFONE_MID,
                            color: VODA_WHITE,
                            fontSize: SMALL_ICON_FONT_SIZE,),),
                      ),
                    ],
                  ),
                ),
              )),
          Visibility(
            visible: false,
//              visible: true == widget.showCovid,
            child: Align(
              alignment: Alignment.center,
              child:Container(
                width: 120,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: (){},
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        CORONA,
                        height: 22,
                        width: 22,
                        color: VODA_WHITE,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: VODA_WHITE,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context).translate(I_want_to_know_more_about_COVID),
                                  style: TextStyle(
                                      fontFamily: AR_VODAFONE_MID,
                                      fontSize: ICON_FONT_SIZE)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: true == widget.showTutorial,
            child: Align(
              alignment: Alignment.center,
              child:Container(
                width: 140,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: (){
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => OnBoardingPage(),
                            transitionsBuilder: (_, anim, __, child) =>
                                Container(child: child),
                            transitionDuration: Duration(seconds: 1)));
                  },
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        TUTORIAL,
                        height: 22,
                        width: 22,
                        color: VODA_WHITE,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: VODA_WHITE,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context).translate(App_tutorial),
                                  style: TextStyle(
                                      fontFamily: AR_VODAFONE_MID,
                                      fontSize: ICON_FONT_SIZE)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: true == widget.callEmergency,
            child: Align(
              alignment: Alignment.center,
              child:Container(
                width: 120,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: (){
                    _launchURL();
                  },
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.phone,
                        color: VODA_WHITE,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: FittedBox(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: VODA_WHITE,
                              ),
                              children: <TextSpan>[
                            TextSpan(
                                  text: AppLocalizations.of(context).translate(I_want_to_contact),
                                  style: TextStyle(
                                      fontFamily: AR_VODAFONE_MID,
                                      fontSize: ICON_FONT_SIZE)),
                                TextSpan(
                                    text: "HSW HelpDesk",
                                    style: TextStyle(
                                        fontFamily: ExBd,
                                        fontSize: ICON_FONT_SIZE))
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: true == widget.navigateToChatbot,
            child: Align(
              alignment: Alignment.center,
              child:Container(
                width: 140,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: (){
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ChatBot(),
                            transitionsBuilder: (_, anim, __, child) =>
                                Container(child: child),
                            transitionDuration: Duration(seconds: 1)));
                  },
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.help_outline,
                        color: VODA_WHITE,
                      ),
                      SizedBox(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: VODA_WHITE,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                                text: AppLocalizations.of(context).translate(I_need_more_support),
                                style: TextStyle(
                                    fontFamily: AR_VODAFONE_MID,
                                    fontSize: ICON_FONT_SIZE)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              padding: EdgeInsets.all(0),
                onPressed:widget.showProfile? (){
                  setState(() {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ProfilesHomePage(),
                            transitionsBuilder: (_, anim, __, child) =>
                                Container(child: child),
                            transitionDuration: Duration(seconds: 1)),(route)=>false);
                  });
                }:null,
              icon: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      PROFILE,
                      height: 22,
                      width: 22,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(
                    child: FittedBox(
                            child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: VODA_WHITE,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: AppLocalizations.of(context).translate(My_profile),
                              style: TextStyle(
                                  fontFamily: AR_VODAFONE_MID,
                                  fontSize: ICON_FONT_SIZE)),
                        ],
                      ),
                      textAlign: TextAlign.center)
                    )
              ,
                  ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  _launchURL() async {
    const String num = "82525";
    const url = 'tel:$num';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
