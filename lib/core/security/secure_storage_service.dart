import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _credentialKey = 'auth.credential';
  static const _biometricEnabledKey = 'auth.biometric_enabled';
  static const _recoveryBirthDateKey = 'auth.recovery.birth_date';
  static const _recoveryDocumentKey = 'auth.recovery.document';
  static const _pinSecurityStateKey = 'auth.pin_security_state';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveCredential(String payload) {
    return _storage.write(key: _credentialKey, value: payload);
  }

  Future<String?> readCredential() {
    return _storage.read(key: _credentialKey);
  }

  Future<bool> hasCredential() async {
    return (await readCredential()) != null;
  }

  Future<void> saveBiometricEnabled(bool enabled) {
    return _storage.write(
      key: _biometricEnabledKey,
      value: enabled ? '1' : '0',
    );
  }

  Future<bool> readBiometricEnabled() async {
    return (await _storage.read(key: _biometricEnabledKey)) == '1';
  }

  Future<void> deleteBiometricEnabled() {
    return _storage.delete(key: _biometricEnabledKey);
  }

  Future<void> saveRecoveryBirthDate(String payload) {
    return _storage.write(key: _recoveryBirthDateKey, value: payload);
  }

  Future<void> saveRecoveryDocument(String payload) {
    return _storage.write(key: _recoveryDocumentKey, value: payload);
  }

  Future<String?> readRecoveryBirthDate() {
    return _storage.read(key: _recoveryBirthDateKey);
  }

  Future<String?> readRecoveryDocument() {
    return _storage.read(key: _recoveryDocumentKey);
  }

  Future<bool> hasRecoveryData() async {
    return (await readRecoveryBirthDate()) != null &&
        (await readRecoveryDocument()) != null;
  }

  Future<void> savePinSecurityState(String payload) {
    return _storage.write(key: _pinSecurityStateKey, value: payload);
  }

  Future<String?> readPinSecurityState() {
    return _storage.read(key: _pinSecurityStateKey);
  }

  Future<void> deletePinSecurityState() {
    return _storage.delete(key: _pinSecurityStateKey);
  }

  Future<void> clearAll() => _storage.deleteAll();
}
