import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../finance/domain/repositories/finance_repository.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthRepository authRepository,
    required FinanceRepository financeRepository,
  })  : _authRepository = authRepository,
        _financeRepository = financeRepository,
        super(const AuthState.initial());

  final AuthRepository _authRepository;
  final FinanceRepository _financeRepository;
  DateTime? _pausedAt;

  Future<void> bootstrap() async {
    final hasCredential = await _authRepository.hasCredential();
    final biometricAvailable = await _authRepository.isBiometricAvailable();
    final biometricEnabled = await _authRepository.isBiometricEnabled();

    state = state.copyWith(
      status: hasCredential ? AuthStatus.locked : AuthStatus.setupRequired,
      biometricAvailable: biometricAvailable,
      biometricEnabled: biometricEnabled,
      clearError: true,
    );
  }

  Future<bool> createPin(String pin) async {
    if (pin.length != AppConstants.defaultPinLength) {
      state = state.copyWith(
        errorMessage:
            'El PIN debe tener ${AppConstants.defaultPinLength} dígitos.',
      );
      return false;
    }

    await _authRepository.savePin(pin);
    await _financeRepository.ensureSeedData();

    state = state.copyWith(
      status: AuthStatus.unlocked,
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

    final authenticated = await _authRepository.authenticateWithBiometrics();
    if (!authenticated) {
      state = state.copyWith(
        errorMessage: 'No se pudo validar la biometría.',
      );
      return false;
    }

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
}
