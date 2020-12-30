import 'package:ezayak/src/textStyle.dart';
import 'package:ezayak/src/ui/user_profile.dart';
import 'package:ezayak/src/ui/widgets/baseScreen.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:li_webview/li_webview.dart';

import '../../app_constants.dart';
import '../AppLocalizations.dart';
import '../app_utils.dart';
import 'login.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _checkValue = false;

  bool canProceed = false;
  WebController webController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onWillPop: _onWillPop,
      topBar: MyTopBar(
        showBack: true,
        isLogout: true,
      ),
      child: buildContent(context),bottomMargin: 16,);
  }

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildTitleView(),
        _buildWebView(),
        _checkboxButton(AppLocalizations.of(context).translate(Next), _checkValue),
        _buildSubmitView(context)
      ],
    );
  }

  Container _buildTitleView() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: RichText(
          text: TextSpan(
            style: TextStyleBuilder.getTextStyle(fontSize: TITLE_FONT_SIZE, color: BLACK),
            children: <TextSpan>[
              TextSpan(
                  text: AppLocalizations.of(context).translate(Your_privacy_matters_Read_this_privacy_policy_first),
                  style: TextStyleBuilder.getTextStyle(fontFamily: AR_VODAFONE_MID, fontSize: TITLE_FONT_SIZE)
              )
            ],
          ),
          textAlign: TextAlign.center,
        ),
      );
  }

  Expanded _buildWebView() {
    return Expanded(
        child: Container(
            color: LITE_GREY,
            child: LiWebView(onWebCreated: (webController) {
              this.webController = webController;
              this.webController.loadUrl(
                  "https://digital.vodafone.com.eg/ezayak/ezayakstatic/");
            })),
      );
  }

  Padding _buildSubmitView(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width *
                LARGE_BUTTON_WIDTH_PERCENTAGE,
            height: GENERAL_BUTTON_HEIGHT,
            child: RaisedButton(
                child: Text(
                 AppLocalizations.of(context).translate(Next) ,
                  style: TextStyle(
                    fontFamily: AR_VODAFONE_BOLD,
                    color: VODA_WHITE,
                    fontSize: BUTTON_FONT_SIZE,
                  ),
                  textAlign: TextAlign.center,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
                ),
                color: VODA_RED,
                onPressed: canProceed
                    ? () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => UserProfile(
                                      title: AppLocalizations.of(context).translate(Introduce_yourself),
                                      isEditing: false,
                                      locationEditing: 0,
                                    ),
                                transitionsBuilder: (_, anim, __, child) =>
                                    Container(child: child),
                                transitionDuration: Duration(seconds: 1)));
                      }
                    : null),
          ),
        ),
      );
  }

  Container _checkboxButton(String title, bool value) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerRight,
                child: Checkbox(
                  value: value,
                  onChanged: (bool v) => _checkboxOnChange(v),
                  activeColor: VODA_RED,
                )),
            Positioned(
              top: 12,
              right: 40,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AR_VODAFONE_BOLD,
                  color: BLACK,
                  fontSize: BUTTON_FONT_SIZE,
                ),
              ),
            )
          ],
        ));
  }

  void _checkboxOnChange(bool value) {
    setState(() {
      _checkValue = value;
    });

    logD("Privacy confirmation: $value}");
    if (value) {
      setState(() {
        canProceed = true;
      });
    } else {
      setState(() {
        canProceed = false;
      });
    }
  }

  Future<bool> _onWillPop() {
    showCustomDialog(context:context);
    return Future(() => false);
  }
}
