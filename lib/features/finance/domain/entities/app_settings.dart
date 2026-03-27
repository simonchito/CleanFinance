import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    required this.currencyCode,
    required this.currencySymbol,
    required this.themeMode,
    required this.biometricEnabled,
    required this.autoLockMinutes,
  });

  final String currencyCode;
  final String currencySymbol;
  final ThemeMode themeMode;
  final bool biometricEnabled;
  final int autoLockMinutes;

  AppSettings copyWith({
    String? currencyCode,
    String? currencySymbol,
    ThemeMode? themeMode,
    bool? biometricEnabled,
    int? autoLockMinutes,
  }) {
    return AppSettings(
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      themeMode: themeMode ?? this.themeMode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
    );
  }
}
