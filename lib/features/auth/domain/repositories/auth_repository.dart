import '../entities/pin_security_state.dart';

abstract class AuthRepository {
  Future<bool> hasCredential();
  Future<void> savePin(String pin);
  Future<PinVerificationResult> verifyPin(String pin);
  Future<PinSecurityState> getPinSecurityState();
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
