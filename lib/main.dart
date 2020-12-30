import 'dart:async';

import 'package:ezayak/app_constants.dart';
import 'package:ezayak/dependency_injection.dart';
import 'package:ezayak/src/ui/landingPage.dart';

import 'package:ezayak/src/ui/login.dart';
import 'package:ezayak/src/ui/privacy.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'src/AppLanguage.dart';
import 'package:ezayak/src/AppLocalizations.dart';

bool isFirstLogin;
String headerToken;
String route;
final storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isFirstLogin = prefs.getBool(FIRST_LOGIN);

  headerToken = await storage.read(key: TOKEN);
  if (headerToken != null) {
    if (isFirstLogin != null && isFirstLogin) {
      route = LOGIN_ROUT;
    } else {
      route = LANDINGPAGE_ROUT;
    }
  } else {
    route = LOGIN_ROUT;
  }
  Injector.configure(Flavor.PROD);
  await runZoned<Future<void>>(() async {
    runApp(MyApp(appLanguage: appLanguage,));
  }, onError: (error, stackTrace) {
    print("=================== CAUGHT FLUTTER ERROR\n");
    print('Caught error: $error');
    if (isInDebugMode) {
      print(stackTrace);
    }
  });
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;
  MyApp({this.appLanguage});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) async {
      if (isInDebugMode) {
        print("=================== CAUGHT FLUTTER ERROR\n");
        FlutterError.dumpErrorToConsole(details);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
        create: (_) => widget.appLanguage,
        child: Consumer<AppLanguage>(builder: (context, model, child) {
          return MaterialApp(
            locale: model.appLocal,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: EZAYAK,
      initialRoute: LOGIN_ROUT,

      routes: <String, WidgetBuilder>{
        LOGIN_ROUT: (BuildContext context) => Login(),
        LANDINGPAGE_ROUT: (BuildContext context) => LandingPage(),
        PRIVACY_ROUT: (BuildContext context) => PrivacyScreen()
      },
      theme: ThemeData(
        primaryColor: VODA_RED,
        primarySwatch: RED,
        textTheme: Theme.of(context).textTheme.copyWith(
              body1: TextStyle(
                fontFamily: BOLD_FONT,
              ),
            ),
        cupertinoOverrideTheme: CupertinoThemeData(primaryColor: VODA_WHITE),
      ),
//      home: HelpDesk(),
    );
        }));
  }
}
