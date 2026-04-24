import '../domain/entities/pin_security_state.dart';

enum AuthStatus { checking, setupRequired, locked, unlocked }

enum AuthErrorCode {
  pinLengthInvalid,
  recoveryDataInvalid,
  incorrectPin,
  biometricUnavailable,
  biometricAuthUnavailable,
  biometricAuthFailed,
  recoveryVerificationFailed,
  startupSafetyMode,
  lockoutActive,
}

class AuthErrorState {
  const AuthErrorState({
    required this.code,
    this.lockSeconds,
  });

  final AuthErrorCode code;
  final int? lockSeconds;
}

class AuthState {
  const AuthState({
    required this.status,
    required this.biometricAvailable,
    required this.biometricEnabled,
    required this.recoveryConfigured,
    required this.pinSecurityState,
    this.error,
  });

  const AuthState.initial()
      : status = AuthStatus.checking,
        biometricAvailable = false,
        biometricEnabled = false,
        recoveryConfigured = false,
        pinSecurityState = const PinSecurityState.initial(),
        error = null;

  final AuthStatus status;
  final bool biometricAvailable;
  final bool biometricEnabled;
  final bool recoveryConfigured;
  final PinSecurityState pinSecurityState;
  final AuthErrorState? error;

  AuthState copyWith({
    AuthStatus? status,
    bool? biometricAvailable,
    bool? biometricEnabled,
    bool? recoveryConfigured,
    PinSecurityState? pinSecurityState,
    AuthErrorState? error,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      recoveryConfigured: recoveryConfigured ?? this.recoveryConfigured,
      pinSecurityState: pinSecurityState ?? this.pinSecurityState,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
