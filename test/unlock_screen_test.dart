import 'package:clean_finance/features/auth/domain/entities/pin_security_state.dart';
import 'package:clean_finance/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_finance/features/auth/presentation/screens/unlock_screen.dart';
import 'package:clean_finance/features/finance/domain/entities/category.dart';
import 'package:clean_finance/features/finance/domain/repositories/categories_repository.dart';
import 'package:clean_finance/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('toggles PIN visibility from the unlock field', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          categoriesRepositoryProvider.overrideWithValue(
            _FakeCategoriesRepository(),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          supportedLocales: [Locale('es'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: UnlockScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    TextField pinField() => tester.widget<TextField>(find.byType(TextField));

    expect(pinField().obscureText, isTrue);
    expect(find.byTooltip('Mostrar PIN'), findsOneWidget);

    await tester.tap(find.byTooltip('Mostrar PIN'));
    await tester.pumpAndSettle();

    expect(pinField().obscureText, isFalse);
    expect(find.byTooltip('Ocultar PIN'), findsOneWidget);

    await tester.tap(find.byTooltip('Ocultar PIN'));
    await tester.pumpAndSettle();

    expect(pinField().obscureText, isTrue);
    expect(find.byTooltip('Mostrar PIN'), findsOneWidget);
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> authenticateWithBiometrics() async => false;

  @override
  Future<PinSecurityState> getPinSecurityState() async =>
      const PinSecurityState.initial();

  @override
  Future<bool> hasCredential() async => true;

  @override
  Future<bool> hasRecoveryData() async => true;

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
        status: PinVerificationStatus.success,
        securityState: PinSecurityState.initial(),
      );

  @override
  Future<bool> verifyRecoveryData({
    required String birthDate,
    required String documentId,
  }) async =>
      true;
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
