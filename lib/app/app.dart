import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../features/auth/presentation/screens/auth_gate_screen.dart';
import '../features/finance/domain/entities/app_theme_preference.dart';
import '../features/finance/presentation/mappers/theme_mode_mapper.dart';
import '../features/finance/presentation/providers/finance_providers.dart';
import 'theme/app_theme.dart';

class CleanFinanceApp extends ConsumerWidget {
  const CleanFinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final themeMode = ThemeModeMapper.toFlutter(
      settingsState.valueOrNull?.themePreference ?? AppThemePreference.system,
    );
    final localePreferenceCode =
        settingsState.valueOrNull?.localeCode ??
            AppConstants.defaultLocalePreferenceCode;

    return MaterialApp(
      title: 'CleanFinance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: _resolveManualLocale(localePreferenceCode),
      localeListResolutionCallback: _resolveSystemLocale,
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const AuthGateScreen(),
    );
  }

  Locale? _resolveManualLocale(String localePreferenceCode) {
    final normalized =
        AppConstants.normalizeLocalePreferenceCode(localePreferenceCode);
    if (normalized == AppConstants.defaultLocalePreferenceCode) {
      return null;
    }
    return Locale(normalized);
  }

  Locale _resolveSystemLocale(
    List<Locale>? locales,
    Iterable<Locale> supportedLocales,
  ) {
    final requestedLocales = locales ?? const <Locale>[];
    for (final locale in requestedLocales) {
      if (locale.languageCode == 'es') {
        return const Locale('es');
      }
      if (locale.languageCode == 'en') {
        return const Locale('en');
      }
    }
    return const Locale('es');
  }
}

