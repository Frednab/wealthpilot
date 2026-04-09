// lib/services/notification_service.dart
// WealthPilot coaching push notifications

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  static Future<void> scheduleMonthlyReminder({
    required int dayOfMonth,
    required double amount,
  }) async {
    // TODO: Implement monthly recurring notification
    // Use timezone package for proper scheduling
  }

  static Future<void> sendCoachingNudge(String message) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'coaching_channel',
        'WealthPilot Coach',
        channelDescription: 'Investment coaching and reminders',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      0,
      'WealthPilot Coach 🤖',
      message,
      details,
    );
  }

  static final List<String> coachingMessages = [
    "Time to invest this month! Stay on track. 💪",
    "Market is down — this is a BUY opportunity. 📉→📈",
    "You're building real wealth. Don't stop now! 🚀",
    "Compound interest is working for you 24/7. 🔄",
    "Don't panic sell. Long-term investors win. 🏆",
    "Your future self will thank you. Keep going! 🌟",
  ];
}
