import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/notification_permission_service.dart';
import '../../../../core/notifications/notification_providers.dart';
import '../../../../shared/providers.dart';
import '../controllers/monthly_reminder_notification_scheduler.dart';
import '../controllers/notification_settings_controller.dart';
import 'finance_providers.dart';

final monthlyReminderNotificationSchedulerProvider =
    Provider<MonthlyReminderNotificationScheduler>(
  MonthlyReminderNotificationScheduler.new,
);

final notificationSettingsControllerProvider =
    Provider<NotificationSettingsController>(
  NotificationSettingsController.new,
);

final cleanFinanceNotificationStatusProvider =
    FutureProvider<CleanFinanceNotificationStatus>((ref) async {
  final settings = ref.watch(settingsControllerProvider).valueOrNull ??
      await ref.watch(settingsRepositoryProvider).getSettings();
  if (!settings.notificationsEnabled) {
    return CleanFinanceNotificationStatus.disabled;
  }

  final permissionStatus =
      await ref.watch(notificationPermissionServiceProvider).getStatus();
  switch (permissionStatus) {
    case NotificationPermissionStatus.unsupported:
      return CleanFinanceNotificationStatus.unsupported;
    case NotificationPermissionStatus.granted:
      return CleanFinanceNotificationStatus.active;
    case NotificationPermissionStatus.denied:
      return settings.notificationPermissionRequested
          ? CleanFinanceNotificationStatus.permissionDenied
          : CleanFinanceNotificationStatus.permissionPending;
  }
});
