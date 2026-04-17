import 'package:clean_finance/core/constants/app_constants.dart';
import 'package:clean_finance/core/utils/payment_method_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizes legacy default payment methods and adds QR', () {
    final result = PaymentMethodUtils.normalizeMethods(
      AppConstants.legacyDefaultPaymentMethods,
    );

    expect(result, AppConstants.defaultPaymentMethods);
  });

  test('canonicalizes known payment method labels', () {
    expect(
      PaymentMethodUtils.canonicalizeLabel('tarjeta debito'),
      PaymentMethodUtils.debitCard,
    );
    expect(
      PaymentMethodUtils.canonicalizeLabel('Tarjeta Credito'),
      PaymentMethodUtils.creditCard,
    );
    expect(
      PaymentMethodUtils.canonicalizeLabel('codigo qr'),
      PaymentMethodUtils.qr,
    );
  });

  test('keeps custom payment methods untouched', () {
    final result = PaymentMethodUtils.normalizeMethods([
      'Mercado Pago',
      'Cuenta DNI',
    ]);

    expect(result, ['Mercado Pago', 'Cuenta DNI']);
  });
}
