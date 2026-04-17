import 'package:flutter/material.dart';

import '../../../../core/utils/payment_method_utils.dart';

abstract final class PaymentMethodIconResolver {
  static IconData resolve(String method) {
    final normalized = PaymentMethodUtils.normalizedKey(method);

    if (normalized.contains('qr')) {
      return Icons.qr_code_2_rounded;
    }
    if (normalized.contains('transfer') ||
        normalized.contains('cbu') ||
        normalized.contains('alias')) {
      return Icons.sync_alt_rounded;
    }
    if (normalized.contains('debito') ||
        normalized.contains('credito') ||
        normalized.contains('tarjeta') ||
        normalized.contains('visa') ||
        normalized.contains('master')) {
      return Icons.credit_card_rounded;
    }
    if (normalized.contains('efectivo') || normalized.contains('cash')) {
      return Icons.payments_rounded;
    }

    return Icons.account_balance_wallet_outlined;
  }
}
