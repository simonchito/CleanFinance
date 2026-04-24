import 'package:clean_finance/core/database/app_database.dart';
import 'package:clean_finance/features/finance/data/local_finance_repository.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockDatabase database;
  late LocalFinanceRepository repository;
  late Map<String, Object?> storedMovementRow;

  setUpAll(() {
    registerFallbackValue(ConflictAlgorithm.abort);
  });

  setUp(() {
    database = _MockDatabase();
    repository = LocalFinanceRepository(_FakeAppDatabase(database));
    storedMovementRow = <String, Object?>{};

    when(
      () => database.insert(
        'movements',
        any(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).thenAnswer((invocation) async {
      storedMovementRow = Map<String, Object?>.from(
        invocation.positionalArguments[1] as Map,
      );
      return 1;
    });

    when(() => database.rawQuery(any(), any())).thenAnswer((_) async {
      if (storedMovementRow.isEmpty) {
        return const <Map<String, Object?>>[];
      }
      return [
        {
          ...storedMovementRow,
          'category_name': 'Alimentos',
          'subcategory_name': 'Supermercado',
        },
      ];
    });
  });

  test('upsertMovement and getMovements keep a full movement round-trip',
      () async {
    final movement = Movement(
      id: 'movement-1',
      type: MovementType.expense,
      amount: 3250,
      categoryId: 'food',
      subcategoryId: 'groceries',
      occurredOn: DateTime(2026, 4, 17),
      note: 'Compra semanal',
      paymentMethod: 'codigo qr',
      monthlyReminderEnabled: true,
      reminderDay: 17,
      createdAt: DateTime(2026, 4, 17, 10, 30),
      updatedAt: DateTime(2026, 4, 17, 11, 45),
    );

    await repository.upsertMovement(movement);
    final movements = await repository.getMovements();

    expect(storedMovementRow['type'], 'expense');
    expect(storedMovementRow['category_id'], 'food');
    expect(storedMovementRow['subcategory_id'], 'groceries');
    expect(storedMovementRow['note'], 'Compra semanal');
    expect(storedMovementRow['payment_method'], 'qr');
    expect(storedMovementRow['monthly_reminder_enabled'], 1);
    expect(storedMovementRow['reminder_day'], 17);

    expect(movements, hasLength(1));
    final restored = movements.single;
    expect(restored.id, movement.id);
    expect(restored.type, movement.type);
    expect(restored.amount, movement.amount);
    expect(restored.categoryId, movement.categoryId);
    expect(restored.subcategoryId, movement.subcategoryId);
    expect(restored.note, movement.note);
    expect(restored.paymentMethod, 'qr');
    expect(restored.monthlyReminderEnabled, isTrue);
    expect(restored.reminderDay, 17);
    expect(restored.categoryName, 'Alimentos');
    expect(restored.subcategoryName, 'Supermercado');
    expect(restored.createdAt, movement.createdAt);
    expect(restored.updatedAt, movement.updatedAt);
  });
}

class _FakeAppDatabase extends AppDatabase {
  _FakeAppDatabase(this._database);

  final Database _database;

  @override
  Future<Database> get instance async => _database;
}

class _MockDatabase extends Mock implements Database {}
