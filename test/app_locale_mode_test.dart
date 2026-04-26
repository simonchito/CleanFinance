import 'package:clean_finance/core/localization/app_locale_mode.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocaleMode', () {
    test('normalizes saved locale preferences', () {
      expect(
        AppLocaleMode.fromPreferenceCode('system'),
        AppLocaleMode.system,
      );
      expect(AppLocaleMode.fromPreferenceCode('es'), AppLocaleMode.spanish);
      expect(AppLocaleMode.fromPreferenceCode('en'), AppLocaleMode.english);
      expect(
        AppLocaleMode.fromPreferenceCode('pt-BR'),
        AppLocaleMode.portuguese,
      );
      expect(AppLocaleMode.fromPreferenceCode('fr'), AppLocaleMode.system);
    });

    test('resolves supported device locales with Spanish fallback', () {
      expect(
        AppLocaleMode.resolveSystemLocale(
          const [Locale('pt', 'BR')],
          AppLocaleMode.supportedLocales,
        ),
        const Locale('pt', 'BR'),
      );
      expect(
        AppLocaleMode.resolveSystemLocale(
          const [Locale('fr', 'FR')],
          AppLocaleMode.supportedLocales,
        ),
        const Locale('es'),
      );
    });

    test('manual preference wins over device locale', () {
      expect(
        AppLocaleMode.resolveLocaleCodeFromPreference(
          localePreferenceCode: 'en',
          deviceLocale: const Locale('es'),
        ),
        'en',
      );
      expect(
        AppLocaleMode.resolveLocaleCodeFromPreference(
          localePreferenceCode: 'system',
          deviceLocale: const Locale('pt', 'BR'),
        ),
        'pt',
      );
    });
  });
}
