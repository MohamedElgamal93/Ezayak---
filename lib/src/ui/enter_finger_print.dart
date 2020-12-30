import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/login_data.dart';
import 'package:ezayak/src/presenter/login_presenter.dart';
import 'package:ezayak/src/textStyle.dart';
import 'package:ezayak/src/ui/pin_screen.dart';
import 'package:ezayak/src/ui/privacy.dart';
import 'package:ezayak/src/ui/user_profile.dart';
import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../app_constants.dart';
import '../AppLocalizations.dart';
import '../app_utils.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'landingPage.dart';

class EnterFingerPrintScreen extends StatefulWidget {
  final String jwtToken;

  EnterFingerPrintScreen(this.jwtToken);

  @override
  EnterFingerPrintScreenState createState() => EnterFingerPrintScreenState();
}

class EnterFingerPrintScreenState extends State<EnterFingerPrintScreen>
    implements LoginContract {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  LoginPresenter _loginPresenter;
  bool isFingerPrintLogin;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _isAuthorized = false;
  bool loginSuccess = false;

  @override
  void initState() {
    super.initState();
    _loginPresenter = LoginPresenter(this,enterFingerPrintScreenState: this);
    getPin()
        .then((pin) => {_authorizeNow(pin)})
        .catchError((err) => logD("getPin Error: $err}"));
  }

  Future<void> _authorizeNow(String pin) async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to complete your transaction",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      logD("authenticateWithBiometrics Error: $e}");
    }

    if (!mounted) return;

    if (isAuthorized) {
      _loginPresenter.loginRequestFromFingerPrint(pin,widget.jwtToken);
      setState(() {
        _isAuthorized = true;
      });
    } else {
      setState(() {
        isFingerPrintLogin = false;
      });
      saveFingerPrintLogin(isFingerPrintLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        key: scaffoldKey,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              BaseBackGround(),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: MyTopBar(
                  showBack: true,
                ),
                body: buildFingerPrintView(context),
              ),
              buildEnterPinView(context)
            ],
          ),
        ),
      ),
    );
  }

  Container buildFingerPrintView(BuildContext context) {
    return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: GREY), color: VODA_WHITE),
                margin:
                    const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            !_isAuthorized
                                ? Container(
                                    child: Image.asset(
                                      FINGERPRINT,
                                      width: 100,
                                      height: 100,
                                    ),
                                    margin: EdgeInsets.only(top: 20),
                                  )
                                : Container(
                                    child: Stack(
                                      children: <Widget>[
                                        Image.asset(
                                          VFINGERPRINT,
                                          width: 100,
                                          height: 100,
                                        ),
                                        Image.asset(
                                          CORRECT,
                                          width: 100,
                                          height: 100,
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.only(top: 20),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  Center buildEnterPinView(BuildContext context) {
    return Center(
              child: Container(
                margin: EdgeInsets.only(top: 48),
                height: GENERAL_BUTTON_HEIGHT,
                width: MediaQuery.of(context).size.width *
                    XLARGE_BUTTON_WIDTH_PERCENTAGE,
                child: RaisedButton(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: BUTTON_FONT_SIZE,
                          color: BLACK,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text:  AppLocalizations.of(context).translate(Sign_in_with_the_verification_code),
                              style: TextStyleBuilder.getTextStyle(fontFamily: AR_VODAFONE_BOLD, fontSize: BUTTON_FONT_SIZE)
                          )
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.yellow),
                    ),
                    color: VODA_WHITE,
                    onPressed: !loginSuccess
                        ? () => {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          PinScreen(widget.jwtToken, false),
                                      transitionsBuilder:
                                          (_, anim, __, child) =>
                                              Container(child: child),
                                      transitionDuration:
                                          Duration(seconds: 1)))
                            }
                        : null),
              ),
            );
  }

  @override
  void onResendPinSuccess() {
    // TODO: implement onResendPinSuccess
  }
  @override
  void showLoading(bool b) {
    setState(() {
      loginSuccess = b;
    });
  }
}
