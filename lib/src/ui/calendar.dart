import 'dart:developer';

import 'package:ezayak/app_constants.dart';
import 'package:ezayak/src/data/calendar/calendar-mode.dart';
import 'package:ezayak/src/data/calendar/calendar-mode_UI.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/familyData/family_data.dart';
import 'package:ezayak/src/presenter/calendar_mood.dart';
import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:ezayak/src/ui/widgets/bottomBar.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';

import 'package:flutter/material.dart';
import '../AppLocalizations.dart';
import '../app_utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MyCalendar extends StatefulWidget {
  final FamilyMember member;

  MyCalendar({this.member});

  @override
  MyCalendarState createState() => MyCalendarState();
}

class MyCalendarState extends State<MyCalendar>
    implements CalendarMoodContract {
  CalendarMoodPresenter _presenter;
  MyCalendarState() {
    _presenter = CalendarMoodPresenter(this);
  }
  CalendarController _calendarController;
  bool _isLoading = true;
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // bool _hasData = true;

  bool _isArabic;

  @override
  void initState() {
    super.initState();
    _presenter.loadCalendarMood(
      userID: widget.member.id,
      month: _presenter.theMonth,
      year: _presenter.theYear,
    );

    _calendarController = CalendarController();
    setState(() {
      _isArabic = isArabicString(widget.member.fullName);
    });
  }

  _buildCalendar() => _isLoading
      ? Center(
          child: CircularProgressIndicator(),
        )
      : TableCalendar(
          calendarController: _calendarController,
          initialCalendarFormat: CalendarFormat.month,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: Theme.of(context).textTheme.body1,
            weekendStyle: Theme.of(context).textTheme.body1.copyWith(
                  color: Colors.red,
                ),
          ),
          headerStyle: HeaderStyle(
            formatButtonTextStyle: Theme.of(context).textTheme.body1,
            titleTextStyle: Theme.of(context).textTheme.body1,
            centerHeaderTitle: true,
            formatButtonVisible: false,
            formatButtonDecoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20.8),
            ),
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          builders: CalendarBuilders(
            dayBuilder: (ctx, dateTime, list) {
              CalenderModel c;
              _presenter.dataModes.forEach((item) {
                if (item.month == dateTime.month.toString() &&
                    item.year == dateTime.year.toString() &&
                    (item.daysStatus.containsKey(dateTime.day.toString()) ==
                        true)) {
                  c = item;
                }
              });
              return Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (c == null)
                        ? GREY
                        : CalenderModel.modesColor[
                                c.daysStatus[dateTime.day.toString()]] ??
                            GREY),
                child: Center(
                    child: Text(
                  dateTime.day.toString(),
                  style: Theme.of(context).textTheme.body1.copyWith(
                        color: VODA_WHITE,
                        fontSize: LABEL_FONT_SIZE,
                      ),
                )),
              );
            },
          ),
          onVisibleDaysChanged: (firstDate, lastDate, format) async {
            _presenter.fantatsticColor = Colors.transparent;
            _presenter.goodColor = Colors.transparent;
            _presenter.okColor = Colors.transparent;
            _presenter.badColor = Colors.transparent;
            _presenter.awfulColor = Colors.transparent;
            _presenter.count = '';
            _presenter.mood = '';
            _presenter.currentCalender = null;
            String month = firstDate.month.toString();
            String year = firstDate.year.toString();

            logD('Month:$month');
            logD('Year:$year');
            if ((lastDate.month > firstDate.month &&
                    (lastDate.month - firstDate.month != 1)) ||
                (firstDate.day != 1)) {
              month = (firstDate.month + 1).toString();
              year = firstDate.year.toString();
              if (month == "13") {
                month = "1";
                year = lastDate.year.toString();
              }
            }
            logD('VisibileMonth:$month');
            logD('VisibleYear:$year');
            List spilittedYear = year.split('');
            String newYear = spilittedYear[2] + spilittedYear[3];

            if (int.parse(month) < 10) {
              month = '0$month';
            }
            log('submitted$month');
            log('submitted $newYear');

            _presenter.loadCalendarMood(
              userID: widget.member.id,
              month: month,
              year: newYear,
            );
            _presenter.dataModes.forEach((item) async {
              if (item.month == month && item.year == year) {
                _presenter.currentCalender = item;
                logD(
                    'CurrentGood:${_presenter.currentCalender.getMoodCount(2)}');
              }
            });
            Future.delayed(Duration(seconds: 0)).then((v) {
              setState(() {});
              _presenter.delation(1);
            });
          },
          onCalendarCreated: (firstDate, lastDate, format) {
            String thismonth = firstDate.month.toString();
            String thisyear = firstDate.year.toString();

            logD('CreatedMonth:$thismonth');
            logD('CreatedYear:$thisyear');
            if ((lastDate.month > firstDate.month &&
                    (lastDate.month - firstDate.month != 1)) ||
                (firstDate.day != 1)) {
              thismonth = (firstDate.month + 1).toString();
              thisyear = firstDate.year.toString();
              if (thismonth == "13") {
                thismonth = "1";
                thisyear = lastDate.year.toString();
              }
            }
            logD('CreatedVisibileMonth:$thismonth');
            logD('CreatedVisibleYear:$thisyear');
            _presenter.dataModes.forEach((item) {
              if (item.month == thismonth && item.year == thisyear) {
                _presenter.currentCalender = item;
                logD(
                    'CurrentGood:${_presenter.currentCalender.getMoodCount(2)}');
              }
            });
            Future.delayed(Duration(seconds: 0)).then((v) {
              setState(() {});
              _presenter.delation(1);
            });
          },
          weekendDays: [5, 6],
          calendarStyle: CalendarStyle(
            highlightToday: true,
            outsideWeekendStyle: Theme.of(context).textTheme.body1,
            weekendStyle: Theme.of(context).textTheme.body1,
            outsideStyle: Theme.of(context).textTheme.body1,
            holidayStyle: TextStyle(
              fontFamily: BOLD_FONT,
            ),
            outsideHolidayStyle: TextStyle(
              fontFamily: BOLD_FONT,
            ),
            todayStyle: TextStyle(
              fontFamily: BOLD_FONT,
            ),
            selectedStyle: TextStyle(
              fontFamily: BOLD_FONT,
            ),
            unavailableStyle: TextStyle(
              fontFamily: BOLD_FONT,
            ),
            weekdayStyle: TextStyle(
              fontFamily: BOLD_FONT,
            ),
          ),
        );

  // Color _fantatsticColor = Colors.transparent;
  // Color _goodColor = Colors.transparent;
  // Color _okColor = Colors.transparent;
  // Color _badColor = Colors.transparent;
  // Color _awfulColor = Colors.transparent;

  _smileFaces(
    String image,
    Function count,
    String title,
    Color decorationcolor,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: decorationcolor,
                width: 2,
              ),
            ),
            child: InkWell(
              child: Image.asset(
                image,
              ),
              onTap: count,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: SMALL_ICON_FONT_SIZE,
              fontFamily: AR_VODAFONE_MID,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _presenter.scaffoldKey,
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
                bottomNavigationBar: BottomBar(
                  showProfile: true,
                  showSos: true,
                ),
                body: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: GREY),
                            right: BorderSide(color: GREY),
                            left: BorderSide(color: GREY),
                          ),
                          color: VODA_WHITE),
                      child: buildContent(context),
                    )),
              )
            ],
          ),
        ),
      ),
