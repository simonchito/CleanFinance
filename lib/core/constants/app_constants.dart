import '../localization/app_locale_mode.dart';

class AppConstants {
  static const appName = 'CleanFinance';
  static const databaseName = 'clean_finance.db';
  static const databaseVersion = 9;
  static const defaultCurrencyCode = 'ARS';
  static const defaultCurrencySymbol = r'$';
  static const defaultShowSensitiveAmounts = true;
  static const defaultAutoLockMinutes = 5;
  static const defaultPinLength = 6;
  static const defaultLocalePreferenceCode = 'system';
  static const defaultLocaleCode = 'es';
  static const supportedLocaleCodes = ['es', 'en', 'pt_BR'];
  static const supportedLocalePreferenceCodes = ['system', 'es', 'en', 'pt_BR'];
  static const defaultPaymentMethods = [
    'transfer',
    'debit_card',
    'credit_card',
    'cash',
    'qr',
  ];

  static const legacyDefaultPaymentMethods = [
    'Transferencia',
    'Tarjeta Debito',
    'Tarjeta Credito',
    'Efectivo',
  ];

  static bool isSupportedLocaleCode(String value) {
    return supportedLocaleCodes.contains(value);
  }

  static bool isSupportedLocalePreferenceCode(String value) {
    return supportedLocalePreferenceCodes.contains(value);
  }

  static String normalizeLocalePreferenceCode(String? rawValue) {
    return AppLocaleMode.normalizePreferenceCode(rawValue);
  }

  static String normalizeLocaleCode(
    String? rawValue, {
    String fallback = defaultLocaleCode,
  }) {
    final normalized = AppLocaleMode.normalizeLocaleCode(rawValue);
    if (isSupportedLocaleCode(normalized)) {
      return normalized;
    }
    return AppLocaleMode.normalizeLocaleCode(fallback);
  }

  static String resolveLocaleCodeFromPreference({
    required String localePreferenceCode,
    required String deviceLocaleCode,
  }) {
    final normalizedPreference = normalizeLocalePreferenceCode(
      localePreferenceCode,
    );
    if (normalizedPreference != defaultLocalePreferenceCode) {
      return normalizeLocaleCode(normalizedPreference);
    }
    return normalizeLocaleCode(deviceLocaleCode);
  }
}
