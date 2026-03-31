import 'currency_formatter.dart';

class AmountVisibilityFormatter {
  const AmountVisibilityFormatter._();

  static const String maskedAmount = '••••••';

  static String formatCurrency({
    required double amount,
    required String symbol,
    required bool isVisible,
    String localeCode = 'es',
  }) {
    if (isVisible) {
      return CurrencyFormatter.format(
        amount,
        symbol: symbol,
        localeCode: localeCode,
      );
    }
    return '$symbol $maskedAmount';
  }
}