//      ),
    );
  }

  Column buildContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
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
                      text: AppLocalizations.of(context).translate(Profile),
                      style: TextStyle(
                        fontFamily: AR_VODAFONE_MID,
                      )),
                  TextSpan(
                      text: "(${widget.member.fullName})",
                      style: TextStyle(
                        fontFamily: _isArabic ? AR_VODAFONE_BOLD : ExBd,
                      )),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width *
                      MID_BUTTON_WIDTH_PERCENTAGE,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: VODA_RED, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: FittedBox(
                      child: Text(
                       AppLocalizations.of(context).translate(Your_daily_mood),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: BUTTON_FONT_SIZE,
                            fontFamily: AR_VODAFONE_BOLD),
                      ),
                    )),
                  ),
                ),
                _buildCalendar(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Divider(
                        thickness: 1,
                        color: Colors.black26,
                      ),
                      Text(
                      AppLocalizations.of(context).translate(Your_mood_during_the_month),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontFamily: AR_VODAFONE_MID,
                            fontSize: BUTTON_FONT_SIZE),
                      ),
                      Text(
                    AppLocalizations.of(context).translate(Click_on_each_mood_to_know_more),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: ICON_FONT_SIZE,
                          fontFamily: AR_VODAFONE_MID,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _smileFaces(
                            'assets/smilevery.png',
                            () {
                              _presenter.fantatsticColor = Color(0xFF5BC947);
                              _presenter.goodColor = Colors.transparent;
                              _presenter.okColor = Colors.transparent;
                              _presenter.badColor = Colors.transparent;
                              _presenter.awfulColor = Colors.transparent;
                              setState(() {
                                _presenter.count =
                                    (_presenter.currentCalender == null)
                                        ? "0"
                                        : _presenter.currentCalender
                                                .getMoodCount(1)
                                                .toString() ??
                                            "0";
                                _presenter.mood = AppLocalizations.of(context).translate(Excellent);
                              });
                            },
                            AppLocalizations.of(context).translate(Excellent),
                            _presenter.fantatsticColor,
                          ),
                          _smileFaces(
                            'assets/smile.png',
                            () {
                              setState(() {
                                _presenter.fantatsticColor = Colors.transparent;
                                _presenter.goodColor = Color(0xFF82923E);
                                _presenter.okColor = Colors.transparent;
                                _presenter.badColor = Colors.transparent;
                                _presenter.awfulColor = Colors.transparent;
                                _presenter.count =
                                    (_presenter.currentCalender == null)
                                        ? "0"
                                        : _presenter.currentCalender
                                                .getMoodCount(2)
                                                .toString() ??
                                            "0";
                                _presenter.mood = AppLocalizations.of(context).translate(Good);
                              });
                            },
                           AppLocalizations.of(context).translate(Good),
                            _presenter.goodColor,
                          ),
                          _smileFaces(
                            'assets/neutral.png',
                            () {
                              setState(() {
                                _presenter.fantatsticColor = Colors.transparent;
                                _presenter.goodColor = Colors.transparent;
                                _presenter.okColor = Color(0xFFF9CD02);
                                _presenter.badColor = Colors.transparent;
                                _presenter.awfulColor = Colors.transparent;
                                _presenter.count =
                                    (_presenter.currentCalender == null)
                                        ? "0"
                                        : _presenter.currentCalender
                                                .getMoodCount(3)
                                                .toString() ??
                                            "0";
                                _presenter.mood = AppLocalizations.of(context).translate(Ok);
                              });
                            },
                          AppLocalizations.of(context).translate(Ok),
                            _presenter.okColor,
                          ),
                          _smileFaces(
                            'assets/sad.png',
                            () {
                              setState(() {
                                _presenter.fantatsticColor = Colors.transparent;
                                _presenter.goodColor = Colors.transparent;
                                _presenter.okColor = Colors.transparent;
                                _presenter.badColor = Color(0xFFFC8D01);
                                _presenter.awfulColor = Colors.transparent;

                                _presenter.count =
                                    (_presenter.currentCalender == null)
                                        ? "0"
                                        : _presenter.currentCalender
                                                .getMoodCount(4)
                                                .toString() ??
                                            "0";
                                _presenter.mood = AppLocalizations.of(context).translate(Bad);
                              });
                            },
                           AppLocalizations.of(context).translate(Bad),
                            _presenter.badColor,
                          ),
                          _smileFaces(
                            'assets/dissapointment.png',
                            () {
                              setState(() {
                                _presenter.fantatsticColor = Colors.transparent;
                                _presenter.goodColor = Colors.transparent;
                                _presenter.okColor = Colors.transparent;
                                _presenter.badColor = Colors.transparent;
                                _presenter.awfulColor = Color(0xFFCA1717);
                                _presenter.count =
                                    (_presenter.currentCalender == null)
                                        ? "0"
                                        : _presenter.currentCalender
                                                .getMoodCount(5)
                                                .toString() ??
                                            "0";
                                _presenter.mood =  AppLocalizations.of(context).translate(Awful) ;
                              });
                            },
                           AppLocalizations.of(context).translate(Awful) ,
                            _presenter.awfulColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                _presenter.currentCalender != null
                                    ? '${_presenter.count} \n ${_presenter.mood}'
                                    : '',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: ExBd,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: charts.PieChart(
                                [
                                  charts.Series(
                                    domainFn: (Mood mood, _) => mood.mood,
                                    measureFn: (Mood mood, _) =>
                                        _presenter.currentCalender == null
                                            ? 1.0
                                            : mood.moodvalue,

                                    colorFn: (Mood mood, _) =>
                                        charts.ColorUtil.fromDartColor(
                                            _presenter.currentCalender == null
                                                ? GREY
                                                : mood.colorval),
                                    id: 'Air Pollution',
                                    data: _presenter.currentCalender == null
                                        ? [Mood('Non', 100.0, GREY)]
                                        : [
                                            Mood(
                                              'fantastic',
                                              _presenter.currentCalender == null
                                                  ? 0.0
                                                  : (_presenter.currentCalender
                                                              .getMoodCount(1)
                                                              .toDouble() /
                                                          30) *
                                                      100,
                                              Color(0xFF5BC947),
                                            ),
                                            Mood(
                                              'good',
                                              _presenter.currentCalender == null
                                                  ? 0.0
                                                  : (_presenter.currentCalender
                                                              .getMoodCount(2)
                                                              .toDouble() /
                                                          30) *
                                                      100,
                                              Color(0xFF82923E),
                                            ),
                                            Mood(
                                              'ok',
                                              _presenter.currentCalender == null
                                                  ? 0.0
                                                  : (_presenter.currentCalender
                                                              .getMoodCount(3)
                                                              .toDouble() /
                                                          30) *
                                                      100,
                                              Color(0xFFF9CD02),
                                            ),
                                            Mood(
                                              'bad',
                                              _presenter.currentCalender == null
                                                  ? 0.0
                                                  : (_presenter.currentCalender
                                                              .getMoodCount(4)
                                                              .toDouble() /
                                                          30) *
                                                      100,
                                              Color(0xFFFC8D01),
                                            ),
                                            Mood(
                                              'awful',
                                              _presenter.currentCalender == null
                                                  ? 0.0
                                                  : (_presenter.currentCalender
                                                              .getMoodCount(5)
                                                              .toDouble() /
                                                          30) *
                                                      100,
                                              Color(0xFFCA1717),
                                            ),
                                            Mood(
                                              'noo moode',
                                              _presenter.currentCalender == null
                                                  ? 0.0
                                                  : (_presenter.currentCalender
                                                              .getNoDaysCount()
                                                              .toDouble() /
                                                          30) *
                                                      100,
                                              GREY,
                                            ),
                                          ],
                                    //labelAccessorFn: (Task row, _) => '${row.taskvalue}',
                                  ),
                                ] as List<charts.Series<Mood, String>>,
                                animate: true,
                                animationDuration: Duration(seconds: 2),
                                defaultRenderer: charts.ArcRendererConfig(
                                  arcWidth: 30,
                                  arcRendererDecorators: [],
                                  arcRatio: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // SizedBox(
                //   height: 25,
                // ),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //         child: Column(
                //       children: <Widget>[
                //         Text((currentCalender == null)
                //             ? "0"
                //             : currentCalender
                //                     .getFantasticCount()
                //                     .toString() ??
                //                 "0"),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Container(
                //           height: 10,
                //           color: CalenderModel
                //               .modesColor['fantastic'],
                //         )
                //       ],
                //     )),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //         child: Column(
                //       children: <Widget>[
                //         Text((currentCalender == null)
                //             ? "0"
                //             : currentCalender
                //                     .getGoodCount()
                //                     .toString() ??
                //                 "0"),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Container(
                //           height: 10,
                //           color: CalenderModel
                //               .modesColor['good'],
                //         )
                //       ],
                //     )),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       child: Column(
                //         children: <Widget>[
                //           Text((currentCalender == null)
                //               ? "0"
                //               : currentCalender
                //                       .getOkCount()
                //                       .toString() ??
                //                   "0"),
                //           SizedBox(
                //             height: 5,
                //           ),
                //           Container(
                //             height: 10,
                //             color: CalenderModel
                //                 .modesColor['ok'],
                //           )
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       child: Column(
                //         children: <Widget>[
                //           Text((currentCalender == null)
                //               ? "0"
                //               : currentCalender
                //                       .getBadCount()
                //                       .toString() ??
                //                   "0"),
                //           SizedBox(
                //             height: 5,
                //           ),
                //           Container(
                //             height: 10,
                //             color: CalenderModel
                //                 .modesColor['bad'],
                //           )
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       child: Column(
                //         children: <Widget>[
                //           Text((currentCalender == null)
                //               ? "0"
                //               : currentCalender
                //                       .getAwfulount()
                //                       .toString() ??
                //                   "0"),
                //           SizedBox(
                //             height: 5,
                //           ),
                //           Container(
                //             height: 10,
                //             color: CalenderModel
                //                 .modesColor['awful'],
                //           )
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void onLoadCalendarMoodComplete(CalenderModel items) {
    setState(() {
      if (items != null) {
        logD('CalenderModel  $items');

        _presenter.dataModes.add(items);
        _presenter.currentCalender = items;
      }
      if (items == null) {
        setState(() {
          _presenter.currentCalender = null;
        });
      }

      _isLoading = false;
      // _hasData = true;
    });
  }

  void _showToast(message) {
    _presenter.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: isArabicString(message) ? AR_VODAFONE_MID : ExBd),
        ),
      ),
    );
  }

  @override
  void onLoadCalendarMoodError(ErrorResponse err) {
    if (CODE_401 == err.code) {
      navigateToLogin(_presenter.scaffoldKey, context);
    } else if (err.message == CODE_1) {
      _showToast(AppLocalizations.of(context).translate(Make_sure_that_you_are_connected_to_the_internet));
    } else if (err.message == CODE_2) {
      _showToast(
          AppLocalizations.of(context).translate(Server_error_please_try_again) + LINE_BREAK + err.error);
    } else {
      _showToast(err.message != null
          ? err.message
          : err.key != null
              ? err.key
              : err.error != null ? err.error : "error");
    }

    setState(() {
      _isLoading = false;
      // _hasData = false;
    });
  }
}
