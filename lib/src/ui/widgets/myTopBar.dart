import 'package:ezayak/app_constants.dart';
import 'package:ezayak/src/ui/landingPage.dart';
import 'package:ezayak/src/ui/widgets/ezayakLogoWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../AppLocalizations.dart';
import '../login.dart';
import '../onBoardingPage.dart';

class MyTopBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showBack;
  final bool navToLandingPage;
  final bool showTutorial;
  final bool isLogout;

  @override
  final Size preferredSize;

  MyTopBar({@required this.showBack, this.navToLandingPage, this.showTutorial, this.isLogout})
      : preferredSize = Size.fromHeight(53.0);

  @override
  _MyTopBar createState() => _MyTopBar();
}

class _MyTopBar extends State<MyTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              VF_ICON ,
              height: 32,
              width: 32,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: EzayakLogo(height: 50,width: 50,),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Visibility(
              visible: widget.showBack,
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  if (true == widget.navToLandingPage) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => LandingPage(),
                            transitionsBuilder: (_, anim, __, child) =>
                                Container(child: child),
                            transitionDuration: Duration(seconds: 1)),(route)=>false);
                  } else {
                    if(true == widget.isLogout){
                      _deleteToken();
//                      Navigator.pushAndRemoveUntil(
//                          context,
//                          PageRouteBuilder(
//                              pageBuilder: (_, __, ___) => Login(),
//                              transitionsBuilder: (_, anim, __, child) =>
//                                  Container(child: child),
//                              transitionDuration: Duration(seconds: 1)),(route)=>false);
                    }else{
                      Navigator.of(context).pop();
                    }

                  }
                },
                icon: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      true == widget.isLogout ?AppLocalizations.of(context).translate(Exit) :AppLocalizations.of(context).translate(Back),
                      style: TextStyle(
                          color: VODA_RED,
                          fontFamily: AR_VODAFONE_MID,
                          fontSize: BUTTON_FONT_SIZE),
                    ),
                  ),
                ),
              ),
            ),
          ),
//          Align(
//            alignment: Alignment.centerLeft,
//            child: Visibility(
//              visible: widget.showTutorial!=null?true:false,
//              child: IconButton(
//                padding: EdgeInsets.all(0),
//                onPressed: () {
//                  Navigator.push(
//                      context,
//                      PageRouteBuilder(
//                          pageBuilder: (_, __, ___) => OnBoardingPage(willPop: true,),
//                          transitionsBuilder: (_, anim, __, child) =>
//                              Container(child: child),
//                          transitionDuration: Duration(seconds: 1)));
//                },
//                icon: Align(
//                  alignment: Alignment.centerLeft,
//                  child: Image.asset(
//                    TUTORIAL ,
//                    color: VODA_RED,
//                    height: 30,
//                    width: 30,
//                    fit: BoxFit.cover,
//                  ),
//                ),
//              ),
//            ),
//          )
        ],
      ),
    );
  }

  _deleteToken() async{
    final storage = FlutterSecureStorage();
    await storage.delete(key: TOKEN).then((value) => {
    Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
    pageBuilder: (_, __, ___) => Login(),
    transitionsBuilder: (_, anim, __, child) =>
    Container(child: child),
    transitionDuration: Duration(seconds: 1)),(route)=>false)
    });

  }
}
