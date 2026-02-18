import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future<bool> _isAndroidPermissionGranted() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled() ??
        false;
  }

  // Future<bool> _requestAndroidNotificationsPermission() async {
  //   return await flutterLocalNotificationsPlugin
  //           .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin
  //           >()
  //           ?.requestNotificationsPermission() ??
  //       false;
  // }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final TimezoneInfo timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName.identifier));
  }

  tz.TZDateTime _nextInstanceOfElevenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<bool> _requestExactAlarmsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestExactAlarmsPermission() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final requestNotificationsPermission = await androidImplementation
          ?.requestNotificationsPermission();
      final notificationEnabled = await _isAndroidPermissionGranted();
      final requestAlarmEnabled = await _requestExactAlarmsPermission();
      return (requestNotificationsPermission ?? false) &&
          notificationEnabled &&
          requestAlarmEnabled;
    } else {
      return false;
    }
  }

  Future<void> scheduleDailyElevenAMNotification({
    required int id,
    String channelId = "daily_reminder_channel",
    String channelName = "Daily Reminder",
    String title = "It's time to check out new restaurants!",
    String body = "Don't miss out on amazing dining experiences near you.",
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final datetimeSchedule = _nextInstanceOfElevenAM();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: datetimeSchedule,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
