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

final movementFormReminderControllerProvider = StateNotifierProvider
    .autoDispose<MovementFormReminderController, MovementFormReminderState>(
  MovementFormReminderController.new,
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

class MovementFormReminderState {
  const MovementFormReminderState({
    this.selectedSubcategoryId,
    this.reminderEnabled = false,
    this.existingReminder,
    this.reminderDay,
    this.isLoading = false,
    this.activatedFromForm = false,
  });

  final String? selectedSubcategoryId;
  final bool reminderEnabled;
  final Category? existingReminder;
  final int? reminderDay;
  final bool isLoading;
  final bool activatedFromForm;

  MovementFormReminderState copyWith({
    String? selectedSubcategoryId,
    bool? reminderEnabled,
    Category? existingReminder,
    int? reminderDay,
    bool? isLoading,
    bool? activatedFromForm,
    bool clearSubcategory = false,
    bool clearExistingReminder = false,
    bool clearReminderDay = false,
  }) {
    return MovementFormReminderState(
      selectedSubcategoryId: clearSubcategory
          ? null
          : selectedSubcategoryId ?? this.selectedSubcategoryId,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      existingReminder: clearExistingReminder
          ? null
          : existingReminder ?? this.existingReminder,
      reminderDay: clearReminderDay ? null : reminderDay ?? this.reminderDay,
      isLoading: isLoading ?? this.isLoading,
      activatedFromForm: activatedFromForm ?? this.activatedFromForm,
    );
  }
}

class MovementFormReminderController
    extends StateNotifier<MovementFormReminderState> {
  MovementFormReminderController(this._ref)
      : super(const MovementFormReminderState());

  final Ref _ref;
  int _loadGeneration = 0;

  Future<void> loadFor({
    required MovementType type,
    required String? subcategoryId,
    required DateTime occurredOn,
  }) async {
    final generation = ++_loadGeneration;
    final normalizedSubcategoryId = _normalizeNullableText(subcategoryId);
    if (type != MovementType.expense || normalizedSubcategoryId == null) {
      state = MovementFormReminderState(reminderDay: occurredOn.day);
      return;
    }

    state = MovementFormReminderState(
      selectedSubcategoryId: normalizedSubcategoryId,
      reminderDay: occurredOn.day,
      isLoading: true,
    );

    final repository = _ref.read(categoriesRepositoryProvider);
    final activeReminder =
        await repository.getActiveExpenseReminderBySubcategory(
      normalizedSubcategoryId,
    );
    final subcategory = activeReminder ??
        await repository.getCategoryById(normalizedSubcategoryId);
    if (generation != _loadGeneration) {
      return;
    }

    if (subcategory == null ||
        subcategory.scope != CategoryScope.expense ||
        !subcategory.isSubcategory) {
      state = MovementFormReminderState(reminderDay: occurredOn.day);
      return;
    }

    state = MovementFormReminderState(
      selectedSubcategoryId: normalizedSubcategoryId,
      reminderEnabled: activeReminder != null,
      existingReminder: activeReminder,
      reminderDay: activeReminder?.reminderDay ?? occurredOn.day,
    );
  }

  Future<void> setEnabled({
    required bool enabled,
    required MovementType type,
    required String? subcategoryId,
    required DateTime occurredOn,
  }) async {
    final normalizedSubcategoryId = _normalizeNullableText(subcategoryId);
    if (type != MovementType.expense || normalizedSubcategoryId == null) {
      return;
    }

    state = state.copyWith(
      selectedSubcategoryId: normalizedSubcategoryId,
      isLoading: true,
    );

    final updated = await _ref
        .read(categoriesRepositoryProvider)
        .setExpenseSubcategoryMonthlyReminder(
          subcategoryId: normalizedSubcategoryId,
          enabled: enabled,
          reminderDay: enabled ? occurredOn.day : null,
        );

    state = MovementFormReminderState(
      selectedSubcategoryId: normalizedSubcategoryId,
      reminderEnabled: enabled,
      existingReminder: enabled ? updated : null,
      reminderDay: enabled ? updated.reminderDay : occurredOn.day,
      activatedFromForm: enabled,
    );

    await _syncMonthlyReminderNotifications();
    _refreshReminderData();
  }

  Future<void> updateDate(DateTime occurredOn) async {
    if (!state.reminderEnabled) {
      state = state.copyWith(reminderDay: occurredOn.day);
      return;
    }
    if (!state.activatedFromForm || state.selectedSubcategoryId == null) {
      return;
    }

    state = state.copyWith(isLoading: true);
    final updated = await _ref
        .read(categoriesRepositoryProvider)
        .setExpenseSubcategoryMonthlyReminder(
          subcategoryId: state.selectedSubcategoryId!,
          enabled: true,
          reminderDay: occurredOn.day,
        );
    state = state.copyWith(
      existingReminder: updated,
      reminderDay: updated.reminderDay,
      isLoading: false,
    );
    await _syncMonthlyReminderNotifications();
    _refreshReminderData();
  }

  Future<void> _syncMonthlyReminderNotifications() async {
    try {
      await _ref
          .read(monthlyReminderNotificationSchedulerProvider)
          .syncScheduledReminders();
    } catch (_) {
      // Reminder edits should remain saved even if notification scheduling fails.
    }
  }

  void _refreshReminderData() {
    _ref.invalidate(categoriesProvider(CategoryScope.expense));
    _ref.invalidate(expenseReminderSubcategoriesProvider);
    _ref.invalidate(monthlyDueRemindersProvider);
    _ref.invalidate(financeOverviewProvider);
  }

  String? _normalizeNullableText(String? value) {
    if (value == null) {
      return null;
    }
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}
