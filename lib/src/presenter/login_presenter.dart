import 'package:ezayak/app_constants.dart';
import 'package:ezayak/dependency_injection.dart';
import 'package:ezayak/src/app_utils.dart';
import 'package:ezayak/src/data/ResendPinCodeRepoSitory.dart';
import 'package:ezayak/src/data/authenticate_data.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/login_data.dart';
import 'package:ezayak/src/data/login_repository.dart';
import 'package:ezayak/src/ui/enter_finger_print.dart';
import 'package:ezayak/src/ui/landingPage.dart';
import 'package:ezayak/src/ui/login.dart';
import 'package:ezayak/src/ui/pin_screen.dart';
import 'package:ezayak/src/ui/privacy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticateContract {
//  void onLoadAuthenticateSuccess (dynamic screen);
//
//  void onErrorAuthenticate(ErrorResponse errResponse);

  void isLoading(bool loading);
}

abstract class LoginContract {
  //void onLoadLoginSuccess(LoginResponse loginResponse);

  //void onErrorLogin(ErrorResponse errorResponse);

  void showLoading(bool b);
  void onResendPinSuccess();
}

class LoginPresenter {
  LoginContract _view;
  LoginRepository _repository;
  ResendPinRepository _pinRepository;
  PinScreenState pinScreenState;
  EnterFingerPrintScreenState enterFingerPrintScreenState;
  bool isFingerPrintLogin;

  LoginPresenter(this._view, {this.pinScreenState,this.enterFingerPrintScreenState}) {
    _repository = Injector().loginRepository;
    _pinRepository = Injector().resendPinRepository;
    getIsFingerPrintLogin()
        .then((onValue) => {
        isFingerPrintLogin = onValue
    })
        .catchError(
            (onError) => logD("getIsFingerPrintLogin Error: $onError}"));
  }

  void loadLogin(LoginRequestModel login, String headerToken) {
    _repository
        .fetchLoginToken(login, headerToken)
        .then(
            (c) => pinScreenState != null? _handleLoginSuccess(c.jwttoken, c.phoneNumber, c.firstLogin):_handleLoginSuccessFromEnterFingerPrint(c.jwttoken, c.phoneNumber,c.firstLogin))
        .catchError((onError) => onError is FlutterError
            ? handleLoginError(ErrorResponse(message: onError.message))
            : onError is AssertionError
                ? handleLoginError(ErrorResponse(message: onError.message))
                : handleLoginError(onError));
  }


