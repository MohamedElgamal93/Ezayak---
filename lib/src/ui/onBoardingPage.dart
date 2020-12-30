import 'package:ezayak/src/ui/widgets/introduction_screen.dart';
import 'package:ezayak/src/ui/widgets/page_view_model.dart';
import 'package:ezayak/src/ui/landingPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppLocalizations.dart';
import '../../app_constants.dart';

class OnBoardingPage extends StatefulWidget {

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => LandingPage(),
            transitionsBuilder: (_, anim, __, child) =>
                Container(child: child),
            transitionDuration: Duration(seconds: 1)),(route)=>false);
  _saveFirstLogin();

  }

  Widget _buildImage(String assetName) {
    return Image.asset(assetName, fit: BoxFit.cover,);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:_onWillPop,
      child: IntroductionScreen(
        globalBackgroundColor: BLACK,
        key: introKey,
        pages: [
          PageViewModel(
            bodyWidget: _buildImage(F1),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F2),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F3),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F4),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F5),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F6),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F7),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F8),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F9),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F10),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F11),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F12),
          ),
          PageViewModel(
            bodyWidget: _buildImage(F13),
          ),
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context),
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: Text(AppLocalizations.of(context).translate(Skip), style: TextStyle(fontFamily: ExBd, color: VODA_WHITE)),
        next: const Icon(Icons.arrow_forward, color: VODA_WHITE,),
        done: Text(AppLocalizations.of(context).translate(Done), style: TextStyle(fontFamily: ExBd, color: VODA_WHITE))
      ),
    );
  }

  _saveFirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(FIRST_LOGIN, false);
  }
  Future<bool> _onWillPop() {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => LandingPage(),
            transitionsBuilder: (_, anim, __, child) =>
                Container(child: child),
            transitionDuration: Duration(seconds: 1)),(route)=>false);
    return Future(() => false);
  }
}