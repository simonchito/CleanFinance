import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../features/auth/presentation/screens/auth_gate_screen.dart';
import '../features/finance/presentation/providers/finance_providers.dart';
import 'theme/app_theme.dart';

class CleanFinanceApp extends ConsumerWidget {
  const CleanFinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final themeMode =
        settingsState.valueOrNull?.themeMode ?? ThemeMode.system;

    return MaterialApp(
      title: 'CleanFinance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: Locale(
        settingsState.valueOrNull?.localeCode ?? AppConstants.defaultLocaleCode,
      ),
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
}