  void acceptOrRejectFingerPrintLogin(
      bool acceptance, bool firstLogin, BuildContext context) {
      isFingerPrintLogin = acceptance;
    saveFingerPrintLogin(isFingerPrintLogin);
    if (firstLogin) {
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => PrivacyScreen(),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)),
              (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LandingPage(),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)),
              (route) => false);
    }
  }
  _handleLoginSuccessFromEnterFingerPrint(String token,String phoneNumber,bool firstLogin) async {
    _saveToken(token, phoneNumber);
    bool hasBiometricTypes = await getListOfBiometricTypes() != 0;
    bool hasBiometric = await checkBiometric();

    if (hasBiometricTypes &&
        hasBiometric &&
        (false == isFingerPrintLogin || null == isFingerPrintLogin)) {
      showCustomDialog(context:enterFingerPrintScreenState.context,
          message: 'تحب تدخل بعد كدة عن طريق البصمة؟',
          button1: 'مش موافق',
          buttonAction1:
              ()=>{acceptOrRejectFingerPrintLogin(false, firstLogin, enterFingerPrintScreenState.context)},
          button2: 'موافق',
          buttonAction2:
              ()=>{acceptOrRejectFingerPrintLogin(true, firstLogin, enterFingerPrintScreenState.context)});
    } else {
      if (firstLogin) {
        Navigator.pushAndRemoveUntil(
            enterFingerPrintScreenState.context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => PrivacyScreen(),
                transitionsBuilder: (_, anim, __, child) =>
                    Container(child: child),
                transitionDuration: Duration(seconds: 1)),(route)=>false);
      } else {
        Navigator.pushAndRemoveUntil(
            enterFingerPrintScreenState.context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => LandingPage(),
                transitionsBuilder: (_, anim, __, child) =>
                    Container(child: child),
                transitionDuration: Duration(seconds: 1)),(route)=>false);
      }
    }
  }
  _handleLoginSuccess(String jwttoken, String phoneNumber, bool firstLogin) {
    _view.showLoading(false);
    _saveTokenAndPin(jwttoken, phoneNumber);
    _saveFirstLogin(firstLogin);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (firstLogin) {
      Navigator.pushAndRemoveUntil(
          pinScreenState.context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => PrivacyScreen(),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          pinScreenState.context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LandingPage(),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)),
          (route) => false);
    }
  }

  handleLoginError(ErrorResponse errorResponse) {
    if (CODE_401 == errorResponse.code) {
      navigateToLogin(pinScreenState!=null?pinScreenState.scaffoldKey:enterFingerPrintScreenState.scaffoldKey, pinScreenState != null ? pinScreenState.context : enterFingerPrintScreenState.context);
    }else if(KEY_INVALID_PINCODE == errorResponse.key && enterFingerPrintScreenState != null){
      showToast(enterFingerPrintScreenState.scaffoldKey,errorResponse.key);

      Future<Null>.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          pinScreenState != null ? pinScreenState.context : enterFingerPrintScreenState.context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => PinScreen(enterFingerPrintScreenState.widget.jwtToken, false),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)),
        );
      });
    }  else if (errorResponse.message == CODE_1) {
      //pinScreenState!=null? pinScreenState.showToast('اتأكد انك واصل بالانترنت'):enterFingerPrintScreenState.showToast('اتأكد انك واصل بالانترنت');
      showToast(pinScreenState != null ? pinScreenState.scaffoldKey:enterFingerPrintScreenState.scaffoldKey,'تأكد انك واصل بالانترنت');
    } else if (errorResponse.message == CODE_2) {
//      pinScreenState!=null? pinScreenState.showToast('مشكلة في الوصول للسيرفر حاول مرة تانية' +
//          LINE_BREAK +
//          errorResponse.error) : enterFingerPrintScreenState.showToast('مشكلة في الوصول للسيرفر حاول مرة تانية' +
//          LINE_BREAK +
//          errorResponse.error);
      
      showToast(pinScreenState != null ? pinScreenState.scaffoldKey:enterFingerPrintScreenState.scaffoldKey, 'مشكلة في الوصول للسيرفر حاول مرة تانية'+
          LINE_BREAK +
          errorResponse.error);
    } else {
      showToast(pinScreenState !=null ? pinScreenState.scaffoldKey:enterFingerPrintScreenState.scaffoldKey,errorResponse.message != null
          ? errorResponse.message
          : errorResponse.key != null
              ? errorResponse.key
              : errorResponse.error != null ? errorResponse.error : "error");
    }
    _view.showLoading(false);
  }

  void resendPin(String headerToken) {
    _pinRepository
        .fetchPin(headerToken)
        .then((c) => _view.onResendPinSuccess())
        .catchError((onError) => onError is FlutterError
            ? handleLoginError(ErrorResponse(message: onError.message))
            : onError is AssertionError
                ? handleLoginError(ErrorResponse(message: onError.message))
                : handleLoginError(onError));
  }

  _saveTokenAndPin(String token, String phoneNumber) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: TOKEN, value: token);
    await storage.write(key: PIN, value: pinScreenState.pinController.text);
    await storage.write(key: PHONENUMBER, value: phoneNumber);
  }
  _saveToken(String token, String phoneNumber) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: TOKEN, value: token);
    await storage.write(key: PHONENUMBER, value: phoneNumber);
  }

  _saveFirstLogin(bool b) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(FIRST_LOGIN, b);
  }
  loginRequestFromFingerPrint(String pin,String token) {
    LoginRequestModel login = LoginRequestModel(pinCode: pin);
    loadLogin(login, token);
  }

  loginRequestFromPin() {
    _view.showLoading(true);
    if (pinScreenState.pinController.text.isNotEmpty) {
      LoginRequestModel login = LoginRequestModel(pinCode: pinScreenState.pinController.text);
      loadLogin(login, pinScreenState.widget.jwtToken);
    } else {
      _view.showLoading(true);
      showToast(pinScreenState.scaffoldKey,'اكتب الرمز');
    }
  }
}

