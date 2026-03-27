enum AuthStatus { checking, setupRequired, locked, unlocked }

class AuthState {
  const AuthState({
    required this.status,
    required this.biometricAvailable,
    required this.biometricEnabled,
    required this.recoveryConfigured,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.checking,
        biometricAvailable = false,
        biometricEnabled = false,
        recoveryConfigured = false,
        errorMessage = null;

  final AuthStatus status;
  final bool biometricAvailable;
  final bool biometricEnabled;
  final bool recoveryConfigured;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    bool? biometricAvailable,
    bool? biometricEnabled,
    bool? recoveryConfigured,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      recoveryConfigured: recoveryConfigured ?? this.recoveryConfigured,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
