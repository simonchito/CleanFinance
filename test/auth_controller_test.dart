import 'package:clean_finance/features/auth/domain/entities/pin_security_state.dart';
import 'package:clean_finance/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_finance/features/auth/presentation/auth_controller.dart';
import 'package:clean_finance/features/auth/presentation/auth_state.dart';
import 'package:clean_finance/features/finance/domain/entities/category.dart';
import 'package:clean_finance/features/finance/domain/repositories/categories_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthController biometric preference sync', () {
    test('bootstrap loads persisted biometric state from the repository',
        () async {
      final authRepository = _FakeAuthRepository()
        ..hasCredentialResult = true
        ..hasRecoveryDataResult = true
        ..biometricAvailableResult = true
        ..biometricEnabledResult = true;
      final controller = AuthController(
        authRepository: authRepository,
        categoriesRepository: _FakeCategoriesRepository(),
      );

      await controller.bootstrap();

      expect(controller.state.status, AuthStatus.locked);
      expect(controller.state.biometricAvailable, isTrue);
      expect(controller.state.biometricEnabled, isTrue);
      expect(controller.state.recoveryConfigured, isTrue);
    });

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

    test('applies generic recovery failure messaging', () async {
      final authRepository = _FakeAuthRepository()
        ..recoveryVerificationResult = false;
      final controller = AuthController(
        authRepository: authRepository,
        categoriesRepository: _FakeCategoriesRepository(),
      );

      final success = await controller.recoverAccess(
        birthDate: '10/02/1996',
        documentId: '12345678',
        newPin: '123456',
      );

      expect(success, isFalse);
      expect(
        controller.state.error?.code,
        AuthErrorCode.recoveryVerificationFailed,
      );
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  bool recoveryVerificationResult = false;
  bool? lastBiometricEnabledValue;
  bool hasCredentialResult = false;
  bool hasRecoveryDataResult = false;
  bool biometricAvailableResult = true;
  bool biometricEnabledResult = false;

  @override
  Future<bool> authenticateWithBiometrics() async => false;

  @override
  Future<PinSecurityState> getPinSecurityState() async =>
      const PinSecurityState.initial();

  @override
  Future<bool> hasCredential() async => hasCredentialResult;

  @override
  Future<bool> hasRecoveryData() async => hasRecoveryDataResult;

  @override
  Future<bool> isBiometricAvailable() async => biometricAvailableResult;

  @override
  Future<bool> isBiometricEnabled() async =>
      lastBiometricEnabledValue ?? biometricEnabledResult;

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
  Future<PinVerificationResult> verifyPin(String pin) async =>
      const PinVerificationResult(
        status: PinVerificationStatus.success,
        securityState: PinSecurityState.initial(),
      );

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
  Future<Category?> getCategoryById(String categoryId) async => null;

  @override
  Future<Category?> getActiveExpenseReminderBySubcategory(
    String subcategoryId,
  ) async =>
      null;

  @override
  Future<Category> setExpenseSubcategoryMonthlyReminder({
    required String subcategoryId,
    required bool enabled,
    int? reminderDay,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> upsertCategory(Category category) async {}
}
