import 'package:clean_finance/core/utils/currency_formatter.dart';
import 'package:clean_finance/core/utils/whole_amount_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formats currency without cents and truncates toward zero', () {
      final positive =
          CurrencyFormatter.format(15000.9, symbol: r'$', localeCode: 'es');
      final negative =
          CurrencyFormatter.format(-15000.9, symbol: r'$', localeCode: 'es');

      expect(positive, contains('15.000'));
      expect(positive, contains(r'$'));
      expect(positive, isNot(contains(',')));

      expect(negative, contains('-15.000'));
      expect(negative, contains(r'$'));
      expect(negative, isNot(contains(',')));
    });

    test('parses whole grouped amounts safely', () {
      expect(
        CurrencyFormatter.tryParseWholeAmount('1.234.567', localeCode: 'es'),
        1234567,
      );
      expect(
        CurrencyFormatter.tryParseWholeAmount('1,234,567', localeCode: 'en'),
        1234567,
      );
      expect(
        CurrencyFormatter.tryParseWholeAmount('1.234,50', localeCode: 'es'),
        1234,
      );
      expect(
        CurrencyFormatter.tryParseWholeAmount('1000.50', localeCode: 'es'),
        1000,
      );
    });
  });

  group('WholeAmountInputFormatter', () {
    test('adds grouping separators while typing', () {
      final formatter = WholeAmountInputFormatter(localeCode: 'es');

      final formatted = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '100',
          selection: TextSelection.collapsed(offset: 3),
        ),
        const TextEditingValue(
          text: '1000',
          selection: TextSelection.collapsed(offset: 4),
        ),
      );

      expect(formatted.text, '1.000');
      expect(formatted.selection.baseOffset, 5);
    });

    test('ignores decimal separators and keeps whole digits', () {
      final formatter = WholeAmountInputFormatter(localeCode: 'es');

      final formatted = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '1.000',
          selection: TextSelection.collapsed(offset: 5),
        ),
        const TextEditingValue(
          text: '1.000,50',
          selection: TextSelection.collapsed(offset: 8),
        ),
      );

      expect(formatted.text, '1.000');
    });
  });
}
