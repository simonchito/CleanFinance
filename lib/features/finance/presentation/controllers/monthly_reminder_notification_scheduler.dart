import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/notifications/notification_permission_service.dart';
import '../../../../core/notifications/notification_providers.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../../core/utils/month_context.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/monthly_payment_reminder.dart';
import '../../domain/entities/monthly_reminder_schedule_item.dart';
import '../../domain/entities/movement.dart';
import '../../domain/entities/movement_filter.dart';

class MonthlyReminderNotificationScheduler {
  MonthlyReminderNotificationScheduler(this._ref);

  static const monthsToSchedule = 12;

  final Ref _ref;

  Future<void> syncScheduledReminders() async {
    final settings = await _ref.read(settingsRepositoryProvider).getSettings();
    final localeCode = AppConstants.resolveLocaleCodeFromPreference(
      localePreferenceCode: settings.localeCode,
      deviceLocaleCode: PlatformDispatcher.instance.locale.languageCode,
    );
    final isEnglish = localeCode == 'en';
    final notificationService = _ref.read(notificationServiceProvider);

    if (!settings.notificationsEnabled) {
      await notificationService.cancelByPayloadPrefix(
        NotificationService.remindersPayloadPrefix,
      );
      return;
    }

    final permissionStatus =
        await _ref.read(notificationPermissionServiceProvider).getStatus();
    if (permissionStatus != NotificationPermissionStatus.granted) {
      await notificationService.cancelByPayloadPrefix(
        NotificationService.remindersPayloadPrefix,
      );
      return;
    }

    final now = DateTime.now();
    final currentMonth = MonthContext.forDate(now);
    final movementsRepository = _ref.read(movementsRepositoryProvider);
    final expenseCategories = await _ref
        .read(categoriesRepositoryProvider)
        .getCategories(scope: CategoryScope.expense);
    final savingsGoals =
        await _ref.read(savingsGoalsRepositoryProvider).getSavingsGoals();
    final currentMonthMovements = await movementsRepository.getMovements(
      filter: MovementFilter(
        startDate: currentMonth.startDate,
        endDate: currentMonth.endDateInclusive,
      ),
    );
    final resolvedExpenseSubcategoryIds = currentMonthMovements
        .where(
          (movement) =>
              movement.type == MovementType.expense &&
              movement.subcategoryId != null,
        )
        .map((movement) => movement.subcategoryId!)
        .toSet();
    final resolvedSavingsGoalIds = currentMonthMovements
        .where(
          (movement) =>
              movement.type == MovementType.saving && movement.goalId != null,
        )
        .map((movement) => movement.goalId!)
        .toSet();

    final reminderService = _ref.read(monthlyPaymentReminderServiceProvider);
    final items = reminderService.buildScheduledReminderItems(
      expenseCategories: expenseCategories,
      savingsGoals: savingsGoals,
    );

    final desiredNotifications = <int, ScheduledLocalNotification>{};
    for (final item in items) {
      for (var monthOffset = 0; monthOffset < monthsToSchedule; monthOffset++) {
        if (monthOffset == 0 &&
            _isResolvedThisMonth(
              item: item,
              resolvedExpenseSubcategoryIds: resolvedExpenseSubcategoryIds,
              resolvedSavingsGoalIds: resolvedSavingsGoalIds,
            )) {
          continue;
        }

        final month = DateTime(now.year, now.month + monthOffset);
        final scheduledDate = _scheduledDateFor(
          month: month,
          item: item,
          settings: settings,
        );
        if (!scheduledDate.isAfter(now)) {
          continue;
        }

        final notificationId = _notificationIdFor(
          source: item.source,
          sourceId: item.id,
          year: scheduledDate.year,
          month: scheduledDate.month,
        );
        desiredNotifications[notificationId] = ScheduledLocalNotification(
          id: notificationId,
          title: _titleFor(item, isEnglish: isEnglish),
          body: _bodyFor(item, isEnglish: isEnglish),
          scheduledDate: scheduledDate,
          payload: _payloadFor(
            item: item,
            year: scheduledDate.year,
            month: scheduledDate.month,
          ),
        );
      }
    }

    final desiredIds = desiredNotifications.keys.toSet();
    final pending = await notificationService.pendingNotifications();
    for (final notification in pending) {
      final isCleanFinanceReminder = notification.payload?.startsWith(
            NotificationService.remindersPayloadPrefix,
          ) ==
          true;
      if (isCleanFinanceReminder && !desiredIds.contains(notification.id)) {
        await notificationService.cancel(notification.id);
      }
    }

    for (final notification in desiredNotifications.values) {
      await notificationService.cancel(notification.id);
      await notificationService.schedule(notification);
    }
  }

  DateTime _scheduledDateFor({
    required DateTime month,
    required MonthlyReminderScheduleItem item,
    required AppSettings settings,
  }) {
    final day = item.reminderDay.clamp(1, _lastDayOfMonth(month)).toInt();
    return DateTime(
      month.year,
      month.month,
      day,
      settings.notificationReminderHour,
      settings.notificationReminderMinute,
    );
  }

  int _lastDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  bool _isResolvedThisMonth({
    required MonthlyReminderScheduleItem item,
    required Set<String> resolvedExpenseSubcategoryIds,
    required Set<String> resolvedSavingsGoalIds,
  }) {
    switch (item.source) {
      case MonthlyReminderSource.expenseSubcategory:
        return resolvedExpenseSubcategoryIds.contains(item.id);
      case MonthlyReminderSource.savingsGoal:
        return resolvedSavingsGoalIds.contains(item.id);
    }
  }

  String _titleFor(
    MonthlyReminderScheduleItem item, {
    required bool isEnglish,
  }) {
    switch (item.source) {
      case MonthlyReminderSource.expenseSubcategory:
        return isEnglish ? 'Payment reminder' : 'Recordatorio de pago';
      case MonthlyReminderSource.savingsGoal:
        return isEnglish ? 'Savings reminder' : 'Recordatorio de ahorro';
    }
  }

  String _bodyFor(
    MonthlyReminderScheduleItem item, {
    required bool isEnglish,
  }) {
    switch (item.source) {
      case MonthlyReminderSource.expenseSubcategory:
        final context = item.subtitle == null
            ? ''
            : (isEnglish ? ' from ${item.subtitle}' : ' de ${item.subtitle}');
        return isEnglish
            ? 'Time to register ${item.title}$context today.'
            : 'Hoy toca registrar ${item.title}$context.';
      case MonthlyReminderSource.savingsGoal:
        return isEnglish
            ? 'Time to review your contribution for ${item.title} today.'
            : 'Hoy toca revisar el aporte para ${item.title}.';
    }
  }

  String _payloadFor({
    required MonthlyReminderScheduleItem item,
    required int year,
    required int month,
  }) {
    final source = item.source.name;
    final normalizedMonth = month.toString().padLeft(2, '0');
    return '${NotificationService.remindersPayloadPrefix}$source/${item.id}/$year-$normalizedMonth';
  }

  int _notificationIdFor({
    required MonthlyReminderSource source,
    required String sourceId,
    required int year,
    required int month,
  }) {
    final raw = '${source.name}|$sourceId|$year|$month';
    var hash = 0x811c9dc5;
    for (final unit in raw.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }
}
