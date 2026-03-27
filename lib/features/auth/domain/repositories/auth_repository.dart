abstract class AuthRepository {
  Future<bool> hasCredential();
  Future<void> savePin(String pin);
  Future<bool> verifyPin(String pin);
  Future<bool> isBiometricAvailable();
  Future<bool> isBiometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);
  Future<bool> authenticateWithBiometrics();
}
