import 'package:clean_finance/features/finance/domain/entities/dashboard_summary.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:clean_finance/features/finance/domain/entities/movement_filter.dart';
import 'package:clean_finance/features/finance/domain/entities/reports_snapshot.dart';
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
