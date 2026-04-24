import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/whole_amount_input_formatter.dart';
import '../../../../shared/providers.dart';
import '../../../../app/app_strings.dart';
import '../widgets/section_card.dart';
import '../widgets/selection_sheet_field.dart';
import '../../domain/entities/savings_goal.dart';
import '../providers/finance_providers.dart';
import '../providers/monthly_reminder_notification_providers.dart';

class SavingsGoalFormScreen extends ConsumerStatefulWidget {
  const SavingsGoalFormScreen({
    this.initialGoal,
    super.key,
  });

  final SavingsGoal? initialGoal;

  @override
  ConsumerState<SavingsGoalFormScreen> createState() =>
      _SavingsGoalFormScreenState();
}

class _SavingsGoalFormScreenState extends ConsumerState<SavingsGoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  late final String _localeCode;
  DateTime? _targetDate;
  bool _reminderEnabled = false;
  int? _reminderDay;

  @override
  void initState() {
    super.initState();
    _localeCode = ref.read(appLocaleCodeProvider);
    _nameController.text = widget.initialGoal?.name ?? '';
    _targetController.text = widget.initialGoal == null
        ? ''
        : CurrencyFormatter.formatWholeNumber(
            widget.initialGoal!.targetAmount,
            localeCode: _localeCode,
          );
    _targetDate = widget.initialGoal?.targetDate;
    _reminderEnabled = widget.initialGoal?.reminderEnabled ?? false;
    _reminderDay = widget.initialGoal?.reminderDay ?? DateTime.now().day;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final strings = AppStrings.of(context);
    final picked = await showDatePicker(
      context: context,
      locale: Locale(strings.languageCode),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _targetDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  Future<void> _save() async {
    final strings = AppStrings.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_reminderEnabled &&
        (_reminderDay == null || _reminderDay! < 1 || _reminderDay! > 31)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            strings.isEnglish
                ? 'Choose a valid reminder day.'
                : 'Elegí un día de recordatorio válido.',
          ),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final goal = SavingsGoal(
      id: widget.initialGoal?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      targetAmount: CurrencyFormatter.tryParseWholeAmount(
        _targetController.text,
        localeCode: _localeCode,
      )!,
      targetDate: _targetDate,
      isArchived: widget.initialGoal?.isArchived ?? false,
      reminderEnabled: _reminderEnabled,
      reminderDay: _reminderEnabled ? _reminderDay : null,
      createdAt: widget.initialGoal?.createdAt ?? now,
      updatedAt: now,
    );

    await ref.read(savingsGoalsRepositoryProvider).upsertSavingsGoal(goal);
    await _syncNotifications();
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(unassignedSavingsProvider);
    ref.invalidate(savingsSummaryProvider);
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(monthlyDueRemindersProvider);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _syncNotifications() async {
    try {
      await ref
          .read(monthlyReminderNotificationSchedulerProvider)
          .syncScheduledReminders();
    } catch (_) {
      // Goal changes should remain saved even if notification scheduling fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialGoal == null ? strings.newGoal : strings.editGoal),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.isEnglish
                        ? 'Define a simple and visible goal'
                        : 'Definí una meta simple y visible',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    strings.isEnglish
                        ? 'Clear name, target amount and optional date. Nothing else.'
                        : 'Nombre claro, monto objetivo y fecha opcional. Nada más.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText:
                    strings.isEnglish ? 'Goal name' : 'Nombre de la meta',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return strings.isEnglish
                      ? 'Enter a name.'
                      : 'Ingresá un nombre.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WholeAmountInputFormatter(localeCode: _localeCode),
              ],
              decoration: InputDecoration(
                labelText:
                    strings.isEnglish ? 'Target amount' : 'Monto objetivo',
              ),
              validator: (value) {
                final parsed = CurrencyFormatter.tryParseWholeAmount(
                  value ?? '',
                  localeCode: _localeCode,
                );
                if (parsed == null || parsed <= 0) {
                  return strings.isEnglish
                      ? 'Enter a valid amount.'
                      : 'Ingresá un monto válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_month_rounded),
              label: Text(
                _targetDate == null
                    ? (strings.isEnglish
                        ? 'Add target date'
                        : 'Agregar fecha objetivo')
                    : DateFormat('d MMMM y', strings.languageCode)
                        .format(_targetDate!),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(strings.monthlyReminder),
              subtitle: Text(
                strings.isEnglish
                    ? 'Helps you remember monthly contributions for this goal.'
                    : 'Te ayuda a no olvidarte del aporte mensual para esta meta.',
              ),
              value: _reminderEnabled,
              onChanged: (value) {
                setState(() {
                  _reminderEnabled = value;
                  _reminderDay ??= DateTime.now().day;
                });
              },
            ),
            if (_reminderEnabled) ...[
              const SizedBox(height: 8),
              SelectionSheetField<int>(
                label: strings.reminderDay,
                value: _reminderDay,
                sheetTitle: strings.reminderDay,
                sheetDescription: strings.isEnglish
                    ? 'Choose the day of month when you want the reminder.'
                    : 'Elegí el día del mes en el que querés recibir el recordatorio.',
                items: List.generate(
                  31,
                  (index) => SelectionSheetItem(
                    value: index + 1,
                    label: '${strings.reminderDayPrefix} ${index + 1}',
                    iconData: Icons.calendar_month_outlined,
                  ),
                ),
                maxSheetHeight: 360,
                onChanged: (value) => setState(() => _reminderDay = value),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: Text(
                strings.isEnglish ? 'Save goal' : 'Guardar meta',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
