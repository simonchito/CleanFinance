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

  setUp(() {
    database = _MockDatabase();
    repository = LocalFinanceRepository(_FakeAppDatabase(database));
  });

  test('maps DB movement rows into entities without losing paymentMethod',
      () async {
    when(() => database.rawQuery(any(), any())).thenAnswer(
      (_) async => [
        {
          'id': 'movement-1',
          'type': 'expense',
          'amount': 3200.0,
          'category_id': 'food',
          'subcategory_id': 'groceries',
          'goal_id': null,
          'occurred_on': DateTime(2026, 4, 17).toIso8601String(),
          'note': 'Compra semanal',
          'payment_method': 'codigo qr',
          'monthly_reminder_enabled': 0,
          'reminder_day': null,
          'created_at': DateTime(2026, 4, 17, 10).toIso8601String(),
          'updated_at': DateTime(2026, 4, 17, 10).toIso8601String(),
          'category_name': 'Alimentos',
          'subcategory_name': 'Supermercado',
        },
      ],
    );

    final movements = await repository.getMovements();

    expect(movements, hasLength(1));
    expect(movements.single.type, MovementType.expense);
    expect(movements.single.categoryName, 'Alimentos');
    expect(movements.single.subcategoryName, 'Supermercado');
    expect(movements.single.paymentMethod, 'QR');
  });

  test('maps canonical card labels when reading from DB', () async {
    when(() => database.rawQuery(any(), any())).thenAnswer(
      (_) async => [
        {
          'id': 'movement-2',
          'type': 'expense',
          'amount': 5000.0,
          'category_id': 'finance',
          'subcategory_id': null,
          'goal_id': null,
          'occurred_on': DateTime(2026, 4, 17).toIso8601String(),
          'note': null,
          'payment_method': 'tarjeta debito',
          'monthly_reminder_enabled': 0,
          'reminder_day': null,
          'created_at': DateTime(2026, 4, 17, 10).toIso8601String(),
          'updated_at': DateTime(2026, 4, 17, 10).toIso8601String(),
          'category_name': 'Finanzas',
          'subcategory_name': null,
        },
      ],
    );

    final movements = await repository.getMovements();

    expect(movements.single.paymentMethod, 'Tarjeta débito');
  });
}

class _FakeAppDatabase extends AppDatabase {
  _FakeAppDatabase(this._database);

  final Database _database;

  @override
  Future<Database> get instance async => _database;
}

class _MockDatabase extends Mock implements Database {}
