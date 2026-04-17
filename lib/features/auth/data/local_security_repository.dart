import 'dart:convert';

import '../../../core/security/biometric_service.dart';
import '../../../core/security/password_hasher.dart';
import '../../../core/security/secure_storage_service.dart';
import '../../finance/domain/repositories/settings_repository.dart';
import '../domain/entities/pin_security_state.dart';
import '../domain/repositories/security_repository.dart';

class LocalSecurityRepository implements SecurityRepository {
  static const int _maxAttemptsBeforeLock = 5;
  static const int _baseLockSeconds = 30;
  static const int _maxLockSeconds = 300;

  LocalSecurityRepository({
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
    await _savePinSecurityState(const PinSecurityState.initial());
  }

  @override
  Future<PinVerificationResult> verifyPin(String pin) async {
    final normalizedState = await getPinSecurityState();
    if (normalizedState.isLocked) {
      return PinVerificationResult(
        status: PinVerificationStatus.locked,
        securityState: normalizedState,
      );
    }

    final payload = await _secureStorage.readCredential();
    if (payload == null) {
      return PinVerificationResult(
        status: PinVerificationStatus.invalidPin,
        securityState: normalizedState,
      );
    }

    final stored = StoredCredential.fromJson(
      jsonDecode(payload) as Map<String, dynamic>,
    );
    final valid = await _passwordHasher.verifyPin(pin, stored);
    if (valid) {
      const resetState = PinSecurityState.initial();
      await _savePinSecurityState(resetState);
      return const PinVerificationResult(
        status: PinVerificationStatus.success,
        securityState: resetState,
      );
    }

    final nextState = _buildNextFailureState(normalizedState);
    await _savePinSecurityState(nextState);
    return PinVerificationResult(
      status: nextState.isLocked
          ? PinVerificationStatus.locked
          : PinVerificationStatus.invalidPin,
      securityState: nextState,
    );
  }

  @override
  Future<PinSecurityState> getPinSecurityState() async {
    final payload = await _secureStorage.readPinSecurityState();
    if (payload == null || payload.isEmpty) {
      return const PinSecurityState.initial();
    }

    try {
      final state = PinSecurityState.fromJson(
        jsonDecode(payload) as Map<String, dynamic>,
      );
      if (state.lockedUntil != null && !state.isLocked) {
        final normalized = state.copyWith(clearLockedUntil: true);
        await _savePinSecurityState(normalized);
        return normalized;
      }
      return state;
    } catch (_) {
      await _secureStorage.deletePinSecurityState();
      return const PinSecurityState.initial();
    }
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

  Future<void> _savePinSecurityState(PinSecurityState state) {
    return _secureStorage.savePinSecurityState(jsonEncode(state.toJson()));
  }

  PinSecurityState _buildNextFailureState(PinSecurityState current) {
    final failedAttempts = current.failedAttempts + 1;
    if (failedAttempts < _maxAttemptsBeforeLock) {
      return current.copyWith(
        failedAttempts: failedAttempts,
        clearLockedUntil: true,
      );
    }

    final nextLevel = current.lockoutLevel + 1;
    final lockSeconds = _scaledLockSeconds(nextLevel);
    return PinSecurityState(
      failedAttempts: 0,
      lockoutLevel: nextLevel,
      lockedUntil: DateTime.now().add(Duration(seconds: lockSeconds)),
    );
  }

  int _scaledLockSeconds(int level) {
    final scaled = _baseLockSeconds * (1 << (level - 1));
    if (scaled > _maxLockSeconds) {
      return _maxLockSeconds;
    }
    return scaled;
  }
}
