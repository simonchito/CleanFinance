import 'package:clean_finance/features/finance/domain/entities/category.dart';
import 'package:clean_finance/features/finance/domain/entities/dashboard_summary.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:clean_finance/features/finance/domain/entities/movement_filter.dart';
import 'package:clean_finance/features/finance/domain/entities/reports_snapshot.dart';
import 'package:clean_finance/features/finance/domain/repositories/categories_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/movements_repository.dart';
import 'package:clean_finance/features/finance/presentation/controllers/movement_form_controller.dart';
import 'package:clean_finance/shared/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('MovementFormController builds and saves a normalized movement',
      () async {
    final movementsRepository = _CapturingMovementsRepository();
    final container = ProviderContainer(
      overrides: [
        movementRepositoryProvider.overrideWithValue(movementsRepository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(movementFormControllerProvider).saveMovement(
          MovementFormInput(
            initialMovement: null,
            type: MovementType.expense,
            amountText: '2500',
            localeCode: 'es',
            categoryId: 'food',
            subcategoryId: 'weekly',
            goalId: null,
            occurredOn: DateTime(2026, 4, 17),
            note: ' Compra grande ',
            paymentMethod: ' qr ',
          ),
        );

    final saved = movementsRepository.savedMovement;
    expect(saved, isNotNull);
    expect(saved!.type, MovementType.expense);
    expect(saved.amount, 2500);
    expect(saved.categoryId, 'food');
    expect(saved.subcategoryId, 'weekly');
    expect(saved.note, 'Compra grande');
    expect(saved.paymentMethod, 'qr');
  });

  test('MovementFormController keeps id and createdAt when editing', () async {
    final movementsRepository = _CapturingMovementsRepository();
    final container = ProviderContainer(
      overrides: [
        movementRepositoryProvider.overrideWithValue(movementsRepository),
      ],
    );
    addTearDown(container.dispose);

    final original = Movement(
      id: 'movement-existing',
      type: MovementType.saving,
      amount: 1000,
      categoryId: 'savings',
      goalId: 'goal-1',
      occurredOn: DateTime(2026, 4, 1),
      createdAt: DateTime(2026, 4, 1, 9),
      updatedAt: DateTime(2026, 4, 1, 9),
    );

    await container.read(movementFormControllerProvider).saveMovement(
          MovementFormInput(
            initialMovement: original,
            type: MovementType.expense,
            amountText: '4500',
            localeCode: 'es',
            categoryId: 'food',
            subcategoryId: 'weekly',
            goalId: 'goal-1',
            occurredOn: DateTime(2026, 4, 17),
            note: ' Actualizado ',
            paymentMethod: 'efectivo',
          ),
        );

    final saved = movementsRepository.savedMovement;
    expect(saved, isNotNull);
    expect(saved!.id, 'movement-existing');
    expect(saved.createdAt, original.createdAt);
    expect(saved.goalId, isNull);
    expect(saved.note, 'Actualizado');
    expect(saved.paymentMethod, 'cash');
  });

  test('MovementFormController rejects missing category without saving',
      () async {
    final movementsRepository = _CapturingMovementsRepository();
    final container = ProviderContainer(
      overrides: [
        movementRepositoryProvider.overrideWithValue(movementsRepository),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(
      () => container.read(movementFormControllerProvider).saveMovement(
            MovementFormInput(
              initialMovement: null,
              type: MovementType.expense,
              amountText: '2500',
              localeCode: 'es',
              categoryId: null,
              subcategoryId: null,
              goalId: null,
              occurredOn: DateTime(2026, 4, 17),
              note: '',
              paymentMethod: '',
            ),
          ),
      throwsA(
        isA<MovementFormValidationException>().having(
          (error) => error.error,
          'error',
          MovementFormValidationError.missingCategory,
        ),
      ),
    );

    expect(movementsRepository.savedMovement, isNull);
  });

  test('MovementFormReminderController loads an inactive subcategory reminder',
      () async {
    final now = DateTime(2026, 4, 17);
    final categoriesRepository = _FakeCategoriesRepository([
      _category(id: 'services', name: 'Servicios', now: now),
      _category(
        id: 'internet',
        name: 'Internet',
        parentId: 'services',
        now: now,
      ),
    ]);
    final container = ProviderContainer(
      overrides: [
        categoriesRepositoryProvider.overrideWithValue(categoriesRepository),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(movementFormReminderControllerProvider.notifier)
        .loadFor(
          type: MovementType.expense,
          subcategoryId: 'internet',
          occurredOn: DateTime(2026, 4, 26),
        );

    final state = container.read(movementFormReminderControllerProvider);
    expect(state.selectedSubcategoryId, 'internet');
    expect(state.reminderEnabled, isFalse);
    expect(state.reminderDay, 26);
  });

  test('MovementFormReminderController loads an active subcategory reminder',
      () async {
    final now = DateTime(2026, 4, 17);
    final categoriesRepository = _FakeCategoriesRepository([
      _category(id: 'services', name: 'Servicios', now: now),
      _category(
        id: 'internet',
        name: 'Internet',
        parentId: 'services',
        reminderEnabled: true,
        reminderDay: 12,
        now: now,
      ),
    ]);
    final container = ProviderContainer(
      overrides: [
        categoriesRepositoryProvider.overrideWithValue(categoriesRepository),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(movementFormReminderControllerProvider.notifier)
        .loadFor(
          type: MovementType.expense,
          subcategoryId: 'internet',
          occurredOn: DateTime(2026, 4, 26),
        );

    final state = container.read(movementFormReminderControllerProvider);
    expect(state.reminderEnabled, isTrue);
    expect(state.existingReminder?.id, 'internet');
    expect(state.reminderDay, 12);
  });

  test('MovementFormReminderController enables and disables reminders',
      () async {
    final now = DateTime(2026, 4, 17);
    final categoriesRepository = _FakeCategoriesRepository([
      _category(id: 'services', name: 'Servicios', now: now),
      _category(
        id: 'internet',
        name: 'Internet',
        parentId: 'services',
        now: now,
      ),
    ]);
    final container = ProviderContainer(
      overrides: [
        categoriesRepositoryProvider.overrideWithValue(categoriesRepository),
      ],
    );
    addTearDown(container.dispose);

    final controller =
        container.read(movementFormReminderControllerProvider.notifier);
    await controller.setEnabled(
      enabled: true,
      type: MovementType.expense,
      subcategoryId: 'internet',
      occurredOn: DateTime(2026, 4, 26),
    );

    expect(categoriesRepository.categories.last.reminderEnabled, isTrue);
    expect(categoriesRepository.categories.last.reminderDay, 26);

    await controller.setEnabled(
      enabled: false,
      type: MovementType.expense,
      subcategoryId: 'internet',
      occurredOn: DateTime(2026, 4, 26),
    );

    expect(categoriesRepository.categories.last.reminderEnabled, isFalse);
    expect(categoriesRepository.categories.last.reminderDay, isNull);
  });

  test('MovementFormReminderController reloads when subcategory changes',
      () async {
    final now = DateTime(2026, 4, 17);
    final categoriesRepository = _FakeCategoriesRepository([
      _category(id: 'services', name: 'Servicios', now: now),
      _category(
        id: 'internet',
        name: 'Internet',
        parentId: 'services',
        reminderEnabled: true,
        reminderDay: 12,
        now: now,
      ),
      _category(
        id: 'phone',
        name: 'Telefono',
        parentId: 'services',
        now: now,
      ),
    ]);
    final container = ProviderContainer(
      overrides: [
        categoriesRepositoryProvider.overrideWithValue(categoriesRepository),
      ],
    );
    addTearDown(container.dispose);

    final controller =
        container.read(movementFormReminderControllerProvider.notifier);
    await controller.loadFor(
      type: MovementType.expense,
      subcategoryId: 'internet',
      occurredOn: DateTime(2026, 4, 26),
    );
    expect(
      container.read(movementFormReminderControllerProvider).reminderEnabled,
      isTrue,
    );

    await controller.loadFor(
      type: MovementType.expense,
      subcategoryId: 'phone',
      occurredOn: DateTime(2026, 4, 26),
    );

    final state = container.read(movementFormReminderControllerProvider);
    expect(state.selectedSubcategoryId, 'phone');
    expect(state.reminderEnabled, isFalse);
    expect(state.reminderDay, 26);
  });
}

Category _category({
  required String id,
  required String name,
  required DateTime now,
  String? parentId,
  bool reminderEnabled = false,
  int? reminderDay,
}) {
  return Category(
    id: id,
    name: name,
    iconKey: 'category',
    scope: CategoryScope.expense,
    parentId: parentId,
    isDefault: false,
    reminderEnabled: reminderEnabled,
    reminderDay: reminderDay,
    createdAt: now,
    updatedAt: now,
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
