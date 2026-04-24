import 'package:flutter/material.dart';

import '../../../../core/utils/payment_method_utils.dart';

abstract final class PaymentMethodIconResolver {
  static IconData resolve(String method) {
    final canonical = PaymentMethodUtils.canonicalizeLabel(method);
    final normalized = PaymentMethodUtils.normalizedKey(method);

    if (canonical == PaymentMethodUtils.qr || normalized.contains('qr')) {
      return Icons.qr_code_2_rounded;
    }
    if (canonical == PaymentMethodUtils.transfer ||
        normalized.contains('transfer') ||
        normalized.contains('cbu') ||
        normalized.contains('alias')) {
      return Icons.sync_alt_rounded;
    }
    if (canonical == PaymentMethodUtils.debitCard ||
        canonical == PaymentMethodUtils.creditCard ||
        normalized.contains('debit') ||
        normalized.contains('credit') ||
        normalized.contains('debito') ||
        normalized.contains('credito') ||
        normalized.contains('tarjeta') ||
        normalized.contains('cartao') ||
        normalized.contains('visa') ||
        normalized.contains('master')) {
      return Icons.credit_card_rounded;
    }
    if (canonical == PaymentMethodUtils.cash ||
        normalized.contains('efectivo') ||
        normalized.contains('cash') ||
        normalized.contains('dinheiro')) {
      return Icons.payments_rounded;
    }

    return Icons.account_balance_wallet_outlined;
  }
}
