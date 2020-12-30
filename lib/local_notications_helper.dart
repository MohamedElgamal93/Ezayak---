import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

import 'app_constants.dart';

NotificationDetails get _noSound {
  final androidChannelSpecifics = AndroidNotificationDetails(
    SILENT_CHANNEL_ID,
    SILENT_CHANNEL_NAME,
    SILENT_CHANNEL_DESCRIPTION,
    playSound: false,
  );
  final iOSChannelSpecifics = IOSNotificationDetails(presentSound: false);

  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future showSilentNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _noSound);

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    YOUR_CHANNEL_ID,
    YOUR_CHANNEL_NAME,
    YOUR_CHANNEL_DESCRIPTION,
    importance: Importance.Max,
    priority: Priority.High,
  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);

DateTime now = DateTime.now().toUtc().add(
      Duration(seconds: 5),
    );

//Future _scheduleNotification(
//  FlutterLocalNotificationsPlugin notifications, {
//  @required String title,
//  @required String body,
//  @required NotificationDetails type,
//  int id = 0,
//}) =>
//    notifications.schedule(id, title, body, now, type);
