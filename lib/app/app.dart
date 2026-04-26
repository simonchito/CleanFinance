import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/localization/app_locale_mode.dart';
import '../core/localization/generated/app_localizations.dart';
import '../features/auth/presentation/screens/auth_gate_screen.dart';
import '../features/finance/domain/entities/app_theme_preference.dart';
import '../features/finance/presentation/mappers/theme_mode_mapper.dart';
import '../features/finance/presentation/providers/finance_providers.dart';
import '../features/finance/presentation/providers/monthly_reminder_notification_providers.dart';
import 'theme/app_theme.dart';

class CleanFinanceApp extends ConsumerStatefulWidget {
  const CleanFinanceApp({super.key});

  @override
  ConsumerState<CleanFinanceApp> createState() => _CleanFinanceAppState();
}

class _CleanFinanceAppState extends ConsumerState<CleanFinanceApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(
      () => ref.read(notificationSettingsControllerProvider).initialize(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    ref.read(systemLocaleProvider.notifier).state = locales?.firstOrNull ??
        WidgetsBinding.instance.platformDispatcher.locale;
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsControllerProvider);
    final themeMode = ThemeModeMapper.toFlutter(
      settingsState.valueOrNull?.themePreference ?? AppThemePreference.system,
    );
    final localePreferenceCode = settingsState.valueOrNull?.localeCode ??
        AppConstants.defaultLocalePreferenceCode;

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: _resolveManualLocale(localePreferenceCode),
      localeListResolutionCallback: AppLocaleMode.resolveSystemLocale,
      supportedLocales: AppLocaleMode.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const AuthGateScreen(),
    );
  }

  Locale? _resolveManualLocale(String localePreferenceCode) {
    final mode = AppLocaleMode.fromPreferenceCode(localePreferenceCode);
    if (mode == AppLocaleMode.system) {
      return null;
    }
    return mode.locale;
  }
}
