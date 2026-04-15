import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../finance/domain/repositories/categories_repository.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthRepository authRepository,
    required CategoriesRepository categoriesRepository,
  })  : _authRepository = authRepository,
        _categoriesRepository = categoriesRepository,
        super(const AuthState.initial());

  final AuthRepository _authRepository;
  final CategoriesRepository _categoriesRepository;
  DateTime? _pausedAt;

  Future<void> bootstrap() async {
    final hasCredential = await _authRepository.hasCredential();
    final biometricAvailable = await _authRepository.isBiometricAvailable();
    final biometricEnabled = await _authRepository.isBiometricEnabled();
    final recoveryConfigured = await _authRepository.hasRecoveryData();

    state = state.copyWith(
      status: hasCredential ? AuthStatus.locked : AuthStatus.setupRequired,
      biometricAvailable: biometricAvailable,
      biometricEnabled: biometricEnabled,
      recoveryConfigured: recoveryConfigured,
      clearError: true,
    );
  }

  Future<bool> createPin(
    String pin, {
    required String birthDate,
    required String documentId,
    bool enableBiometrics = false,
  }) async {
    if (pin.length != AppConstants.defaultPinLength) {
      state = state.copyWith(
        errorMessage:
            'El PIN debe tener ${AppConstants.defaultPinLength} dígitos.',
      );
      return false;
    }

    await _authRepository.savePin(pin);
    await _authRepository.saveRecoveryData(
      birthDate: birthDate,
      documentId: documentId,
    );
    if (enableBiometrics) {
      await _authRepository.setBiometricEnabled(true);
    }
    await _ensureFinanceSeed();

    state = state.copyWith(
      status: AuthStatus.unlocked,
      biometricEnabled: enableBiometrics,
      recoveryConfigured: true,
      clearError: true,
    );
    return true;
  }

  Future<bool> unlockWithPin(String pin) async {
    final valid = await _authRepository.verifyPin(pin);
    if (!valid) {
      state = state.copyWith(errorMessage: 'PIN incorrecto.');
      return false;
    }

    await _ensureFinanceSeed();
    state = state.copyWith(status: AuthStatus.unlocked, clearError: true);
    return true;
  }

  Future<bool> unlockWithBiometrics() async {
    final available = await _authRepository.isBiometricAvailable();
    if (!available) {
      state = state.copyWith(
        errorMessage: 'La biometría no está disponible en este dispositivo.',
      );
      return false;
    }

    bool authenticated;
    try {
      authenticated = await _authRepository.authenticateWithBiometrics();
    } catch (_) {
      state = state.copyWith(
        errorMessage:
            'No se pudo usar la biometría. Configurá una huella o bloqueo de pantalla en Android.',
      );
      return false;
    }
    if (!authenticated) {
      state = state.copyWith(
        errorMessage:
            'No se pudo validar la biometría. Verificá que tengas una huella y bloqueo de pantalla configurados.',
      );
      return false;
    }

    await _ensureFinanceSeed();
    state = state.copyWith(status: AuthStatus.unlocked, clearError: true);
    return true;
  }

  Future<bool> setBiometricEnabled(bool enabled) async {
    final available = await _authRepository.isBiometricAvailable();
    if (enabled && !available) {
      state = state.copyWith(
        errorMessage: 'La biometría no está disponible en este dispositivo.',
      );
      return false;
    }

    await _authRepository.setBiometricEnabled(enabled);
    state = state.copyWith(
      biometricAvailable: available,
      biometricEnabled: enabled,
      clearError: true,
    );
    return true;
  }

  Future<bool> recoverAccess({
    required String birthDate,
    required String documentId,
    required String newPin,
    bool enableBiometrics = false,
  }) async {
    if (newPin.length != AppConstants.defaultPinLength) {
      state = state.copyWith(
        errorMessage:
            'El PIN debe tener ${AppConstants.defaultPinLength} dígitos.',
      );
      return false;
    }

    final valid = await _authRepository.verifyRecoveryData(
      birthDate: birthDate,
      documentId: documentId,
    );
    if (!valid) {
      state = state.copyWith(
        errorMessage: 'Las respuestas de recuperación no coinciden.',
      );
      return false;
    }

    await _authRepository.savePin(newPin);
    if (enableBiometrics) {
      await _authRepository.setBiometricEnabled(true);
    }
    await _ensureFinanceSeed();
    state = state.copyWith(
      status: AuthStatus.unlocked,
      biometricEnabled: enableBiometrics,
      recoveryConfigured: true,
      clearError: true,
    );
    return true;
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void lock() {
    if (state.status == AuthStatus.unlocked) {
      state = state.copyWith(status: AuthStatus.locked, clearError: true);
    }
  }

  void onPaused() {
    _pausedAt = DateTime.now();
  }

  void onResumed(int autoLockMinutes) {
    if (_pausedAt == null || state.status != AuthStatus.unlocked) {
      return;
    }

    final elapsed = DateTime.now().difference(_pausedAt!);
    if (elapsed.inMinutes >= autoLockMinutes) {
      lock();
    }
    _pausedAt = null;
  }

  Future<void> _ensureFinanceSeed() {
    return _categoriesRepository.ensureSeedData();
  }
}
