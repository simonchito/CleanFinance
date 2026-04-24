class AppConstants {
  static const appName = 'CleanFinance';
  static const databaseName = 'clean_finance.db';
  static const databaseVersion = 8;
  static const defaultCurrencyCode = 'ARS';
  static const defaultCurrencySymbol = r'$';
  static const defaultShowSensitiveAmounts = true;
  static const defaultAutoLockMinutes = 5;
  static const defaultPinLength = 6;
  static const defaultLocalePreferenceCode = 'system';
  static const defaultLocaleCode = 'es';
  static const supportedLocaleCodes = ['es', 'en'];
  static const supportedLocalePreferenceCodes = ['system', 'es', 'en'];
  static const defaultPaymentMethods = [
    'Transferencia',
    'Tarjeta débito',
    'Tarjeta crédito',
    'Efectivo',
    'QR',
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
    final normalized = rawValue?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return defaultLocalePreferenceCode;
    }
    if (isSupportedLocalePreferenceCode(normalized)) {
      return normalized;
    }
    return defaultLocalePreferenceCode;
  }

  static String normalizeLocaleCode(
    String? rawValue, {
    String fallback = defaultLocaleCode,
  }) {
    final normalized = rawValue?.trim().toLowerCase();
    if (normalized != null && isSupportedLocaleCode(normalized)) {
      return normalized;
    }
    if (isSupportedLocaleCode(fallback)) {
      return fallback;
    }
    return defaultLocaleCode;
  }

  static String resolveLocaleCodeFromPreference({
    required String localePreferenceCode,
    required String deviceLocaleCode,
  }) {
    final normalizedPreference =
        normalizeLocalePreferenceCode(localePreferenceCode);
    if (normalizedPreference != defaultLocalePreferenceCode) {
      return normalizeLocaleCode(normalizedPreference);
    }
    return normalizeLocaleCode(deviceLocaleCode);
  }
}
