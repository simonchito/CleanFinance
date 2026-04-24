import 'app_theme_preference.dart';

class AppSettings {
  const AppSettings({
    required this.currencyCode,
    required this.currencySymbol,
    required this.showSensitiveAmounts,
    required this.themePreference,
    required this.biometricEnabled,
    required this.autoLockMinutes,
    required this.localeCode,
    required this.paymentMethods,
    this.notificationsEnabled = false,
    this.notificationReminderHour = 9,
    this.notificationReminderMinute = 0,
    this.notificationPermissionRequested = false,
  });

  final String currencyCode;
  final String currencySymbol;
  final bool showSensitiveAmounts;
  final AppThemePreference themePreference;
  final bool biometricEnabled;
  final int autoLockMinutes;
  final String localeCode;
  final List<String> paymentMethods;
  final bool notificationsEnabled;
  final int notificationReminderHour;
  final int notificationReminderMinute;
  final bool notificationPermissionRequested;

  AppSettings copyWith({
    String? currencyCode,
    String? currencySymbol,
    bool? showSensitiveAmounts,
    AppThemePreference? themePreference,
    bool? biometricEnabled,
    int? autoLockMinutes,
    String? localeCode,
    List<String>? paymentMethods,
    bool? notificationsEnabled,
    int? notificationReminderHour,
    int? notificationReminderMinute,
    bool? notificationPermissionRequested,
  }) {
    return AppSettings(
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      showSensitiveAmounts: showSensitiveAmounts ?? this.showSensitiveAmounts,
      themePreference: themePreference ?? this.themePreference,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
      localeCode: localeCode ?? this.localeCode,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationReminderHour:
          notificationReminderHour ?? this.notificationReminderHour,
      notificationReminderMinute:
          notificationReminderMinute ?? this.notificationReminderMinute,
      notificationPermissionRequested: notificationPermissionRequested ??
          this.notificationPermissionRequested,
    );
  }
}
