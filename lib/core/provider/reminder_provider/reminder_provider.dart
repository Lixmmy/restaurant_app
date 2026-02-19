import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restaurant_app/core/service/local_notification_service.dart';

class ReminderProvider extends ChangeNotifier {
  static const String _reminderKey = 'isReminderEnabled';
  static const int _reminderNotificationId = 0; // Unique ID for reminder notification
  bool _isReminderEnabled = false;

  bool get isReminderEnabled => _isReminderEnabled;

  ReminderProvider() {
    _loadReminderStatus();
  }

  Future<void> _loadReminderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderEnabled = prefs.getBool(_reminderKey) ?? false;
    if (_isReminderEnabled) {
      _scheduleDailyReminder();
    }
    notifyListeners();
  }

  Future<void> toggleReminder(bool value) async {
    _isReminderEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderKey, value);

    if (value) {
      final bool? granted =
          await LocalNotificationService().requestPermissions();
      if (granted != null && granted) {
        _scheduleDailyReminder();
      } else {
        // Handle case where permissions are not granted, e.g., show a message to the user
        debugPrint('Notification permissions not granted.');
        _isReminderEnabled = false; // Reset toggle if permissions denied
      }
    } else {
      _cancelDailyReminder();
    }
    notifyListeners();
  }

  void _scheduleDailyReminder() {
    // Assuming a fixed ID for the daily reminder notification
    // Using ApiService.notificationId to generate a unique ID
    LocalNotificationService().scheduleDailyElevenAMNotification(
      id: _reminderNotificationId,
      title: "Restaurant Reminder!",
      body: "Don't forget to explore new restaurants today!",
    );
  }

  void _cancelDailyReminder() {
    LocalNotificationService().cancelNotification(_reminderNotificationId);
  }
}
