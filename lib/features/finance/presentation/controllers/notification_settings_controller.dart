import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/notification_permission_service.dart';
import '../../../../core/notifications/notification_providers.dart';
import '../../../../core/notifications/notification_service.dart';
import 'monthly_reminder_notification_scheduler.dart';
import '../providers/finance_providers.dart';

enum CleanFinanceNotificationStatus {
  disabled,
  active,
  permissionPending,
  permissionDenied,
  unsupported,
}

class NotificationSettingsController {
  NotificationSettingsController(this._ref);

  final Ref _ref;

  Future<void> initialize() async {
    try {
      await _ref.read(notificationServiceProvider).initialize();
      await MonthlyReminderNotificationScheduler(_ref).syncScheduledReminders();
    } catch (_) {
      // Notification startup should never block the app.
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    var permissionRequested = false;
    if (enabled) {
      permissionRequested = true;
      final status = await _ref
          .read(notificationPermissionServiceProvider)
          .requestPermission();
      await _ref
          .read(settingsControllerProvider.notifier)
          .setNotificationsEnabled(
            enabled,
            permissionRequested: permissionRequested,
          );

      if (status == NotificationPermissionStatus.granted) {
        await MonthlyReminderNotificationScheduler(_ref)
            .syncScheduledReminders();
      } else {
        await _ref
            .read(notificationServiceProvider)
            .cancelByPayloadPrefix(NotificationService.remindersPayloadPrefix);
      }
    } else {
      await _ref
          .read(settingsControllerProvider.notifier)
          .setNotificationsEnabled(enabled);
      await _ref
          .read(notificationServiceProvider)
          .cancelByPayloadPrefix(NotificationService.remindersPayloadPrefix);
    }
  }

  Future<void> setReminderTime({
    required int hour,
    required int minute,
  }) async {
    await _ref.read(settingsControllerProvider.notifier).setNotificationTime(
          hour: hour,
          minute: minute,
        );
    await MonthlyReminderNotificationScheduler(_ref).syncScheduledReminders();
  }
}
