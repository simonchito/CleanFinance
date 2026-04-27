import 'package:flutter/widgets.dart';

enum AppLocaleMode {
  system('system', null),
  spanish('es', Locale('es')),
  english('en', Locale('en')),
  portuguese('pt', Locale('pt'));

  const AppLocaleMode(this.preferenceCode, this.locale);

  final String preferenceCode;
  final Locale? locale;

  static const fallback = AppLocaleMode.spanish;

  static const supportedLocales = [
    Locale('es'),
    Locale('en'),
    Locale('pt'),
  ];

  static AppLocaleMode fromPreferenceCode(String? value) {
    final normalized = normalizePreferenceCode(value);
    return switch (normalized) {
      'es' => AppLocaleMode.spanish,
      'en' => AppLocaleMode.english,
      'pt' => AppLocaleMode.portuguese,
      _ => AppLocaleMode.system,
    };
  }

  static AppLocaleMode fromLocale(Locale locale) {
    if (locale.languageCode == 'es') {
      return AppLocaleMode.spanish;
    }
    if (locale.languageCode == 'en') {
      return AppLocaleMode.english;
    }
    if (locale.languageCode == 'pt') {
      return AppLocaleMode.portuguese;
    }
    return fallback;
  }

  static String normalizePreferenceCode(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) {
      return AppLocaleMode.system.preferenceCode;
    }
    final normalized = raw.replaceAll('-', '_').toLowerCase();
    return switch (normalized) {
      'system' => AppLocaleMode.system.preferenceCode,
      'es' => AppLocaleMode.spanish.preferenceCode,
      'en' => AppLocaleMode.english.preferenceCode,
      'pt' => AppLocaleMode.portuguese.preferenceCode,
      _ => AppLocaleMode.system.preferenceCode,
    };
  }

  static String normalizeLocaleCode(String? value) {
    final normalized = normalizePreferenceCode(value);
    if (normalized == AppLocaleMode.system.preferenceCode) {
      return fallback.preferenceCode;
    }
    return normalized;
  }

  static Locale resolveSystemLocale(
    List<Locale>? locales,
    Iterable<Locale> supportedLocales,
  ) {
    final requestedLocales = locales ?? const <Locale>[];
    for (final locale in requestedLocales) {
      if (locale.languageCode == 'es') {
        return AppLocaleMode.spanish.locale!;
      }
      if (locale.languageCode == 'en') {
        return AppLocaleMode.english.locale!;
      }
      if (locale.languageCode == 'pt') {
        return AppLocaleMode.portuguese.locale!;
      }
    }
    return fallback.locale!;
  }

  static String resolveLocaleCodeFromPreference({
    required String localePreferenceCode,
    required Locale deviceLocale,
  }) {
    final mode = fromPreferenceCode(localePreferenceCode);
    if (mode != AppLocaleMode.system) {
      return mode.preferenceCode;
    }
    return fromLocale(deviceLocale).preferenceCode;
  }
}
