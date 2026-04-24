import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_service.dart';

enum NotificationPermissionStatus {
  unsupported,
  granted,
  denied,
}

class NotificationPermissionService {
  NotificationPermissionService(this._notificationService);

  final NotificationService _notificationService;

  Future<NotificationPermissionStatus> getStatus() async {
    if (!_notificationService.isSupportedPlatform) {
      return NotificationPermissionStatus.unsupported;
    }
    await _notificationService.initialize();
    final androidPlugin = _notificationService.plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final enabled = await androidPlugin?.areNotificationsEnabled();
    return enabled == true
        ? NotificationPermissionStatus.granted
        : NotificationPermissionStatus.denied;
  }

  Future<NotificationPermissionStatus> requestPermission() async {
    if (!_notificationService.isSupportedPlatform) {
      return NotificationPermissionStatus.unsupported;
    }
    await _notificationService.initialize();
    final androidPlugin = _notificationService.plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidPlugin?.requestNotificationsPermission();
    if (granted == true) {
      return NotificationPermissionStatus.granted;
    }
    return getStatus();
  }
}
