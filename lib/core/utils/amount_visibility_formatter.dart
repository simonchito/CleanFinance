import 'currency_formatter.dart';

class AmountVisibilityFormatter {
  const AmountVisibilityFormatter._();

  static const String maskedAmount = '••••••';

  static String formatCurrency({
    required double amount,
    required String symbol,
    required bool isVisible,
  }) {
    if (isVisible) {
      return CurrencyFormatter.format(amount, symbol: symbol);
    }
    return '$symbol $maskedAmount';
  }
}
