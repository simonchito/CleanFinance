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
import 'package:clean_finance/features/finance/presentation/widgets/selection_sheet_field.dart';
import 'package:clean_finance/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('es');
  });

  testWidgets(
    'shows expense subcategories when the default category is preselected',
    (tester) async {
      final now = DateTime(2026, 4, 17);
      final categories = [
        Category(
          id: 'food',
          name: 'Alimentos',
          iconKey: 'restaurant',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
        Category(
          id: 'groceries',
          name: 'Supermercado',
          iconKey: 'shopping_cart',
          scope: CategoryScope.expense,
          parentId: 'food',
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            movementsRepositoryProvider.overrideWithValue(
              _FakeMovementsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('es'),
            home: MovementFormScreen(initialType: MovementType.expense),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Alimentos'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SelectionSheetField &&
              widget.label == 'Subcategory (optional)' &&
              widget.placeholder == 'No subcategory',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'updates the selected payment method label immediately',
    (tester) async {
      final now = DateTime(2026, 4, 17);
      final categories = [
        Category(
          id: 'food',
          name: 'Alimentos',
          iconKey: 'restaurant',
          scope: CategoryScope.expense,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesRepositoryProvider.overrideWithValue(
              _FakeCategoriesRepository(categories),
            ),
            movementsRepositoryProvider.overrideWithValue(
              _FakeMovementsRepository(),
            ),
            settingsRepositoryProvider.overrideWithValue(
              _FakeSettingsRepository(
                paymentMethods: const ['Transferencia', 'QR'],
              ),
            ),
            savingsGoalsRepositoryProvider.overrideWithValue(
              _FakeSavingsGoalsRepository(),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('es'),
            home: MovementFormScreen(initialType: MovementType.expense),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final selectionFields = find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString().startsWith('SelectionSheetField'),
      );

      expect(selectionFields, findsAtLeastNWidgets(3));

      await tester.tap(selectionFields.last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('QR').last);
      await tester.pumpAndSettle();

      expect(find.text('QR'), findsWidgets);
    },
  );
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
  Future<void> upsertCategory(Category category) async {}
}

class _FakeMovementsRepository implements MovementsRepository {
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
  Future<void> upsertMovement(Movement movement) async {}
}

class _FakeSavingsGoalsRepository implements SavingsGoalsRepository {
  @override
  Future<void> deleteSavingsGoal(String goalId) async {}

  @override
  Future<List<SavingsGoalProgress>> getSavingsGoals() async {
    return const [];
  }

  @override
  Future<void> upsertSavingsGoal(SavingsGoal goal) async {}
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository({
    this.paymentMethods = const [],
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
      autoLockMinutes: 0,
      localeCode: 'es',
      paymentMethods: paymentMethods,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {}
}
