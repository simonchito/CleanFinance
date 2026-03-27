abstract class AuthRepository {
  Future<bool> hasCredential();
  Future<void> savePin(String pin);
  Future<bool> verifyPin(String pin);
  Future<void> saveRecoveryData({
    required String birthDate,
    required String documentId,
  });
  Future<bool> hasRecoveryData();
  Future<bool> verifyRecoveryData({
    required String birthDate,
    required String documentId,
  });
  Future<bool> isBiometricAvailable();
  Future<bool> isBiometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);
  Future<bool> authenticateWithBiometrics();
}
