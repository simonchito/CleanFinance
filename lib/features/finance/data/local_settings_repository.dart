import 'dart:convert';

import '../../../core/constants/app_constants.dart';
import '../domain/entities/app_settings.dart';
import '../domain/repositories/settings_repository.dart';
import 'local_finance_support.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._support);

  final LocalFinanceSupport _support;

  @override
  Future<AppSettings> getSettings() async {
    final db = await _support.appDatabase.instance;
    final row = (await db.query(
      'app_settings',
      where: 'id = 1',
      limit: 1,
    ))
        .first;

    return AppSettings(
      currencyCode: row['currency_code'] as String,
      currencySymbol: row['currency_symbol'] as String,
      showSensitiveAmounts: (row['show_sensitive_amounts'] as int? ?? 1) == 1,
      themePreference: _support.themeModeFromDb(row['theme_mode'] as String),
      biometricEnabled: (row['biometric_enabled'] as int? ?? 0) == 1,
      autoLockMinutes: (row['auto_lock_minutes'] as int?) ??
          AppConstants.defaultAutoLockMinutes,
      localeCode: AppConstants.normalizeLocalePreferenceCode(
        row['locale_code'] as String?,
      ),
      paymentMethods:
          _support.paymentMethodsFromDb(row['payment_methods'] as String?),
      notificationsEnabled: (row['notifications_enabled'] as int? ?? 0) == 1,
      notificationReminderHour:
          (row['notification_reminder_hour'] as int?) ?? 9,
      notificationReminderMinute:
          (row['notification_reminder_minute'] as int?) ?? 0,
      notificationPermissionRequested:
          (row['notification_permission_requested'] as int? ?? 0) == 1,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final db = await _support.appDatabase.instance;
    await db.update(
      'app_settings',
      {
        'currency_code': settings.currencyCode,
        'currency_symbol': settings.currencySymbol,
        'show_sensitive_amounts': settings.showSensitiveAmounts ? 1 : 0,
        'theme_mode': settings.themePreference.name,
        'biometric_enabled': settings.biometricEnabled ? 1 : 0,
        'auto_lock_minutes': settings.autoLockMinutes,
        'locale_code':
            AppConstants.normalizeLocalePreferenceCode(settings.localeCode),
        'payment_methods': jsonEncode(settings.paymentMethods),
        'notifications_enabled': settings.notificationsEnabled ? 1 : 0,
        'notification_reminder_hour': settings.notificationReminderHour,
        'notification_reminder_minute': settings.notificationReminderMinute,
        'notification_permission_requested':
            settings.notificationPermissionRequested ? 1 : 0,
      },
      where: 'id = 1',
    );
  }
}
