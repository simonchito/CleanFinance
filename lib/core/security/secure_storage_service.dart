import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorageService {
  static const _credentialKey = 'auth.credential';
  static const _biometricEnabledKey = 'auth.biometric_enabled';
  static const _recoveryBirthDateKey = 'auth.recovery.birth_date';
  static const _recoveryDocumentKey = 'auth.recovery.document';
  static const _pinSecurityStateKey = 'auth.pin_security_state';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveCredential(String payload) =>
      _guardWrite('save credential', () {
        return _storage.write(key: _credentialKey, value: payload);
      });

  Future<String?> readCredential() => _guardRead(
        'read credential',
        () => _storage.read(key: _credentialKey),
      );

  Future<bool> hasCredential() async {
    return (await readCredential()) != null;
  }

  Future<void> saveBiometricEnabled(bool enabled) => _guardWrite(
        'save biometric flag',
        () => _storage.write(
          key: _biometricEnabledKey,
          value: enabled ? '1' : '0',
        ),
      );

  Future<bool> readBiometricEnabled() async {
    return (await _guardRead(
          'read biometric flag',
          () => _storage.read(key: _biometricEnabledKey),
        )) ==
        '1';
  }

  Future<void> deleteBiometricEnabled() =>
      _guardWrite('delete biometric flag', () {
        return _storage.delete(key: _biometricEnabledKey);
      });

  Future<void> saveRecoveryBirthDate(String payload) =>
      _guardWrite('save recovery birth date', () {
        return _storage.write(key: _recoveryBirthDateKey, value: payload);
      });

  Future<void> saveRecoveryDocument(String payload) =>
      _guardWrite('save recovery document', () {
        return _storage.write(key: _recoveryDocumentKey, value: payload);
      });

  Future<String?> readRecoveryBirthDate() => _guardRead(
        'read recovery birth date',
        () => _storage.read(key: _recoveryBirthDateKey),
      );

  Future<String?> readRecoveryDocument() => _guardRead(
        'read recovery document',
        () => _storage.read(key: _recoveryDocumentKey),
      );

  Future<bool> hasRecoveryData() async {
    return (await readRecoveryBirthDate()) != null &&
        (await readRecoveryDocument()) != null;
  }

  Future<void> savePinSecurityState(String payload) =>
      _guardWrite('save pin security state', () {
        return _storage.write(key: _pinSecurityStateKey, value: payload);
      });

  Future<String?> readPinSecurityState() => _guardRead(
        'read pin security state',
        () => _storage.read(key: _pinSecurityStateKey),
      );

  Future<void> deletePinSecurityState() =>
      _guardWrite('delete pin security state', () {
        return _storage.delete(key: _pinSecurityStateKey);
      });

  Future<void> clearAll() => _guardWrite('clear secure storage', () {
        return _storage.deleteAll();
      });

  Future<String?> _guardRead(
    String action,
    Future<String?> Function() operation,
  ) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      debugPrint('[startup] Secure storage failed during $action: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> _guardWrite(
    String action,
    Future<void> Function() operation,
  ) async {
    try {
      await operation();
    } catch (error, stackTrace) {
      debugPrint('[startup] Secure storage failed during $action: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }
}
