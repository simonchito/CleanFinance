import 'backup_repository.dart';
import 'categories_repository.dart';
import 'movements_repository.dart';
import 'savings_goals_repository.dart';
import 'settings_repository.dart';

abstract class FinanceRepository
    implements
        MovementsRepository,
        CategoriesRepository,
        SavingsGoalsRepository,
        SettingsRepository,
        BackupRepository {}
