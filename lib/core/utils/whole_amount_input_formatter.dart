import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import 'currency_formatter.dart';

class WholeAmountInputFormatter extends TextInputFormatter {
  WholeAmountInputFormatter({
    this.localeCode = AppConstants.defaultLocaleCode,
  });

  final String localeCode;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = CurrencyFormatter.extractWholeAmountDigits(
      newValue.text,
      localeCode: localeCode,
    );
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final formatted = CurrencyFormatter.formatGroupedDigits(
      digits,
      localeCode: localeCode,
    );
    final digitsBeforeCursor = _countDigitsBeforeCursor(newValue);
    final selectionOffset = _selectionOffsetForDigitCount(
      formatted,
      digitsBeforeCursor,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
  }

  int _countDigitsBeforeCursor(TextEditingValue value) {
    final rawOffset = value.selection.extentOffset;
    final safeOffset = rawOffset < 0 ? value.text.length : rawOffset;
    return value.text
        .substring(0, safeOffset.clamp(0, value.text.length))
        .replaceAll(RegExp(r'\D'), '')
        .length;
  }

  int _selectionOffsetForDigitCount(String text, int digitCount) {
    if (digitCount <= 0) {
      return 0;
    }

    var seenDigits = 0;
    for (var index = 0; index < text.length; index++) {
      if (RegExp(r'\d').hasMatch(text[index])) {
        seenDigits++;
        if (seenDigits == digitCount) {
          return index + 1;
        }
      }
    }

    return text.length;
  }
}
