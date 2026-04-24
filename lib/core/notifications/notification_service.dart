import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class ScheduledLocalNotification {
  const ScheduledLocalNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDate,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledDate;
  final String payload;
}

class PendingLocalNotification {
  const PendingLocalNotification({
    required this.id,
    required this.payload,
  });

  final int id;
  final String? payload;
}

class NotificationService {
  NotificationService({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const remindersPayloadPrefix = 'cleanfinance://monthly-reminder/';
  static const _channelId = 'cleanfinance_monthly_reminders';
  static const _channelName = 'Recordatorios mensuales';
  static const _channelDescription =
      'Avisos de pagos mensuales y metas de ahorro de CleanFinance';

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  bool get isSupportedPlatform {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  Future<void> initialize() async {
    if (_initialized || !isSupportedPlatform) {
      return;
    }

    await _configureTimeZone();

    const androidSettings = AndroidInitializationSettings(
      'ic_stat_clean_finance',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.defaultImportance,
      ),
    );

    _initialized = true;
  }

  Future<void> schedule(ScheduledLocalNotification notification) async {
    if (!isSupportedPlatform) {
      return;
    }
    await initialize();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
    );

    await _plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(notification.scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: notification.payload,
    );
  }

  Future<void> cancel(int id) async {
    if (!isSupportedPlatform) {
      return;
    }
    await initialize();
    await _plugin.cancel(id);
  }

  Future<List<PendingLocalNotification>> pendingNotifications() async {
    if (!isSupportedPlatform) {
      return const [];
    }
    await initialize();
    final pending = await _plugin.pendingNotificationRequests();
    return pending
        .map(
          (item) => PendingLocalNotification(
            id: item.id,
            payload: item.payload,
          ),
        )
        .toList();
  }

  Future<void> cancelByPayloadPrefix(String payloadPrefix) async {
    final pending = await pendingNotifications();
    for (final notification in pending) {
      if (notification.payload?.startsWith(payloadPrefix) == true) {
        await cancel(notification.id);
      }
    }
  }

  Future<void> _configureTimeZone() async {
    tz_data.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }
}
