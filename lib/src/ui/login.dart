import 'dart:async';
import 'dart:math';

import 'package:ezayak/app_constants.dart';
import 'package:ezayak/src/data/authenticate_data.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/error_localization/data/model/error_localization_data.dart';
import 'package:ezayak/src/presenter/login_presenter.dart';
import 'package:ezayak/src/textStyle.dart';
import 'package:ezayak/src/ui/pin_screen.dart';
import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:ezayak/src/ui/widgets/ezayakLogoWidget.dart';
import 'package:ezayak/src/ui/widgets/layoutBuilder.dart';
import 'package:ezayak/src/ui/widgets/loginTextFieldWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ezayak/src/AppLocalizations.dart';

import '../AppLanguage.dart';
import '../app_utils.dart';
import 'enter_finger_print.dart';


class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> implements AuthenticateContract {
  bool obscureText = true;
  bool userChanged = false;
  int _groupValue ;
  int choice;
  bool canProceed = false;

  LoginState() {
    presenter = AuthenticatePresenter(this, this);
  }

  static List<ErrorLocalization> list;
  AuthenticatePresenter presenter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController oTPController = TextEditingController();
  final FocusNode userNameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool _isLoading = false;
  bool _isFingerPrintLogin;
  bool _enableButton = false;
  final notifications = FlutterLocalNotificationsPlugin();
  List<String> _notificationMessages = List();
  final _random = new Random();
  AppLanguage appLanguage ;

