import 'package:ezayak/src/app_utils.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/login_data.dart';
import 'package:ezayak/src/presenter/login_presenter.dart';
import 'package:ezayak/src/textStyle.dart';
import 'package:ezayak/src/ui/privacy.dart';
import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:ezayak/src/ui/widgets/layoutBuilder.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_constants.dart';
import '../AppLocalizations.dart';
import 'enter_finger_print.dart';
import 'landingPage.dart';

class PinScreen extends StatefulWidget {
  final String jwtToken;
  final bool userChanged;

  PinScreen(this.jwtToken, this.userChanged);

  @override
  PinScreenState createState() => PinScreenState();
}

class PinScreenState extends State<PinScreen> implements LoginContract {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  LoginPresenter _loginPresenter;
  TextEditingController pinController = TextEditingController();

  bool resendPin = false;
  bool hasPin = false;
  bool hasFingerPrint = false;
  bool _isLoading = false;
  bool _pinObsecureText = true;

  @override
  void initState() {
    super.initState();
    getPin()
        .then((pin) => {
              if (pin != null)
                {
                  setState(() {
                    hasPin = true;
                  })
                }
            })
        .catchError((err) => logD("getPin Error: $err}"));
    checkFingerPrint();

    _loginPresenter = LoginPresenter(this, pinScreenState: this);
  }

  checkFingerPrint() async {
    bool hasBiometricTypes = await getListOfBiometricTypes() != 0;
    logD("hasBiometricTypes = $hasBiometricTypes");

    bool hasBiometric = await checkBiometric();
    logD("hasBiometric =  $hasBiometric");

    if (hasBiometricTypes && hasBiometric) {
      setState(() {
        hasFingerPrint = true;
        logD("hasFingerPrint = $hasFingerPrint");
      });
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
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
                body: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: GREY), color: VODA_WHITE),
                  margin:
                      const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: buildContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: LayoutBuilderGenerator(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildTitleView(),
                  buildPinCodeView(),
                  buildResendCodeView(context),
                  buildFingerPrintView(context),
                  buildSubmitView(context),
                ],
              ),
            ),
          ],
        )));
  }

  Container buildSubmitView(BuildContext context) {
    return Container(
      height: GENERAL_BUTTON_HEIGHT,
      width: MediaQuery.of(context).size.width * LARGE_BUTTON_WIDTH_PERCENTAGE,
      child: RaisedButton(
          child: _isLoading
              ? CircularProgressIndicator(backgroundColor: VODA_WHITE)
              : Text(AppLocalizations.of(context).translate(Next),
                  style: TextStyleBuilder.getTextStyle(
                      color: VODA_WHITE,
                      fontFamily: AR_VODAFONE_BOLD,
                      fontSize: BUTTON_FONT_SIZE)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
          ),
          color: VODA_RED,
          onPressed: pinController.text.length < 4 || _isLoading
              ? null
              : () {
                  _loginPresenter.loginRequestFromPin();
                }),
    );
  }

  Visibility buildFingerPrintView(BuildContext context) {
    return Visibility(
      visible: hasFingerPrint && false == widget.userChanged && hasPin,
      child: Container(
        height: GENERAL_BUTTON_HEIGHT,
        width:
            MediaQuery.of(context).size.width * XLARGE_BUTTON_WIDTH_PERCENTAGE,
        child: RaisedButton(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: BUTTON_FONT_SIZE,
                  color: BLACK,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: AppLocalizations.of(context).translate(Enter_With_Finger_Print),
                      style: TextStyleBuilder.getTextStyle(
                          fontFamily: AR_VODAFONE_BOLD,
                          fontSize: BUTTON_FONT_SIZE)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.yellow),
            ),
            color: VODA_WHITE,
            onPressed: !resendPin
                ? () => {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  EnterFingerPrintScreen(widget.jwtToken),
                              transitionsBuilder: (_, anim, __, child) =>
                                  Container(child: child),
                              transitionDuration: Duration(seconds: 1)))
                    }
                : null),
      ),
    );
  }

  Directionality buildResendCodeView(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: GENERAL_BUTTON_HEIGHT,
        width:
            MediaQuery.of(context).size.width * XLARGE_BUTTON_WIDTH_PERCENTAGE,
        child: RaisedButton(
            child: RichText(
              text: TextSpan(
                style: TextStyleBuilder.getTextStyle(
                    fontSize: BUTTON_FONT_SIZE, color: BLACK),
                children: <TextSpan>[
                  TextSpan(
                      text: AppLocalizations.of(context).translate(Send_an_SMS_with_the_verification_code),
                      style: TextStyleBuilder.getTextStyle(
                          fontFamily: AR_VODAFONE_BOLD,
                          fontSize: BUTTON_FONT_SIZE)),
                  TextSpan(
                      text: 'SMS',
                      style: TextStyleBuilder.getTextStyle(
                          fontFamily: ExBd, fontSize: BUTTON_FONT_SIZE))
                ],
              ),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.yellow),
            ),
            color: VODA_WHITE,
            onPressed: () {
              // Resend code api
              _loginPresenter.resendPin(widget.jwtToken);
            }),
      ),
    );
  }

  Center buildPinCodeView() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 24, right: 24),
        child: PinCodeTextField(
          controller: pinController,
          autoDisposeControllers: false,
          borderWidth: 1,
          inactiveColor: GREY,
          activeColor: VODA_RED,
          length: 4,
          obsecureText: _pinObsecureText,
          animationType: AnimationType.none,
          textInputType: TextInputType.visiblePassword,
          shape: PinCodeFieldShape.box,
          animationDuration: Duration(milliseconds: 300),
          fieldHeight: 60,
          fieldWidth: 50,
          onChanged: (value) {
            setState(() {
              _pinObsecureText = false;
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  _pinObsecureText = true;
                });
              });
              //currentText = value;
            });
          },
        ),
      ),
    );
  }

  Directionality buildTitleView() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.only(left: 32, right: 32),
        child: RichText(
          text: TextSpan(
            style: TextStyleBuilder.getTextStyle(
                fontSize: TITLE_FONT_SIZE, color: BLACK),
            children: <TextSpan>[
              TextSpan(
                  text: AppLocalizations.of(context).translate(Write_down_the_verification_code),
                  style: TextStyleBuilder.getTextStyle(
                      fontFamily: AR_VODAFONE_MID, fontSize: TITLE_FONT_SIZE)),
              TextSpan(
                  text: 'SMS',
                  style: TextStyleBuilder.getTextStyle(
                      fontFamily: ExBd, fontSize: TITLE_FONT_SIZE))
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void onResendPinSuccess() {
    showToast(scaffoldKey, AppLocalizations.of(context).translate(Your_Verification_code_is_updated_successfully));
    setState(() {
      resendPin = true;
    });
  }

  @override
  void showLoading(bool b) {
    setState(() {
      _isLoading = b;
    });
  }
}
