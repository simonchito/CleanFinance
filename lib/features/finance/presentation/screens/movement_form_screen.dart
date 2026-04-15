import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/whole_amount_input_formatter.dart';
import '../../../../shared/providers.dart';
import '../../../budgets/presentation/providers/budget_providers.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/movement.dart';
import '../providers/finance_providers.dart';
import '../widgets/category_option_label.dart';
import '../widgets/section_card.dart';

class MovementFormScreen extends ConsumerStatefulWidget {
  const MovementFormScreen({
    this.initialMovement,
    this.initialType,
    super.key,
  });

  final Movement? initialMovement;
  final MovementType? initialType;

  @override
  ConsumerState<MovementFormScreen> createState() => _MovementFormScreenState();
}

class _MovementFormScreenState extends ConsumerState<MovementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _uuid = const Uuid();

  late MovementType _type;
  late final String _localeCode;
  DateTime _selectedDate = DateTime.now();
  String? _categoryId;
  String? _subcategoryId;
  String? _goalId;

  @override
  void initState() {
    super.initState();
    final movement = widget.initialMovement;
    _type = movement?.type ?? widget.initialType ?? MovementType.expense;
    _localeCode =
        ref.read(settingsControllerProvider).valueOrNull?.localeCode ??
            AppConstants.defaultLocaleCode;
    _selectedDate = movement?.occurredOn ?? DateTime.now();
    _amountController.text = movement != null && movement.amount > 0
        ? CurrencyFormatter.formatWholeNumber(
            movement.amount,
            localeCode: _localeCode,
          )
        : '';
    _noteController.text = movement?.note ?? '';
    _paymentMethodController.text = movement?.paymentMethod ?? '';
    _categoryId = movement == null || movement.categoryId.isEmpty
        ? null
        : movement.categoryId;
    _subcategoryId = movement?.subcategoryId;
    _goalId = movement?.goalId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _paymentMethodController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final strings = AppStrings.of(context);
    final picked = await showDatePicker(
      context: context,
      locale: strings.locale,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: _selectedDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_categoryId == null) {
      _showMessage('Seleccioná una categoría.');
      return;
    }
    final now = DateTime.now();
    final movement = Movement(
      id: widget.initialMovement?.id.isNotEmpty == true
          ? widget.initialMovement!.id
          : _uuid.v4(),
      type: _type,
      amount: CurrencyFormatter.tryParseWholeAmount(
        _amountController.text,
        localeCode: _localeCode,
      )!,
      categoryId: _categoryId!,
      subcategoryId: _subcategoryId,
      goalId: _type == MovementType.saving ? _goalId : null,
      occurredOn: _selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      paymentMethod: _paymentMethodController.text.trim().isEmpty
          ? null
          : _paymentMethodController.text.trim(),
      createdAt: widget.initialMovement?.createdAt ?? now,
      updatedAt: now,
    );

    await ref.read(movementsRepositoryProvider).upsertMovement(movement);
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(movementsProvider);
    ref.invalidate(monthlyDueRemindersProvider);
    ref.invalidate(categoryBudgetStatusProvider);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final categoriesState =
        ref.watch(categoriesProvider(_scopeFromMovementType(_type)));
    final goalsState = ref.watch(savingsGoalsProvider);
    final isEditing =
        widget.initialMovement != null && widget.initialMovement!.id.isNotEmpty;
    final paymentMethods =
        ref.watch(settingsControllerProvider).valueOrNull?.paymentMethods ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? strings.editMovement : strings.newMovement),
      ),
      body: categoriesState.when(
        data: (categories) {
          final topLevel =
              categories.where((category) => category.parentId == null).toList();
          final subcategories = categories
              .where((category) => category.parentId == _categoryId)
              .toList();

          if (_categoryId == null && topLevel.isNotEmpty) {
            _categoryId = topLevel.first.id;
          }
          if (_subcategoryId != null &&
              subcategories.every((item) => item.id != _subcategoryId)) {
            _subcategoryId = null;
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing
                            ? (strings.isEnglish
                                ? 'Update your movement'
                                : 'Actualizá tu registro')
                            : (strings.isEnglish
                                ? 'Add a movement in seconds'
                                : 'Registrá un movimiento en segundos'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.isEnglish
                            ? 'Use simple language and keep only what matters.'
                            : 'Usá lenguaje simple y dejá solo la información necesaria.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<MovementType>(
                  initialValue: _type,
                  decoration: InputDecoration(labelText: strings.type),
                  items: [
                    DropdownMenuItem(
                      value: MovementType.income,
                      child: Text(strings.income),
                    ),
                    DropdownMenuItem(
                      value: MovementType.expense,
                      child: Text(strings.expense),
                    ),
                    DropdownMenuItem(
                      value: MovementType.saving,
                      child: Text(strings.saving),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _type = value;
                      _categoryId = null;
                      _subcategoryId = null;
                      if (_type != MovementType.saving) {
                        _goalId = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WholeAmountInputFormatter(localeCode: _localeCode),
                  ],
                  decoration: InputDecoration(labelText: strings.amount),
                  validator: (value) {
                    final parsed = CurrencyFormatter.tryParseWholeAmount(
                      value ?? '',
                      localeCode: _localeCode,
                    );
                    if (parsed == null || parsed <= 0) {
                      return 'Ingresá un monto válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _categoryId,
                  isExpanded: true,
                  menuMaxHeight: 320,
                  borderRadius: BorderRadius.circular(20),
                  decoration: InputDecoration(labelText: strings.category),
                  items: topLevel
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: CategoryOptionLabel(
                            iconKey: category.iconKey,
                            label: category.name,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoryId = value;
                      _subcategoryId = null;
                    });
                  },
                ),
                if (subcategories.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _subcategoryId,
                    isExpanded: true,
                    menuMaxHeight: 320,
                    borderRadius: BorderRadius.circular(20),
                    decoration: InputDecoration(
                      labelText: strings.isEnglish
                          ? 'Subcategory (optional)'
                          : 'Subcategoría (opcional)',
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(strings.noSubcategory),
                      ),
                      ...subcategories.map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: CategoryOptionLabel(
                            iconKey: category.iconKey,
                            label: category.name,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _subcategoryId = value),
                  ),
                ],
                if (_type == MovementType.saving) ...[
                  const SizedBox(height: 12),
                  goalsState.when(
                    data: (goals) => DropdownButtonFormField<String>(
                      initialValue: _goalId,
                      decoration: InputDecoration(
                        labelText: strings.savingGoal,
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(strings.noGoal),
                        ),
                        ...goals.map(
                          (goal) => DropdownMenuItem(
                            value: goal.goal.id,
                            child: Text(goal.goal.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _goalId = value),
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: LinearProgressIndicator(),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: Text(
                    DateFormat('d MMMM y', strings.languageCode)
                        .format(_selectedDate),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _paymentMethodController.text.isEmpty
                      ? null
                      : _paymentMethodController.text,
                  decoration: InputDecoration(
                    labelText: strings.movementPaymentMethod,
                  ),
                  items: paymentMethods
                      .map(
                        (method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    _paymentMethodController.text = value ?? '';
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: strings.note,
                    hintText: strings.isEnglish
                        ? 'Example: weekly groceries or utility bill'
                        : 'Ejemplo: compra semanal o pago de servicio',
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _save,
                  child: Text(isEditing ? strings.saveChanges : strings.saveMovement),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('No se pudieron cargar categorías: $error'),
          ),
        ),
      ),
    );
  }
}

CategoryScope _scopeFromMovementType(MovementType type) {
  switch (type) {
    case MovementType.income:
      return CategoryScope.income;
    case MovementType.expense:
      return CategoryScope.expense;
    case MovementType.saving:
      return CategoryScope.saving;
  }
}
