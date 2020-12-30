import 'dart:async';

import 'package:ezayak/src/ui/login.dart';
import 'package:ezayak/src/ui/widgets/ezayakLogoWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ezayak/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppLocalizations.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    countDownTime();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
        Image.asset(
          VODAFONE_SPLASH,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        EzayakLogo(width: 160,height: 160,),
        Container(
          margin: EdgeInsets.only(top: 160),
          child: Center(
            child: Text(
              AppLocalizations.of(context).translate(Ezayak),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: VODA_RED,
                fontFamily: AR_VODAFONE_LIGHT,
                fontSize: EZYEK_FONT_SIZE,
              ),

            ),
          ),
        ),
      ]),
    );
  }

  final int splashDuration = 2;

  countDownTime() async {
    return Timer(Duration(seconds: splashDuration), () {
      SystemChannels.textInput.invokeMethod(HIDE_TEXT_INPUT);
//      if(isFirstLogin == null){
//        Navigator.of(context).pushReplacementNamed(ONBOARDING_ROUT);
//      }else{
//        Navigator.popAndPushNamed(context, LOGIN_ROUT);
//      }
      Navigator.popAndPushNamed(context, LOGIN_ROUT);
    });
  }

//  _getIsFirstLogin() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//      isFirstLogin = prefs.getBool(FIRST_LOGIN);
//    });
//  }
}
