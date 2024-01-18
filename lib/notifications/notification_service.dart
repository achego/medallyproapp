import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:async';


class NotificationServices {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationServices() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('medicine');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
  }

  Future<void> sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  // Future<void> scheduleNotification(
  //     List<DateTime> notificationTimes, String title, String body) async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //   AndroidNotificationDetails(
  //     'channelId',
  //     'channelName',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //
  //   const NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidNotificationDetails);
  //
  //   for (int i = 0; i < notificationTimes.length; i++) {
  //     tz.TZDateTime scheduledTime = tz.TZDateTime.from(
  //       notificationTimes[i],
  //       tz.local,
  //     );
  //
  //     if (scheduledTime.isBefore(DateTime.now())) {
  //       print("Skipping notification at $scheduledTime as it is in the past.");
  //       continue; // Skip scheduling if it's in the past
  //     }
  //
  //     await _flutterLocalNotificationsPlugin.zonedSchedule(
  //       i,
  //       title,
  //       body,
  //       scheduledTime,
  //       notificationDetails,
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //     );
  //
  //     print("Scheduled $title at $scheduledTime");
  //   }
  // }

  Future<void> scheduleNotification(
      List<tz.TZDateTime?> notificationTimes, String title, String body) async {
        
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    DateTime now = DateTime.now();

    for (int i = 0; i < notificationTimes.length; i++) {
      tz.TZDateTime? scheduledTime = notificationTimes[i];
print(scheduledTime.toString());
      print('===========================');
      if (scheduledTime!.isBefore(now)) {
        print("Skipping notification at $scheduledTime as it is in the past.");
        continue; // Skip scheduling if it's in the past
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );

      print("Scheduled $title at $scheduledTime");
    }
  }
  Future<void> newcheduleNotification(
      tz.TZDateTime notificationTime, String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    DateTime now = DateTime.now();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      int.parse(
          DateTime.now().microsecondsSinceEpoch.toString().substring(0, 4)),
      title,
      body,
      notificationTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("Scheduled $title at $notificationTime");
  }


  void stopNotifications() {
    _flutterLocalNotificationsPlugin.cancel(0);
  }
}

