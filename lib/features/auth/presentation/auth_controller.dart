import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../finance/domain/repositories/categories_repository.dart';
import '../domain/entities/pin_security_state.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  static const _authOperationTimeout = Duration(seconds: 30);

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
    if (kDebugMode) {
      debugPrint('[startup] Auth bootstrap begin');
    }

    final hasCredential = await _safeStartupStep<bool>(
      'read stored credential',
      _authRepository.hasCredential,
      fallback: false,
    );
    final recoveryConfigured = await _safeStartupStep<bool>(
      'read recovery data',
      _authRepository.hasRecoveryData,
      fallback: false,
    );
    final pinSecurityState = await _safeStartupStep<PinSecurityState>(
      'read pin security state',
      _authRepository.getPinSecurityState,
      fallback: const PinSecurityState.initial(),
    );
    final biometricAvailable = await _safeStartupStep<bool>(
      'detect biometric availability',
      _authRepository.isBiometricAvailable,
      fallback: false,
    );
    final biometricEnabled = biometricAvailable
        ? await _safeStartupStep<bool>(
            'read biometric setting',
            _authRepository.isBiometricEnabled,
            fallback: false,
          )
        : false;

    state = state.copyWith(
      status: hasCredential ? AuthStatus.locked : AuthStatus.setupRequired,
      biometricAvailable: biometricAvailable,
      biometricEnabled: biometricEnabled,
      recoveryConfigured: recoveryConfigured,
      pinSecurityState: pinSecurityState,
    );
    if (kDebugMode) {
      debugPrint(
        '[startup] Auth bootstrap done. status=${state.status.name}, '
        'biometricAvailable=$biometricAvailable, biometricEnabled=$biometricEnabled',
      );
    }
  }

  Future<bool> createPin(
    String pin, {
    required String birthDate,
    required String documentId,
    bool enableBiometrics = false,
  }) async {
    return _guardAuthOperation('create PIN', () async {
      if (!_isValidPinLength(pin)) {
        state = state.copyWith(
          error: const AuthErrorState(
            code: AuthErrorCode.pinLengthInvalid,
          ),
        );
        return false;
      }
      if (!_isValidRecoveryBirthDate(birthDate) ||
          !_isValidRecoveryDocument(documentId)) {
        state = state.copyWith(
          error: const AuthErrorState(
            code: AuthErrorCode.recoveryDataInvalid,
          ),
        );
        return false;
      }

      await _authRepository.savePin(pin);
      await _authRepository.saveRecoveryData(
        birthDate: birthDate,
        documentId: documentId,
      );
      await _authRepository.setBiometricEnabled(enableBiometrics);
      final biometricEnabled =
          enableBiometrics && await _authRepository.isBiometricEnabled();
      await _ensureFinanceSeed();

      state = state.copyWith(
        status: AuthStatus.unlocked,
        biometricEnabled: biometricEnabled,
        recoveryConfigured: true,
        pinSecurityState: const PinSecurityState.initial(),
        clearError: true,
      );
      return true;
    });
  }

  Future<bool> unlockWithPin(String pin) async {
    return _guardAuthOperation('unlock with PIN', () async {
      if (kDebugMode) {
        debugPrint('[auth] Verifying PIN');
      }
      final result = await _authRepository.verifyPin(pin);
      if (!result.isSuccess) {
        state = state.copyWith(
          pinSecurityState: result.securityState,
          error: result.isLocked
              ? _lockoutError(result.securityState)
              : const AuthErrorState(
                  code: AuthErrorCode.incorrectPin,
                ),
        );
        return false;
      }

      if (kDebugMode) {
        debugPrint('[auth] PIN verified, preparing finance data');
      }
      await _ensureFinanceSeed();
      state = state.copyWith(
        status: AuthStatus.unlocked,
        pinSecurityState: result.securityState,
        clearError: true,
      );
      return true;
    });
  }

  Future<bool> unlockWithBiometrics() async {
    final available = await _authRepository.isBiometricAvailable();
    if (!available) {
      state = state.copyWith(
        error: const AuthErrorState(
          code: AuthErrorCode.biometricUnavailable,
        ),
      );
      return false;
    }

    bool authenticated;
    try {
      authenticated = await _authRepository.authenticateWithBiometrics();
    } catch (_) {
      state = state.copyWith(
        error: const AuthErrorState(
          code: AuthErrorCode.biometricAuthUnavailable,
        ),
      );
      return false;
    }
    if (!authenticated) {
      state = state.copyWith(
        error: const AuthErrorState(
          code: AuthErrorCode.biometricAuthFailed,
        ),
      );
      return false;
    }

    await _ensureFinanceSeed();
    state = state.copyWith(status: AuthStatus.unlocked, clearError: true);
    return true;
  }

  Future<bool> setBiometricEnabled(bool enabled) async {
    return _guardAuthOperation('set biometric preference', () async {
      final available = await _authRepository.isBiometricAvailable();
      if (enabled && !available) {
        state = state.copyWith(
          biometricAvailable: available,
          biometricEnabled: false,
          error: const AuthErrorState(
            code: AuthErrorCode.biometricUnavailable,
          ),
        );
        return false;
      }

      await _authRepository.setBiometricEnabled(enabled);
      state = state.copyWith(
        biometricAvailable: available,
        biometricEnabled: enabled && available,
        clearError: true,
      );
      return true;
    });
  }

  Future<bool> recoverAccess({
    required String birthDate,
    required String documentId,
    required String newPin,
    bool enableBiometrics = false,
  }) async {
    return _guardAuthOperation('recover access', () async {
      if (!_isValidPinLength(newPin)) {
        state = state.copyWith(
          error: const AuthErrorState(
            code: AuthErrorCode.pinLengthInvalid,
          ),
        );
        return false;
      }
      if (!_isValidRecoveryBirthDate(birthDate) ||
          !_isValidRecoveryDocument(documentId)) {
        state = state.copyWith(
          error: const AuthErrorState(
            code: AuthErrorCode.recoveryDataInvalid,
          ),
        );
        return false;
      }

      final valid = await _authRepository.verifyRecoveryData(
        birthDate: birthDate,
        documentId: documentId,
      );
      if (!valid) {
        state = state.copyWith(
          error: const AuthErrorState(
            code: AuthErrorCode.recoveryVerificationFailed,
          ),
        );
        return false;
      }

      await _authRepository.savePin(newPin);
      await _authRepository.setBiometricEnabled(enableBiometrics);
      final biometricEnabled =
          enableBiometrics && await _authRepository.isBiometricEnabled();
      await _ensureFinanceSeed();
      state = state.copyWith(
        status: AuthStatus.unlocked,
        biometricEnabled: biometricEnabled,
        recoveryConfigured: true,
        pinSecurityState: const PinSecurityState.initial(),
        clearError: true,
      );
      return true;
    });
  }

  Future<void> refreshPinSecurityState() async {
    final pinSecurityState = await _authRepository.getPinSecurityState();
    state =
        state.copyWith(pinSecurityState: pinSecurityState, clearError: true);
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

  Future<bool> _guardAuthOperation(
    String label,
    Future<bool> Function() action,
  ) async {
    try {
      return await action().timeout(_authOperationTimeout);
    } on TimeoutException catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[auth] Auth operation timed out: $label -> $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      state = state.copyWith(
        error: const AuthErrorState(code: AuthErrorCode.authOperationFailed),
      );
      return false;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[auth] Auth operation failed: $label -> $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      state = state.copyWith(
        error: const AuthErrorState(code: AuthErrorCode.authOperationFailed),
      );
      return false;
    }
  }

  Future<T> _safeStartupStep<T>(
    String label,
    Future<T> Function() action, {
    required T fallback,
  }) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[startup] Auth bootstrap step failed: $label -> $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      state = state.copyWith(
        error: const AuthErrorState(
          code: AuthErrorCode.startupSafetyMode,
        ),
      );
      return fallback;
    }
  }

  bool _isValidRecoveryBirthDate(String value) {
    final normalized = value.replaceAll(RegExp(r'[^0-9]'), '');
    return normalized.length == 8;
  }

  bool _isValidPinLength(String value) {
    return value.length >= AppConstants.minPinLength &&
        value.length <= AppConstants.maxPinLength;
  }

  bool _isValidRecoveryDocument(String value) {
    final normalized =
        value.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '').toUpperCase();
    return normalized.length >= 6 && normalized.length <= 16;
  }

  AuthErrorState _lockoutError(PinSecurityState securityState) {
    final seconds = securityState.remainingLockDuration.inSeconds.ceil();
    final safeSeconds = seconds <= 0 ? 1 : seconds;
    return AuthErrorState(
      code: AuthErrorCode.lockoutActive,
      lockSeconds: safeSeconds,
    );
  }
}
