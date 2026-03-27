import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    required this.currencyCode,
    required this.currencySymbol,
    required this.themeMode,
    required this.biometricEnabled,
    required this.autoLockMinutes,
    required this.localeCode,
    required this.paymentMethods,
  });

  final String currencyCode;
  final String currencySymbol;
  final ThemeMode themeMode;
  final bool biometricEnabled;
  final int autoLockMinutes;
  final String localeCode;
  final List<String> paymentMethods;

  AppSettings copyWith({
    String? currencyCode,
    String? currencySymbol,
    ThemeMode? themeMode,
    bool? biometricEnabled,
    int? autoLockMinutes,
    String? localeCode,
    List<String>? paymentMethods,
  }) {
    return AppSettings(
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      themeMode: themeMode ?? this.themeMode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
      localeCode: localeCode ?? this.localeCode,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}
