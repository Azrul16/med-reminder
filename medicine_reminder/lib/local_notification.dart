import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'models/medicine.dart';
import 'constants.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications
  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// Schedule notifications for a medicine
  /// This schedules notifications starting from the startTime and repeating at the interval
  static Future<void> scheduleMedicineNotifications(Medicine medicine) async {
    if (medicine.startTime == null ||
        medicine.interval == null ||
        medicine.notificationIDs == null) {
      return;
    }

    // Parse start time (format: HHMM)
    int hour = int.parse(medicine.startTime!.substring(0, 2));
    int minute = int.parse(medicine.startTime!.substring(2, 4));

    // Calculate how many notifications per day (24 hours / interval)
    int notificationsPerDay = (24 / medicine.interval!).floor();

    // Notification details
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'med_reminder_channel',
      'Medicine Reminders',
      channelDescription: 'Notifications for medicine reminders',
      importance: Importance.max,
      priority: Priority.high,
      ledColor: kOtherColor,
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
      playSound: true,
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Schedule each notification
    for (int i = 0; i < notificationsPerDay; i++) {
      int notificationHour = (hour + (medicine.interval! * i)) % 24;

      // Get the notification ID from the list
      int notificationId = int.parse(medicine.notificationIDs![i]);

      // Create the scheduled time for today
      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        notificationHour,
        minute,
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      // Schedule the notification to repeat daily at this time
      await _notificationsPlugin.zonedSchedule(
        notificationId,
        'Medicine Reminder',
        'Time to take ${medicine.medicineName}${medicine.dosage != null && medicine.dosage! > 0 ? ' (${medicine.dosage}mg)' : ''}',
        scheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print(
        'Scheduled notification $notificationId for ${medicine.medicineName} at ${notificationHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
      );
    }
  }

  /// Cancel all notifications for a medicine
  static Future<void> cancelMedicineNotifications(Medicine medicine) async {
    if (medicine.notificationIDs == null) return;

    for (String id in medicine.notificationIDs!) {
      await _notificationsPlugin.cancel(int.parse(id));
    }
  }

  /// Reschedule all medicines (used when app restarts)
  /// Only schedules notifications for medicines with notificationsEnabled = true
  static Future<void> rescheduleAllMedicines(List<Medicine> medicines) async {
    for (Medicine medicine in medicines) {
      if (medicine.areNotificationsEnabled) {
        await scheduleMedicineNotifications(medicine);
      }
    }
  }
}
