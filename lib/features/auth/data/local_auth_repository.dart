import 'dart:convert';

import '../../../core/security/biometric_service.dart';
import '../../../core/security/password_hasher.dart';
import '../../../core/security/secure_storage_service.dart';
import '../domain/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository({
    required SecureStorageService secureStorage,
    required PasswordHasher passwordHasher,
    required BiometricService biometricService,
  })  : _secureStorage = secureStorage,
        _passwordHasher = passwordHasher,
        _biometricService = biometricService;

  final SecureStorageService _secureStorage;
  final PasswordHasher _passwordHasher;
  final BiometricService _biometricService;

  @override
  Future<bool> hasCredential() {
    return _secureStorage.hasCredential();
  }

  @override
  Future<void> savePin(String pin) async {
    final credential = await _passwordHasher.hashPin(pin);
    await _secureStorage.saveCredential(jsonEncode(credential.toJson()));
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final payload = await _secureStorage.readCredential();
    if (payload == null) {
      return false;
    }

    final stored = StoredCredential.fromJson(
      jsonDecode(payload) as Map<String, dynamic>,
    );
    return _passwordHasher.verifyPin(pin, stored);
  }

  @override
  Future<bool> isBiometricAvailable() {
    return _biometricService.isAvailable();
  }

  @override
  Future<bool> isBiometricEnabled() {
    return _secureStorage.readBiometricEnabled();
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) {
    return _secureStorage.saveBiometricEnabled(enabled);
  }

  @override
  Future<bool> authenticateWithBiometrics() {
    return _biometricService.authenticate();
  }
}
