import '../constants/app_constants.dart';

abstract final class PaymentMethodUtils {
  static const String transfer = 'transfer';
  static const String debitCard = 'debit_card';
  static const String creditCard = 'credit_card';
  static const String cash = 'cash';
  static const String qr = 'qr';
  static const String unspecified = 'unspecified';

  static List<String> normalizeMethods(Iterable<String> methods) {
    final normalized = <String>[];
    final seen = <String>{};

    for (final method in methods) {
      final canonical = canonicalizeLabel(method);
      if (canonical.isEmpty) {
        continue;
      }
      final key = _normalize(canonical);
      if (seen.add(key)) {
        normalized.add(canonical);
      }
    }

    if (normalized.isEmpty) {
      return AppConstants.defaultPaymentMethods;
    }

    if (_matchesLegacyDefaultBundle(normalized)) {
      return AppConstants.defaultPaymentMethods;
    }

    return normalized;
  }

  static String canonicalizeLabel(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    switch (_normalize(trimmed)) {
      case 'transfer':
      case 'transferencia':
      case 'banktransfer':
      case 'wiretransfer':
        return transfer;
      case 'debitcard':
      case 'tarjetadebito':
      case 'tarjetadedebito':
      case 'debito':
      case 'cartao-debito':
      case 'cartaodebito':
      case 'cartaodedebito':
        return debitCard;
      case 'creditcard':
      case 'tarjetacredito':
      case 'tarjetadecredito':
      case 'credito':
      case 'cartao-credito':
      case 'cartaocredito':
      case 'cartaodecredito':
        return creditCard;
      case 'efectivo':
      case 'cash':
      case 'dinheiro':
        return cash;
      case 'qr':
      case 'codigoqr':
        return qr;
      case 'sindefinir':
      case 'unspecified':
      case 'undefined':
      case 'naodefinido':
        return unspecified;
      default:
        return trimmed;
    }
  }

  static String normalizedKey(String raw) => _normalize(raw);

  static bool isKnownDefault(String raw) {
    return switch (canonicalizeLabel(raw)) {
      transfer || debitCard || creditCard || cash || qr || unspecified => true,
      _ => false,
    };
  }

  static bool _matchesLegacyDefaultBundle(List<String> methods) {
    if (methods.length != AppConstants.legacyDefaultPaymentMethods.length) {
      return false;
    }

    final normalized = methods.map(_normalize).toSet();
    final legacy = AppConstants.legacyDefaultPaymentMethods
        .map(canonicalizeLabel)
        .map(_normalize)
        .toSet();
    final currentWithoutQr = AppConstants.defaultPaymentMethods
        .where((method) => method != qr)
        .map(_normalize)
        .toSet();

    return _sameElements(normalized, legacy) ||
        _sameElements(normalized, currentWithoutQr);
  }

  static bool _sameElements(Set<String> left, Set<String> right) {
    return left.length == right.length && left.containsAll(right);
  }

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ê', 'e')
        .replaceAll('ô', 'o')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}