  @override
  void initState() {
    super.initState();
    _saveNotificationMessages();

    getUser();
    setState(() {
      getIsFingerPrintLogin()
          .then((onValue) => _isFingerPrintLogin = onValue)
          .catchError(
              (onError) => logD('getIsFingerPrintLogin Error $onError'));
    });

    userNameController.addListener(controlListener);
    passwordController.addListener(controlListener);
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    oTPController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLanguage = Provider.of<AppLanguage>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
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
                buildScreenHeader(),
                buildScreenHeaderSetting(),
                buildScreen(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Align buildScreenHeader() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 14),
        child: Image.asset(
          VODAFONE_SMALL,
          height: 60,
          width: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  Align buildScreenHeaderSetting(){
        return Align(
      alignment: Alignment.topLeft,
      child: Container(
        child: IconButton(
        padding: EdgeInsets.only(top: 7, left: 7),
        icon: Image.asset(
          SETTING,
          height: 35,
          width: 35,
          
          fit: BoxFit.cover,),
                onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                elevation: 16,
                child: Container(
                  height: 210.0,
                  width: 150.0,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          AppLocalizations.of(context).translate(CHANGE_LANGUAGE),
                          style: TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      _radioButtons( AppLocalizations.of(context).translate(ENGLISH_LANGUAGE), 1),
                      _radioButtons(AppLocalizations.of(context).translate(Arabic_LANGUAGE), 2),
                      
                    ],
                  ),
                ),
              );
            },      
          );
        },
        ),
      ),
      
    );

  }

  Positioned buildScreen(BuildContext context) {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: GREY), color: Colors.white60),
        margin: const EdgeInsets.only(top: 90, bottom: 10, left: 10, right: 10),
        child: Column(
          children: <Widget>[
            Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: LayoutBuilderGenerator(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildHeader(context),
                      buildScreenBody(context),
                      buildLoginButton(context),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Container buildHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          SizedBox(height: 16),
          EzayakLogo(
            height: 130,
          ),
          SizedBox(height: 8),
          buildEzayakTitle(),
          SizedBox(height: 8),
          buildTitle(),
        ],
      ),
    );
  }

  Column buildScreenBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildBodyContent(
            context, buildLoginTextFiled(context, this), Container()),
        SizedBox(height: 8),
        buildBodyContent(context, buildPasswordLoginTextFiled(context, this),
            buildShowPasswordIcon()),
      ],
    );
  }

  Container buildBodyContent(
      BuildContext context, Widget containerChild, Widget child) {
    return Container(
        margin: EdgeInsets.only(left: 40, right: 20),
        child: Stack(
          children: <Widget>[
            Container(
              child:
                  containerChild, //buildPasswordLoginTextFiled(context, this),
              padding: EdgeInsets.only(right: 40),
            ),
            child, //buildShowPasswordIcon(),
          ],
        ));
  }

  Row buildShowPasswordIcon() {
    return Row(
       textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 8.0),
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.remove_red_eye,
                color: obscureText ? GREY : VODA_RED),
            onPressed: () => {
              if (passwordController.text.isNotEmpty)
                {
                  setState(() {
                    obscureText = !obscureText;
                  })
                }
            },
          ),
        ),
      ],
    );
  }

  Padding buildLoginButton(BuildContext context) {
    return Padding(
      
      padding: const EdgeInsets.all(16.0),
      child: Align(
        child: Container(
          width:
              MediaQuery.of(context).size.width * LARGE_BUTTON_WIDTH_PERCENTAGE,
          height: GENERAL_BUTTON_HEIGHT,
          child: RaisedButton(
              child: _isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: VODA_WHITE,
                    )
                  : Text( AppLocalizations.of(context).translate(Lets_go),
                      style: TextStyleBuilder.getTextStyle(
                          color: VODA_WHITE,
                          fontFamily: AR_VODAFONE_BOLD,
                          fontSize: BUTTON_FONT_SIZE)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
              ),
              color: VODA_RED,
              onPressed: !_enableButton || _isLoading
                  ? null
                  : () {
                      presenter.handleLoginButton();
                    }),
        ),
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Center buildEzayakTitle() {
    return Center(
      child: Text(
        AppLocalizations.of(context).translate(Ezayak),
        textAlign: TextAlign.center,
        style: TextStyleBuilder.getTextStyle(
            color: VODA_RED,
            fontFamily: AR_VODAFONE_MID,
            fontSize: EZYEK_FONT_SIZE),
      ),
    );
  }

  Center buildTitle() {
    return Center(
      child: Text(
       AppLocalizations.of(context).translate(Stay_safe_every_day) ,
        textAlign: TextAlign.center,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyleBuilder.getTextStyle(
            color: BLACK,
            fontFamily: AR_VODAFONE_MID,
            fontSize: TITLE_FONT_SIZE),
      ),
    );
  }

  controlListener() {
    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      setState(() {
        _enableButton = true;
      });
    } else {
      setState(() {
        _enableButton = false;
      });
    }
  }

  getUser() async {
    final storage = FlutterSecureStorage();
    String vodafonerUser = await storage.read(key: LAST_VODAFONER_USER);
    if (vodafonerUser != null) {
      setState(() {
        userNameController.text = vodafonerUser;
      });
    }
  }

  void initNotification() {
    final settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings();
    notifications
        .initialize(InitializationSettings(settingsAndroid, settingsIOS));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    Time releaseTime = Time(10, 00, 0);

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    notifications.showDailyAtTime(0, EZAYAK, _notificationMessages[next(0, 4)],
        releaseTime, platformChannelSpecifics);
  }

  _saveNotificationMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> messages = List();
    messages.add(AppLocalizations.of(context).translate(First_Notifi));
    messages.add(AppLocalizations.of(context).translate(Second_Notifi));
    messages.add(AppLocalizations.of(context).translate(Third_Notifi));
    messages.add(AppLocalizations.of(context).translate(Fouth_Notifi));
    messages.add(AppLocalizations.of(context).translate(Five_Notifi));
    messages.add(AppLocalizations.of(context).translate(Sex_Notifi));
    messages.add(AppLocalizations.of(context).translate(Seven_Notifi));
    messages.add(AppLocalizations.of(context).translate(Eight_Notifi));
    await prefs.setStringList(NOTIFICATION_MESSAGE, messages);
    setState(() {
      _notificationMessages = prefs.getStringList(NOTIFICATION_MESSAGE);
    });
    initNotification();
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  Future<bool> _onWillPop() {
    showCustomDialog(context:context);
    return Future(() => false);
  }

  @override
  void isLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }




  
   Container _radioButtons(String title, int value) {
       if (appLanguage.appLocal == Locale(EN)) {
         _groupValue = 1 ;
       }else if (appLanguage.appLocal == Locale(AR)) {
        _groupValue = 2 ;
       }

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Radio(
                  value: value,
                  groupValue: _groupValue,
                  onChanged: (int v) => _radioOnChange(v),
                  activeColor: VODA_RED,
                )),

            Positioned(
              
              top: 12,
              left: 40,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: BOLD_FONT,
                  color: BLACK,
                  fontSize: BUTTON_FONT_SIZE,
                ),
              ),
            )
          ],
        ));
  }
  void _radioOnChange(int value) {
    setState(() {
      _groupValue = value;
     
   switch (value) {
        case 1:
          choice = value;
          break;
        case 2:
          choice = value;
          break;
        default:
          choice = null;
      }
logD(choice);
    });

    logD(value);
    if (value == 1) {
      setState(() {
        canProceed = true;

      });
          setState(() {
               appLanguage.changeLanguage(Locale('en'));
             });
              Navigator.pop(context,true);
              
    } 
    
    else if (value == 2) {
      setState(() {
        canProceed = false;
      });
           setState(() {
               appLanguage.changeLanguage(Locale('ar'));
             });
            Navigator.pop(context,true);
    }
  }
}
