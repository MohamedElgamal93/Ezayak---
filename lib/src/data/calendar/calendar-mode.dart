import 'dart:convert';

import 'package:flutter/material.dart';

class CalenderModel {
  String year;
  String month;
  Map daysStatus;

  CalenderModel({
    this.daysStatus,
    this.month,
    this.year,
  });
  CalenderModel.fromJson(Map<String, dynamic> json) {
    year = json['year'].toString() ?? null;
    month = json['month'].toString() ?? null;
    daysStatus = json['daysStatus'] ?? null;
  }
  int getMoodCount(int modeNum) {
    int count = 0;
    daysStatus.values.forEach((element) {
      if (element == modeNum.toString()) count++;
    });
    return count;
  }

  // int getFantasticCount() {
  //   int count = 0;

  //   daysStatus.values.forEach((v) {
  //     if (v == '1') count++;
  //   });
  //   return count;
  // }

  // int getGoodCount() {
  //   int count = 0;
  //   daysStatus.values.forEach((v) {
  //     if (v == '2') count++;
  //   });
  //   return count;
  // }

  // int getOkCount() {
  //   int count = 0;
  //   daysStatus.values.forEach((v) {
  //     if (v == '3') count++;
  //   });
  //   return count;
  // }

  // int getBadCount() {
  //   int count = 0;
  //   daysStatus.values.forEach((v) {
  //     if (v == '4') count++;
  //   });
  //   return count;
  // }

  // int getAwfulount() {
  //   int count = 0;
  //   daysStatus.values.forEach((v) {
  //     if (v == '5') count++;
  //   });
  //   return count;
  // }

  int getNoDaysCount() {
    int count = 0;
    daysStatus.values.forEach((v) {
      if (v == '1') count++;
      if (v == '2') count++;
      if (v == '3') count++;
      if (v == '4') count++;
      if (v == '5') count++;
    });
    return 30 - count;
  }

  static var modesColor = {
    '1': Color(0xFF5BC947),
    '2': Color(0xFF82923E),
    '3': Color(0xFFF9CD02),
    '4': Color(0xFFFC8D01),
    '5': Color(0xFFCA1717)
  };
}

CalenderModel getCalendarMoodPerMonth(String data) {
  if (json.decode(data) == null) {
    return null;
  }

  final dyn = json.decode(data);
  return CalenderModel.fromJson(dyn);
}

abstract class CalendarMoodRepository {
  Future<CalenderModel> fetchCalendarMoodsPerMonth(
      int userID, String month, String year);
}
