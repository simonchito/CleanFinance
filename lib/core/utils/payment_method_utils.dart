import '../constants/app_constants.dart';

abstract final class PaymentMethodUtils {
  static const String transfer = 'Transferencia';
  static const String debitCard = 'Tarjeta débito';
  static const String creditCard = 'Tarjeta crédito';
  static const String cash = 'Efectivo';
  static const String qr = 'QR';

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
      case 'transferencia':
        return transfer;
      case 'tarjetadebito':
      case 'tarjetadedebito':
      case 'debito':
        return debitCard;
      case 'tarjetacredito':
      case 'tarjetadecredito':
      case 'credito':
        return creditCard;
      case 'efectivo':
      case 'cash':
        return cash;
      case 'qr':
      case 'codigoqr':
        return qr;
      default:
        return trimmed;
    }
  }

  static String normalizedKey(String raw) => _normalize(raw);

  static bool _matchesLegacyDefaultBundle(List<String> methods) {
    if (methods.length != AppConstants.legacyDefaultPaymentMethods.length) {
      return false;
    }

    final normalized = methods.map(_normalize).toSet();
    final legacy =
        AppConstants.legacyDefaultPaymentMethods.map(_normalize).toSet();
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
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}