class AuthenticatePresenter {
  AuthenticateContract _view;
  AuthenticateRepository _repository;
  LoginState state;
  bool _isFingerPrintLogin;

  AuthenticatePresenter(this._view, LoginState state) {
    _repository = Injector().authenticateRepository;
    this.state = state;
    getIsFingerPrintLogin()
        .then((onValue) => _isFingerPrintLogin = onValue)
        .catchError((onError) => logD('getIsFingerPrintLogin Error $onError'));
  }

  void loadAuthenticate(AuthenticateRequest authenticate) async {
    _repository
        .fetchAuthenticateToken(authenticate)
        .then((c) => _handleSuccess(c.jwtToken))
        .catchError((onError) => onError is FlutterError
            ? handleError(ErrorResponse(message: onError.message))
            : onError is AssertionError
                ? handleError(ErrorResponse(message: onError.message))
                : handleError(onError));
  }

  handleError(ErrorResponse errorResponse) {
    _view.isLoading(false);
    if (CODE_401 == errorResponse.code) {
      navigateToLogin(state.scaffoldKey, state.context);
    } else if (errorResponse.message == CODE_1) {
      showToast(state.scaffoldKey, 'اتأكد انك واصل بالانترنت');
      //state.showToast('اتأكد انك واصل بالانترنت');
    } else if (errorResponse.message == CODE_2) {
      showToast(state.scaffoldKey, 'مشكلة في الوصول للسيرفر حاول مرة تانية' +
          LINE_BREAK +
          errorResponse.error);
//      state.showToast('مشكلة في الوصول للسيرفر حاول مرة تانية' +
//          LINE_BREAK +
//          errorResponse.error);
    } else {
      showToast(state.scaffoldKey, errorResponse.message != null
          ? errorResponse.message
          : errorResponse.key != null
          ? errorResponse.key
          : errorResponse.error != null ? errorResponse.error : "error");
//      state.showToast(errorResponse.message != null
//          ? errorResponse.message
//          : errorResponse.key != null
//              ? errorResponse.key
//              : errorResponse.error != null ? errorResponse.error : "error");
    }
  }

  _handleSuccess(String jwtToken) async {
    _view.isLoading(false);
    final storage = FlutterSecureStorage();
    String vodafonerUser = await storage.read(key: LAST_VODAFONER_USER);
    if (vodafonerUser != state.userNameController.text) {
      _navigateTo(PinScreen(jwtToken, true));
    } else {
      if (true == _isFingerPrintLogin) {
        _navigateTo(EnterFingerPrintScreen(jwtToken));
      } else {
        _navigateTo(PinScreen(jwtToken, false));
      }
    }
    await storage.write(
        key: LAST_VODAFONER_USER, value: state.userNameController.text);
  }

  _navigateTo(dynamic screen) {
    Navigator.push(
        state.context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => screen,
            transitionsBuilder: (_, anim, __, child) => Container(child: child),
            transitionDuration: Duration(seconds: 1)));
  }

  handleLoginButton() {
    SystemChannels.textInput.invokeMethod(HIDE_TEXT_INPUT);
    if (state.userNameController.text.isNotEmpty &&
        state.passwordController.text.isNotEmpty) {
      getAuthenticationResponse();
    } else {
      showToast(state.scaffoldKey, 'بلييز اكتب البيانات كلها)');
      //state.showToast('بلييز اكتب البيانات كلها');
    }
  }

  void getAuthenticationResponse() async {
    _view.isLoading(true);
    AuthenticateRequest authenticate = AuthenticateRequest(
        username: state.userNameController.text, password: state.passwordController.text);
    loadAuthenticate(authenticate);
  }
}
