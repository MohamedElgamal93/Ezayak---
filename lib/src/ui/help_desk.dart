import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:ezayak/src/ui/widgets/baseScreen.dart';
import 'package:ezayak/src/ui/widgets/bottomBar.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_constants.dart';
import '../AppLocalizations.dart';

class HelpDesk extends StatelessWidget {
  const HelpDesk({Key key}) : super(key: key);

  Widget button(String text, BuildContext context, Function call) {
    return Container(
      width: MediaQuery.of(context).size.width * LARGE_BUTTON_WIDTH_PERCENTAGE,
      height: GENERAL_BUTTON_HEIGHT,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS)),
        color: VODA_RED,
        onPressed: call,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: FittedBox(
              child: Text(text,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: BUTTON_FONT_SIZE,
                      color: VODA_WHITE,
                      fontFamily: AR_VODAFONE_MID)),
            )),
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

  @override
  Widget build(BuildContext context) {
    return
      BaseScreen(
        bottomMargin: 0,

        topBar: MyTopBar(
          showBack: true,
        ),
        bottomBar: BottomBar(
          showProfile: true,
          showSos: true,
        ),
        child: buildContent(context),
      );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          middleContent(context),
          button(AppLocalizations.of(context).translate(Click_here_to_start_the_call), context, () {
            _launchURL();
          }),
        ],
      ),
    );
  }

  Widget middleContent(BuildContext context ){
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
                    text:AppLocalizations.of(context).translate(Donot_panic_We_are_here_for_you),
                    style: TextStyle(
                        fontFamily: AR_VODAFONE_MID,
                        fontSize: TITLE_FONT_SIZE)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 8,
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
                    text:AppLocalizations.of(context).translate(We_are_connecting_you_now_with) ,
                    style: TextStyle(
                        fontFamily: AR_VODAFONE_MID,
                        fontSize: SUBTITLE_FONT_SIZE)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 8,
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
                    text: "HSW HelpDesk",
                    style: TextStyle(
                        fontFamily: ExBd, fontSize: SUBTITLE_FONT_SIZE)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 8,
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
                    text: AppLocalizations.of(context).translate(For_immediate_support_and_care),
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
