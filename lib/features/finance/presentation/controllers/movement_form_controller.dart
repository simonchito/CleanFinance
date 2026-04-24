import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/payment_method_utils.dart';
import '../../../../shared/providers.dart';
import '../../../budgets/presentation/providers/budget_providers.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/movement.dart';
import '../providers/finance_providers.dart';
import '../providers/monthly_reminder_notification_providers.dart';

final movementFormControllerProvider =
    Provider.autoDispose<MovementFormController>(
  MovementFormController.new,
);

class MovementFormController {
  MovementFormController(this._ref);

  final Ref _ref;
  final Uuid _uuid = const Uuid();

  Future<void> saveMovement(MovementFormInput input) async {
    final amount = CurrencyFormatter.tryParseWholeAmount(
      input.amountText,
      localeCode: input.localeCode,
    );
    if (amount == null || amount <= 0) {
      throw const MovementFormValidationException(
        MovementFormValidationError.invalidAmount,
      );
    }

    final categoryId = input.categoryId?.trim();
    if (categoryId == null || categoryId.isEmpty) {
      throw const MovementFormValidationException(
        MovementFormValidationError.missingCategory,
      );
    }

    final now = DateTime.now();
    final trimmedNote = input.note.trim();
    final trimmedPaymentMethod = input.paymentMethod.trim();
    final movement = Movement(
      id: input.initialMovement?.id.isNotEmpty == true
          ? input.initialMovement!.id
          : _uuid.v4(),
      type: input.type,
      amount: amount,
      categoryId: categoryId,
      subcategoryId: _normalizeNullableText(input.subcategoryId),
      goalId: input.type == MovementType.saving
          ? _normalizeNullableText(input.goalId)
          : null,
      occurredOn: input.occurredOn,
      note: trimmedNote.isEmpty ? null : trimmedNote,
      paymentMethod: trimmedPaymentMethod.isEmpty
          ? null
          : PaymentMethodUtils.canonicalizeLabel(trimmedPaymentMethod),
      createdAt: input.initialMovement?.createdAt ?? now,
      updatedAt: now,
    );

    await _ref.read(movementsRepositoryProvider).upsertMovement(movement);
    await _syncMonthlyReminderNotifications();
    _refreshFinanceData();
  }

  Future<void> _syncMonthlyReminderNotifications() async {
    try {
      await _ref
          .read(monthlyReminderNotificationSchedulerProvider)
          .syncScheduledReminders();
    } catch (_) {
      // Saving data must not fail because Android notification scheduling failed.
    }
  }

  void _refreshFinanceData() {
    _ref.invalidate(financeOverviewProvider);
    _ref.invalidate(dashboardSummaryProvider);
    _ref.invalidate(recentMovementsProvider);
    _ref.invalidate(reportsSnapshotProvider);
    _ref.invalidate(savingsGoalsProvider);
    _ref.invalidate(savingMovementsProvider);
    _ref.invalidate(unassignedSavingsProvider);
    _ref.invalidate(savingsSummaryProvider);
    _ref.invalidate(movementsProvider);
    _ref.invalidate(monthlyDueRemindersProvider);
    _ref.invalidate(categoryBudgetStatusProvider);
  }

  String? _normalizeNullableText(String? value) {
    if (value == null) {
      return null;
    }
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}

class MovementFormInput {
  const MovementFormInput({
    required this.initialMovement,
    required this.type,
    required this.amountText,
    required this.localeCode,
    required this.categoryId,
    required this.subcategoryId,
    required this.goalId,
    required this.occurredOn,
    required this.note,
    required this.paymentMethod,
  });

  final Movement? initialMovement;
  final MovementType type;
  final String amountText;
  final String localeCode;
  final String? categoryId;
  final String? subcategoryId;
  final String? goalId;
  final DateTime occurredOn;
  final String note;
  final String paymentMethod;
}

enum MovementFormValidationError {
  invalidAmount,
  missingCategory,
}

class MovementFormValidationException implements Exception {
  const MovementFormValidationException(this.error);

  final MovementFormValidationError error;
}

CategoryScope categoryScopeFromMovementType(MovementType type) {
  switch (type) {
    case MovementType.income:
      return CategoryScope.income;
    case MovementType.expense:
      return CategoryScope.expense;
    case MovementType.saving:
      return CategoryScope.saving;
  }
}
