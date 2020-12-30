import 'package:ezayak/src/data/calendar/calendar-mode.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:flutter/material.dart';

import '../../dependency_injection.dart';

abstract class CalendarMoodContract {
  void onLoadCalendarMoodComplete(CalenderModel items);
  void onLoadCalendarMoodError(ErrorResponse err);
}

class CalendarMoodPresenter {
  CalendarMoodContract _view;
  CalendarMoodRepository _repository;

  CalendarMoodPresenter(this._view) {
    _repository = new Injector().provideCalendarMoodRepo;
  }

  void loadCalendarMood({int userID, String month, String year}) {
    _repository
        .fetchCalendarMoodsPerMonth(userID, month, year)
        .then((c) => _view.onLoadCalendarMoodComplete(c))
        .catchError((onError) => _view.onLoadCalendarMoodError(onError));
  }

  String get theYear {
    String yearNow = DateTime.now().year.toString();
    List spilittedYear = yearNow.split('');
    return spilittedYear[2] + spilittedYear[3];
  }

  String get theMonth {
    String monthNow = DateTime.now().month.toString();
    String myMonth;
    if (int.parse(monthNow) >= 10) {
      myMonth = monthNow;
    }
    if (int.parse(monthNow) < 10) {
      myMonth = '0$monthNow';
    }
    return myMonth;
  }

  List<CalenderModel> dataModes = [];
  CalenderModel currentCalender;
  void delation(int seconeds) {
    Future.delayed(Duration(seconds: seconeds)).then((v) {});
  }

  Color fantatsticColor = Colors.transparent;
  Color goodColor = Colors.transparent;
  Color okColor = Colors.transparent;
  Color badColor = Colors.transparent;
  Color awfulColor = Colors.transparent;
  String count = '';
  String mood = '';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}
