import 'package:ezayak/src/textStyle.dart';
import 'package:ezayak/src/ui/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppLocalizations.dart';

fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

void logD(Object o) {
  assert(() {
    print(o);
    return true;
  }());
}

Future<bool> getIsFingerPrintLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool finger = prefs.getBool(FINGERPRINT_LOGIN);
  return finger;
}

saveFingerPrintLogin(bool bol) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(FINGERPRINT_LOGIN, bol);
}

Future<String> getPin() async {
  final storage = FlutterSecureStorage();
  String value = await storage.read(key: PIN);
  return value;
}

final LocalAuthentication _localAuthentication = LocalAuthentication();

Future<bool> checkBiometric() async {
  bool canCheckBiometric = false;
  try {
    canCheckBiometric = await _localAuthentication.canCheckBiometrics;
  } on PlatformException catch (e) {
    logD("canCheckBiometrics Error: $e");
  }

  return canCheckBiometric;
}

Future<int> getListOfBiometricTypes() async {
  List<BiometricType> listofBiometrics;
  try {
    listofBiometrics = await _localAuthentication.getAvailableBiometrics();
  } on PlatformException catch (e) {
    logD("getAvailableBiometrics Error: $e");
  }

  return listofBiometrics.length;
}

Container showLoadingDialog(BuildContext context) {
  return Container(
    color: Colors.black12,
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Center(child: CircularProgressIndicator()),
  );
}

bool isArabicString(String word) {
  RegExp pattern = RegExp("[ء-ي]+", caseSensitive: false);
  return pattern.hasMatch(word);
}

void navigateToLogin(
    GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) {
  showToast(scaffoldKey, "Token Expired");

  Future<Null>.delayed(Duration(seconds: 3), () {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => Login(),
            transitionsBuilder: (_, anim, __, child) => Container(child: child),
            transitionDuration: Duration(seconds: 1)),
        (route) => false);
  });
}

void showToast(GlobalKey<ScaffoldState> scaffoldKey, message) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message,
          textAlign: TextAlign.center,
          style: TextStyleBuilder.getTextStyle(fontFamily: isArabicString(message) ? AR_VODAFONE_MID : ExBd),
      )));
}

void showCustomDialog(
    {@required BuildContext context,@required String message,
      String message2 = "",
      String message3,
      int index = -1,
      int memberId = -1,
      @required String button1,
      @required String button2,
      @required Function buttonAction1,
      @required Function buttonAction2}) {
  Widget cancelButton = Container(
    width: MediaQuery.of(context).size.width * SMALL_BUTTON_WIDTH_PERCENTAGE,
    height: GENERAL_BUTTON_HEIGHT,
    child: RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS)),
      color: VODA_RED,
      onPressed: buttonAction2 != null
          ? buttonAction2
          : () {
              Navigator.of(context).pop();
            },
      child: Text(
        button2 != null ? button2 : AppLocalizations.of(context).translate(No),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: VODA_WHITE,
            fontFamily: AR_VODAFONE_MID,
            fontSize: LABEL_FONT_SIZE),
      ),
    ),
  );

  Widget confirmButton = Container(
    width: MediaQuery.of(context).size.width * SMALL_BUTTON_WIDTH_PERCENTAGE,
    height: GENERAL_BUTTON_HEIGHT,
    child: RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS)),
      color: VODA_RED,
      onPressed: buttonAction1 != null
          ? buttonAction1
          : () {
              Navigator.of(context).pop();
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
      child: Text(
        button1 != null ? button1 :AppLocalizations.of(context).translate(Yes) ,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: VODA_WHITE,
            fontFamily: AR_VODAFONE_MID,
            fontSize: LABEL_FONT_SIZE),
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: TITLE_FONT_SIZE,
                color: BLACK,
              ),
              children: <TextSpan>[
                TextSpan(
                    text:
                        message != null ? message : AppLocalizations.of(context).translate(Are_you_sure_you_want_to_close_Ezayak),
                    style: TextStyle(
                        fontFamily: AR_VODAFONE_MID,
                        fontSize: TITLE_FONT_SIZE)),
                TextSpan(
                    text:
                    message2 != null ? message2 : "",
                    style: TextStyle(
                        fontFamily: isArabicString(message2) ? AR_VODAFONE_BOLD : ExBd,
                        fontSize: TITLE_FONT_SIZE)),
                TextSpan(
                    text:
                    message3 != null ? message3 : "",
                    style: TextStyle(
                        fontFamily: AR_VODAFONE_MID,
                        fontSize: TITLE_FONT_SIZE))
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[confirmButton, cancelButton],
        ),
      );
    },
  );
}
