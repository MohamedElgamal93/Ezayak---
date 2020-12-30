import 'package:ezayak/app_constants.dart';
import 'package:ezayak/src/app_utils.dart';
import 'package:ezayak/src/data/advice/advice.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/presenter/activites_presenter.dart';
import 'package:ezayak/src/ui/activitiesScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppLocalizations.dart';
import 'landingPage.dart';


class MoodWidget extends StatefulWidget {
  MoodWidget(this.landingPageState, this.setMode, this.setError);

  final LandingPageState landingPageState;
  final Set<void> Function(int mode) setMode;
  final Set<void> Function(String error) setError;

  @override
  _MoodWidgetState createState() => _MoodWidgetState();
}

class _MoodWidgetState extends State<MoodWidget> implements ActivitiesContract {
  DateTime selectedDate = DateTime.now();
  ActivitiesPresenter _presenter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _MoodWidgetState() {
    _presenter = new ActivitiesPresenter(this);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: TITLE_FONT_SIZE,
                                          color: BLACK,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:AppLocalizations.of(context).translate(Hello) ,
                                              style: TextStyle(
                                                  fontFamily: AR_VODAFONE_MID,
                                                  fontSize: EZYEK_FONT_SIZE)),
                                          TextSpan(
                                              text:
                                              "${widget.landingPageState
                                                  .items[widget.landingPageState
                                                  .currentPage].fullName}!",
                                              style: TextStyle(
                                                  fontFamily: isArabicString(
                                                      widget
                                                          .landingPageState
                                                          .items[widget
                                                          .landingPageState
                                                          .currentPage]
                                                          .fullName)
                                                      ? AR_VODAFONE_BOLD
                                                      : ExBd,
                                                  fontSize: EZYEK_FONT_SIZE)),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
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
                                            text: AppLocalizations.of(context).translate(How_are_you) ,
                                            style: TextStyle(
                                                fontFamily: AR_VODAFONE_MID,
                                                fontSize: TITLE_FONT_SIZE)),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Center(
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      LARGE_BUTTON_WIDTH_PERCENTAGE,
                                  height: GENERAL_BUTTON_HEIGHT,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            BUTTON_BORDER_RADIUS),
                                        side: BorderSide(color: VODA_RED)),
                                    color: VODA_WHITE,
                                    onPressed: () => _selectDate(context),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Center(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 16),
                                                child: Text(
                                                  "${selectedDate.toLocal()}"
                                                      .split(' ')[0],
                                                  style: TextStyle(
                                                      fontFamily: ExBd,
                                                      fontSize: BUTTON_FONT_SIZE),
                                                )),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Icon(
                                            Icons.date_range,
                                            color: VODA_RED,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                buildMoodWidget(
                                    AppLocalizations.of(context).translate(Excellent), 1, 'assets/smilevery.png',
                                    Color(0xFF5BC947)),
                                buildMoodWidget(
                                   AppLocalizations.of(context).translate(Good) , 2, 'assets/smile.png',
                                    Color(0xFF82923E)),
                                buildMoodWidget(AppLocalizations.of(context).translate(Ok), 3, 'assets/neutral.png',
                                    Color(0xFFF9CD02)),
                                buildMoodWidget(AppLocalizations.of(context).translate(Bad), 4, 'assets/sad.png',
                                    Color(0xFFFC8D01)),
                                buildMoodWidget(AppLocalizations.of(context).translate(Awful), 5,
                                    'assets/dissapointment.png',
                                    Color(0xFFCA1717)),
                              ],
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  MID_BUTTON_WIDTH_PERCENTAGE,
                              height: GENERAL_BUTTON_HEIGHT,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(BUTTON_BORDER_RADIUS),
                                ),
                                child: Text(
                                 AppLocalizations.of(context).translate(Next) ,
                                  style: TextStyle(
                                      color: VODA_WHITE,
                                      fontFamily: AR_VODAFONE_MID,
                                      fontSize: BUTTON_FONT_SIZE),
                                ),
                                onPressed: widget.landingPageState.items[widget
                                    .landingPageState.currentPage].lastMood !=
                                    null
                                    ? () =>
                                    _presenter.loadAdvices(widget
                                        .landingPageState
                                        .items[widget.landingPageState
                                        .currentPage]
                                        .memberId, widget
                                        .landingPageState
                                        .items[widget.landingPageState
                                        .currentPage]
                                        .lastMood, selectedDate
                                        .millisecondsSinceEpoch)


                                    : null,
                                color: VODA_RED,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Widget buildMoodWidget(String mood, int selected, String image, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.landingPageState.items[widget.landingPageState.currentPage]
              .lastMood = selected;
        });
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: widget
                      .landingPageState
                      .items[widget.landingPageState.currentPage]
                      .lastMood ==
                      selected
                      ? color
                      : Colors.transparent,
                  width: 2),
            ),
            child: Image.asset(
              image,
            ),
          ),
          FittedBox(
              child: Text(
                mood,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: SMALL_ICON_FONT_SIZE, fontFamily: AR_VODAFONE_MID),
              ))
        ],
      ),
    );
  }

  @override
  void onLoadAdvicesComplete(List<Advice> items) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ActivitiesWidget(
                    widget
                        .landingPageState
                        .items[widget.landingPageState
                        .currentPage]
                        .lastMood,
                    widget
                        .landingPageState
                        .items[widget.landingPageState
                        .currentPage]
                        .memberId,
                    selectedDate
                        .millisecondsSinceEpoch),
            transitionsBuilder:
                (_, anim, __, child) =>
                Container(child: child),
            transitionDuration: Duration(seconds: 1)));
  }

  @override
  void onLoadAdvicesError(ErrorResponse err) {
    if (CODE_401 == err.code) {
      navigateToLogin(widget
          .landingPageState.scaffoldKey, widget
          .landingPageState.landingPageContext);
    } else if (err.message == CODE_1) {
      widget.setError(AppLocalizations.of(context).translate(Make_sure_that_you_are_connected_to_the_internet));
    } else if (err.message == CODE_2) {
      widget.setError(
         AppLocalizations.of(context).translate(Server_error_please_try_again)  + LINE_BREAK + err.error);
    } else {
      widget.setError(err.message != null
          ? err.message
          : err.key != null
          ? err.key
          : err.error != null ? err.error : "error");
    }
  }

  void _showError(String error) {
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(error,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: isArabicString(error) ? AR_VODAFONE_MID : ExBd)),
      ),
    );
  }
}
