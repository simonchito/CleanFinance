enum AuthStatus { checking, setupRequired, locked, unlocked }

class AuthState {
  const AuthState({
    required this.status,
    required this.biometricAvailable,
    required this.biometricEnabled,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.checking,
        biometricAvailable = false,
        biometricEnabled = false,
        errorMessage = null;

  final AuthStatus status;
  final bool biometricAvailable;
  final bool biometricEnabled;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    bool? biometricAvailable,
    bool? biometricEnabled,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
