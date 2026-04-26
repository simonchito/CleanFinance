import 'package:clean_finance/features/finance/domain/entities/app_settings.dart';
import 'package:clean_finance/features/finance/domain/entities/app_theme_preference.dart';
import 'package:clean_finance/features/finance/domain/entities/category.dart';
import 'package:clean_finance/features/finance/domain/entities/dashboard_summary.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:clean_finance/features/finance/domain/entities/movement_filter.dart';
import 'package:clean_finance/features/finance/domain/entities/reports_snapshot.dart';
import 'package:clean_finance/features/finance/domain/entities/savings_goal.dart';
import 'package:clean_finance/features/finance/domain/repositories/categories_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/movements_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/savings_goals_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/settings_repository.dart';
import 'package:clean_finance/features/finance/presentation/screens/movement_form_screen.dart';
import 'package:clean_finance/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('es');
  });

  testWidgets(
    'saves the explicitly selected category and payment method',
    (tester) async {
      final movementsRepository = _CapturingMovementsRepository();
      final categories = [
        Category(
          id: 'food',
          name: 'Alimentos',
          iconKey: 'restaurant',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: DateTime(2026, 4, 17),
          updatedAt: DateTime(2026, 4, 17),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            movementsRepositoryProvider.overrideWithValue(
              movementsRepository,
            ),
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(
                paymentMethods: const ['Transferencia', 'QR'],
              ),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('es'),
            supportedLocales: [Locale('es'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: MovementFormScreen(initialType: MovementType.expense),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(TextFormField).first, '2500');

      final selectionFields = find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString().startsWith('SelectionSheetField'),
      );
      await tester.tap(selectionFields.at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alimentos').last);
      await tester.pumpAndSettle();

      await tester.tap(selectionFields.last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('QR').last);
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pumpAndSettle();
      final saveButtons =
          find.byWidgetPredicate((widget) => widget is ButtonStyleButton);
      await tester.tap(
        saveButtons.last,
      );
      await tester.pumpAndSettle();

      expect(movementsRepository.savedMovement, isNotNull);
      expect(movementsRepository.savedMovement!.categoryId, 'food');
      expect(movementsRepository.savedMovement!.paymentMethod, 'qr');
    },
  );
}

class _CapturingMovementsRepository implements MovementsRepository {
  Movement? savedMovement;

  @override
  Future<void> deleteMovement(String movementId) async {}

  @override
  Future<DashboardSummary> getDashboardSummary(DateTime month) async {
    return const DashboardSummary(
      availableBalance: 0,
      incomeMonth: 0,
      expenseMonth: 0,
      savingsAccumulated: 0,
      savingsMonth: 0,
      currentMonthMovementCount: 0,
    );
  }

  @override
  Future<List<Movement>> getMovements({
    MovementFilter filter = const MovementFilter(),
  }) async {
    return const [];
  }

  @override
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month) async {
    return const ReportsSnapshot(
      incomeMonth: 0,
      expenseMonth: 0,
      savingsMonth: 0,
      netMonth: 0,
      previousNetMonth: 0,
      topExpenseCategories: [],
    );
  }

  @override
  Future<void> upsertMovement(Movement movement) async {
    savedMovement = movement;
  }
}

class _FakeCategoriesRepository implements CategoriesRepository {
  _FakeCategoriesRepository(this.categories);

  final List<Category> categories;

  @override
  Future<void> deleteCategory(String categoryId) async {}

  @override
  Future<void> ensureSeedData() async {}

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) async {
    if (scope == null || scope == CategoryScope.all) {
      return categories;
    }
    return categories.where((category) => category.scope == scope).toList();
  }

  @override
  Future<Category?> getCategoryById(String categoryId) async {
    return categories.cast<Category?>().firstWhere(
          (category) => category?.id == categoryId,
          orElse: () => null,
        );
  }

  @override
  Future<Category?> getActiveExpenseReminderBySubcategory(
    String subcategoryId,
  ) async {
    final category = await getCategoryById(subcategoryId);
    if (category == null ||
        category.scope != CategoryScope.expense ||
        !category.isSubcategory ||
        !category.reminderEnabled) {
      return null;
    }
    return category;
  }

  @override
  Future<Category> setExpenseSubcategoryMonthlyReminder({
    required String subcategoryId,
    required bool enabled,
    int? reminderDay,
  }) async {
    final index =
        categories.indexWhere((category) => category.id == subcategoryId);
    if (index == -1) {
      throw StateError('missing category');
    }
    final updated = categories[index].copyWith(
      reminderEnabled: enabled,
      reminderDay: enabled ? reminderDay : null,
      clearReminderDay: !enabled,
      updatedAt: DateTime.now(),
    );
    categories[index] = updated;
    return updated;
  }

  @override
  Future<void> upsertCategory(Category category) async {}
}

class _FakeSavingsGoalsRepository implements SavingsGoalsRepository {
  @override
  Future<void> deleteSavingsGoal(String goalId) async {}

  @override
  Future<List<SavingsGoalProgress>> getSavingsGoals() async => const [];

  @override
  Future<void> upsertSavingsGoal(SavingsGoal goal) async {}
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository({
    required this.paymentMethods,
  });

  final List<String> paymentMethods;

  @override
  Future<AppSettings> getSettings() async {
    return AppSettings(
      currencyCode: 'ARS',
      currencySymbol: r'$',
      showSensitiveAmounts: true,
      themePreference: AppThemePreference.system,
      biometricEnabled: false,
      autoLockMinutes: 5,
      localeCode: 'es',
      paymentMethods: paymentMethods,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {}
}
