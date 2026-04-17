import 'package:clean_finance/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_finance/features/auth/presentation/auth_controller.dart';
import 'package:clean_finance/features/auth/presentation/auth_state.dart';
import 'package:clean_finance/features/finance/domain/entities/category.dart';
import 'package:clean_finance/features/finance/domain/repositories/categories_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthController biometric preference sync', () {
    test('createPin persists biometric preference even when disabled',
        () async {
      final authRepository = _FakeAuthRepository();
      final controller = AuthController(
        authRepository: authRepository,
        categoriesRepository: _FakeCategoriesRepository(),
      );

      final success = await controller.createPin(
        '123456',
        birthDate: '10/02/1996',
        documentId: '12345678',
        enableBiometrics: false,
      );

      expect(success, isTrue);
      expect(authRepository.lastBiometricEnabledValue, isFalse);
      expect(controller.state.status, AuthStatus.unlocked);
      expect(controller.state.biometricEnabled, isFalse);
    });

    test('recoverAccess persists biometric preference even when disabled',
        () async {
      final authRepository = _FakeAuthRepository()
        ..recoveryVerificationResult = true;
      final controller = AuthController(
        authRepository: authRepository,
        categoriesRepository: _FakeCategoriesRepository(),
      );

      final success = await controller.recoverAccess(
        birthDate: '10/02/1996',
        documentId: '12345678',
        newPin: '123456',
        enableBiometrics: false,
      );

      expect(success, isTrue);
      expect(authRepository.lastBiometricEnabledValue, isFalse);
      expect(controller.state.status, AuthStatus.unlocked);
      expect(controller.state.biometricEnabled, isFalse);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  bool recoveryVerificationResult = false;
  bool? lastBiometricEnabledValue;

  @override
  Future<bool> authenticateWithBiometrics() async => false;

  @override
  Future<bool> hasCredential() async => false;

  @override
  Future<bool> hasRecoveryData() async => false;

  @override
  Future<bool> isBiometricAvailable() async => true;

  @override
  Future<bool> isBiometricEnabled() async => lastBiometricEnabledValue ?? false;

  @override
  Future<void> savePin(String pin) async {}

  @override
  Future<void> saveRecoveryData({
    required String birthDate,
    required String documentId,
  }) async {}

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    lastBiometricEnabledValue = enabled;
  }

  @override
  Future<bool> verifyPin(String pin) async => true;

  @override
  Future<bool> verifyRecoveryData({
    required String birthDate,
    required String documentId,
  }) async {
    return recoveryVerificationResult;
  }
}

class _FakeCategoriesRepository implements CategoriesRepository {
  @override
  Future<void> deleteCategory(String categoryId) async {}

  @override
  Future<void> ensureSeedData() async {}

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) async =>
      const [];

  @override
  Future<void> upsertCategory(Category category) async {}
}
