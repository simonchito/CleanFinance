import 'dart:convert';

import '../../../core/security/biometric_service.dart';
import '../../../core/security/password_hasher.dart';
import '../../../core/security/secure_storage_service.dart';
import '../../finance/domain/repositories/settings_repository.dart';
import '../domain/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository({
    required SecureStorageService secureStorage,
    required PasswordHasher passwordHasher,
    required BiometricService biometricService,
    required SettingsRepository settingsRepository,
  })  : _secureStorage = secureStorage,
        _passwordHasher = passwordHasher,
        _biometricService = biometricService,
        _settingsRepository = settingsRepository;

  final SecureStorageService _secureStorage;
  final PasswordHasher _passwordHasher;
  final BiometricService _biometricService;
  final SettingsRepository _settingsRepository;

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
  Future<void> saveRecoveryData({
    required String birthDate,
    required String documentId,
  }) async {
    final birthDateCredential =
        await _passwordHasher.hashSecret(_normalizeBirthDate(birthDate));
    final documentCredential =
        await _passwordHasher.hashSecret(_normalizeDocument(documentId));
    await _secureStorage.saveRecoveryBirthDate(
      jsonEncode(birthDateCredential.toJson()),
    );
    await _secureStorage.saveRecoveryDocument(
      jsonEncode(documentCredential.toJson()),
    );
  }

  @override
  Future<bool> hasRecoveryData() {
    return _secureStorage.hasRecoveryData();
  }

  @override
  Future<bool> verifyRecoveryData({
    required String birthDate,
    required String documentId,
  }) async {
    final birthDatePayload = await _secureStorage.readRecoveryBirthDate();
    final documentPayload = await _secureStorage.readRecoveryDocument();
    if (birthDatePayload == null || documentPayload == null) {
      return false;
    }

    final birthDateStored = StoredCredential.fromJson(
      jsonDecode(birthDatePayload) as Map<String, dynamic>,
    );
    final documentStored = StoredCredential.fromJson(
      jsonDecode(documentPayload) as Map<String, dynamic>,
    );

    final validBirthDate = await _passwordHasher.verifySecret(
      _normalizeBirthDate(birthDate),
      birthDateStored,
    );
    final validDocument = await _passwordHasher.verifySecret(
      _normalizeDocument(documentId),
      documentStored,
    );
    return validBirthDate && validDocument;
  }

  @override
  Future<bool> isBiometricAvailable() {
    return _biometricService.isAvailable();
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final settings = await _settingsRepository.getSettings();
    final legacyEnabled = await _secureStorage.readBiometricEnabled();
    final available = await isBiometricAvailable();

    if (!settings.biometricEnabled && legacyEnabled) {
      final migratedEnabled = available;
      await _settingsRepository.saveSettings(
        settings.copyWith(biometricEnabled: migratedEnabled),
      );
      await _secureStorage.deleteBiometricEnabled();
      return migratedEnabled;
    }

    if (settings.biometricEnabled && !available) {
      await _settingsRepository.saveSettings(
        settings.copyWith(biometricEnabled: false),
      );
      await _secureStorage.deleteBiometricEnabled();
      return false;
    }

    if (legacyEnabled != settings.biometricEnabled) {
      await _secureStorage.deleteBiometricEnabled();
    }

    return settings.biometricEnabled;
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    final settings = await _settingsRepository.getSettings();
    final available = enabled ? await isBiometricAvailable() : false;
    await _settingsRepository.saveSettings(
      settings.copyWith(biometricEnabled: enabled && available),
    );
    await _secureStorage.deleteBiometricEnabled();
  }

  @override
  Future<bool> authenticateWithBiometrics() {
    return _biometricService.authenticate();
  }

  String _normalizeBirthDate(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String _normalizeDocument(String value) {
    return value.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '').toUpperCase();
  }
}
