import 'package:flutter/material.dart';

import '../../domain/entities/app_theme_preference.dart';

class ThemeModeMapper {
  const ThemeModeMapper._();

  static ThemeMode toFlutter(AppThemePreference preference) {
    return switch (preference) {
      AppThemePreference.system => ThemeMode.system,
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
    };
  }
}
