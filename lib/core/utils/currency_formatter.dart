import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  // Product rule: all displayed amounts use whole units only, truncating
  // cents toward zero before formatting.
  static int truncateToWholeAmount(num amount) => amount.truncate();

  static String format(
    num amount, {
    String symbol = r'$',
    String localeCode = AppConstants.defaultLocaleCode,
  }) {
    return NumberFormat.currency(
      locale: _resolveLocale(localeCode),
      symbol: symbol,
      decimalDigits: 0,
    ).format(truncateToWholeAmount(amount));
  }

  static String formatWholeNumber(
    num amount, {
    String localeCode = AppConstants.defaultLocaleCode,
  }) {
    return NumberFormat.decimalPattern(
      _resolveLocale(localeCode),
    ).format(truncateToWholeAmount(amount));
  }

  static String formatGroupedDigits(
    String digits, {
    String localeCode = AppConstants.defaultLocaleCode,
  }) {
    final sanitizedDigits = extractWholeAmountDigits(
      digits,
      localeCode: localeCode,
    );
    if (sanitizedDigits.isEmpty) {
      return '';
    }

    final groupingSeparator = _groupingSeparator(localeCode);
    final buffer = StringBuffer();

    for (var index = 0; index < sanitizedDigits.length; index++) {
      if (index > 0 && (sanitizedDigits.length - index) % 3 == 0) {
        buffer.write(groupingSeparator);
      }
      buffer.write(sanitizedDigits[index]);
    }

    return buffer.toString();
  }

  static double? tryParseWholeAmount(
    String text, {
    String localeCode = AppConstants.defaultLocaleCode,
  }) {
    final compact = extractWholeAmountDigits(text, localeCode: localeCode);
    if (compact.isEmpty) {
      return null;
    }

    return double.tryParse(compact);
  }

  static String extractWholeAmountDigits(
    String text, {
    String localeCode = AppConstants.defaultLocaleCode,
  }) {
    final integerPortion = _stripDecimalPortion(
      text.trim(),
      localeCode: localeCode,
    );
    final digits = integerPortion.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '';
    }

    return digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
  }

  static String _resolveLocale(String localeCode) {
    return switch (localeCode) {
      'en' => 'en_US',
      'es' => 'es_AR',
      'pt' => 'pt_BR',
      _ => localeCode,
    };
  }

  static String _groupingSeparator(String localeCode) {
    return NumberFormat.decimalPattern(_resolveLocale(localeCode))
        .symbols
        .GROUP_SEP;
  }

  static String _decimalSeparator(String localeCode) {
    return NumberFormat.decimalPattern(_resolveLocale(localeCode))
        .symbols
        .DECIMAL_SEP;
  }

  static String _stripDecimalPortion(
    String text, {
    required String localeCode,
  }) {
    if (text.isEmpty) {
      return text;
    }

    final localeDecimalSeparator = _decimalSeparator(localeCode);
    final localeCut = _cutAtDecimalSeparator(text, localeDecimalSeparator);
    if (localeCut != text) {
      return localeCut;
    }

    final alternateDecimalSeparator = localeDecimalSeparator == '.' ? ',' : '.';
    return _cutAtSingleAlternateDecimal(
      text,
      alternateDecimalSeparator,
    );
  }

  static String _cutAtDecimalSeparator(String text, String separator) {
    final separatorIndex = text.lastIndexOf(separator);
    if (separatorIndex <= 0 || separatorIndex >= text.length - 1) {
      return text;
    }

    final suffix = text.substring(separatorIndex + separator.length);
    if (!RegExp(r'^\d{1,2}$').hasMatch(suffix)) {
      return text;
    }

    return text.substring(0, separatorIndex);
  }

  static String _cutAtSingleAlternateDecimal(String text, String separator) {
    final firstIndex = text.indexOf(separator);
    if (firstIndex <= 0 || firstIndex != text.lastIndexOf(separator)) {
      return text;
    }

    final suffix = text.substring(firstIndex + separator.length);
    if (!RegExp(r'^\d{1,2}$').hasMatch(suffix)) {
      return text;
    }

    return text.substring(0, firstIndex);
  }
}
