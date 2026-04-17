import 'package:clean_finance/features/auth/domain/entities/pin_security_state.dart';
import 'package:clean_finance/features/auth/domain/repositories/security_repository.dart';
import 'package:clean_finance/shared/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('authRepositoryProvider reuses securityRepositoryProvider', () {
    final repository = _FakeSecurityRepository();
    final container = ProviderContainer(
      overrides: [
        securityRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(authRepositoryProvider), same(repository));
  });
}

class _FakeSecurityRepository implements SecurityRepository {
  @override
  Future<bool> authenticateWithBiometrics() async => false;

  @override
  Future<PinSecurityState> getPinSecurityState() async =>
      const PinSecurityState.initial();

  @override
  Future<bool> hasCredential() async => false;

  @override
  Future<bool> hasRecoveryData() async => false;

  @override
  Future<bool> isBiometricAvailable() async => false;

  @override
  Future<bool> isBiometricEnabled() async => false;

  @override
  Future<void> savePin(String pin) async {}

  @override
  Future<void> saveRecoveryData({
    required String birthDate,
    required String documentId,
  }) async {}

  @override
  Future<void> setBiometricEnabled(bool enabled) async {}

  @override
  Future<PinVerificationResult> verifyPin(String pin) async =>
      const PinVerificationResult(
        status: PinVerificationStatus.invalidPin,
        securityState: PinSecurityState.initial(),
      );

  @override
  Future<bool> verifyRecoveryData({
    required String birthDate,
    required String documentId,
  }) async {
    return false;
  }
}
