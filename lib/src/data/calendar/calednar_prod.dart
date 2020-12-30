import 'package:ezayak/src/data/api_client.dart';
import 'package:ezayak/src/data/calendar/calendar-mode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../base_url.dart';

class ProdCalendarMoodRepository implements CalendarMoodRepository {
  String calendarMoodUrl(int userID, String month, String year) {
    return '$APIs_URL/members/$userID/history/$month-$year';
  }

  String headerToken;
  final storage = FlutterSecureStorage();
  Future<String> getToken() async {
    if (storage != null && storage.read(key: 'Token') != null) {
      headerToken = await storage.read(key: "Token");
      return headerToken;
    } else {
      return "";
    }
  }

  @override
  Future<CalenderModel> fetchCalendarMoodsPerMonth(
      int userID, String month, String year) async {
    headerToken = await getToken();
    return await getCallService(calendarMoodUrl(userID, month, year),
        RequestType.FetchCalendarMood, headerToken);
  }
}
