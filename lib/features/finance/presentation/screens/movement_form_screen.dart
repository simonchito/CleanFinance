import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/payment_method_utils.dart';
import '../../../../core/utils/whole_amount_input_formatter.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/movement.dart';
import '../controllers/movement_form_controller.dart';
import '../mappers/default_category_name_localizer.dart';
import '../providers/finance_providers.dart';
import '../utils/payment_method_icon_resolver.dart';
import '../widgets/section_card.dart';
import '../widgets/selection_sheet_field.dart';

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

  late MovementType _type;
  late final String _localeCode;
  DateTime _selectedDate = DateTime.now();
  String? _categoryId;
  String? _subcategoryId;
  String? _goalId;
  String? _categoryErrorText;

  @override
  void initState() {
    super.initState();
    final movement = widget.initialMovement;
    _type = movement?.type ?? widget.initialType ?? MovementType.expense;
    _localeCode = ref.read(appLocaleCodeProvider);
    _selectedDate = movement?.occurredOn ?? DateTime.now();
    _amountController.text = movement != null && movement.amount > 0
        ? CurrencyFormatter.formatWholeNumber(
            movement.amount,
            localeCode: _localeCode,
          )
        : '';
    _noteController.text = movement?.note ?? '';
    _paymentMethodController.text = movement?.paymentMethod == null
        ? ''
        : PaymentMethodUtils.canonicalizeLabel(movement!.paymentMethod!);
    _categoryId = movement == null || movement.categoryId.isEmpty
        ? null
        : movement.categoryId;
    _subcategoryId = movement?.subcategoryId;
    _goalId = movement?.goalId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _loadReminderForCurrentSelection();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _paymentMethodController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      locale: Localizations.localeOf(context),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: _selectedDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      unawaited(
        ref
            .read(movementFormReminderControllerProvider.notifier)
            .updateDate(_selectedDate),
      );
    }
  }

  void _loadReminderForCurrentSelection() {
    unawaited(
      ref.read(movementFormReminderControllerProvider.notifier).loadFor(
            type: _type,
            subcategoryId: _subcategoryId,
            occurredOn: _selectedDate,
          ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await ref.read(movementFormControllerProvider).saveMovement(
            MovementFormInput(
              initialMovement: widget.initialMovement,
              type: _type,
              amountText: _amountController.text,
              localeCode: _localeCode,
              categoryId: _categoryId,
              subcategoryId: _subcategoryId,
              goalId: _goalId,
              occurredOn: _selectedDate,
              note: _noteController.text,
              paymentMethod: _paymentMethodController.text,
            ),
          );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on MovementFormValidationException catch (error) {
      if (error.error == MovementFormValidationError.missingCategory) {
        setState(() {
          _categoryErrorText =
              AppStrings.of(context).movementFormMissingCategory;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final categoriesState =
        ref.watch(categoriesProvider(categoryScopeFromMovementType(_type)));
    final goalsState = ref.watch(savingsGoalsProvider);
    final isEditing =
        widget.initialMovement != null && widget.initialMovement!.id.isNotEmpty;
    final reminderState = ref.watch(movementFormReminderControllerProvider);
    final configuredPaymentMethods =
        ref.watch(settingsControllerProvider).valueOrNull?.paymentMethods ?? [];
    final paymentMethods = PaymentMethodUtils.normalizeMethods([
      ...configuredPaymentMethods,
      if (_paymentMethodController.text.trim().isNotEmpty)
        _paymentMethodController.text.trim(),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? strings.editMovement : strings.newMovement),
      ),
      body: categoriesState.when(
        data: (categories) {
          final topLevel = categories
              .where((category) => category.parentId == null)
              .toList();

          final subcategories = _categoryId == null
              ? <Category>[]
              : categories
                  .where((category) => category.parentId == _categoryId)
                  .toList();

          if (_subcategoryId != null &&
              subcategories.every((item) => item.id != _subcategoryId)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              setState(() => _subcategoryId = null);
              _loadReminderForCurrentSelection();
            });
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
                            ? strings.t('actualizaTuRegistro')
                            : strings.t('registraUnMovimientoEnSegundos'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.t('usaLenguajeSimpleYDejaSoloLa'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SelectionSheetField<MovementType>(
                  label: strings.type,
                  value: _type,
                  sheetTitle: strings.type,
                  sheetDescription:
                      strings.t('elegiQueTipoDeMovimientoQueresRegistrar'),
                  items: [
                    SelectionSheetItem(
                      value: MovementType.income,
                      label: strings.income,
                      iconData: Icons.arrow_upward_rounded,
                    ),
                    SelectionSheetItem(
                      value: MovementType.expense,
                      label: strings.expense,
                      iconData: Icons.arrow_downward_rounded,
                    ),
                    SelectionSheetItem(
                      value: MovementType.saving,
                      label: strings.saving,
                      iconData: Icons.savings_rounded,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _type = value;
                      _categoryId = null;
                      _subcategoryId = null;
                      _categoryErrorText = null;
                      if (_type != MovementType.saving) {
                        _goalId = null;
                      }
                    });
                    _loadReminderForCurrentSelection();
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
                      return strings.t('ingresaUnMontoValido');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SelectionSheetField<String>(
                  label: strings.category,
                  value: _categoryId,
                  placeholder: strings.t('elegiUnaCategoria'),
                  sheetTitle: strings.category,
                  sheetDescription: strings.t('elegiLaCategoriaPrincipal'),
                  items: topLevel
                      .map(
                        (category) => SelectionSheetItem(
                          value: category.id,
                          label: DefaultCategoryNameLocalizer.localize(
                            category.name,
                            strings,
                          ),
                          iconKey: category.iconKey,
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoryId = value;
                      _subcategoryId = null;
                      _categoryErrorText = null;
                    });
                    _loadReminderForCurrentSelection();
                  },
                ),
                if (_categoryErrorText != null) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      _categoryErrorText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
                ],
                if (subcategories.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SelectionSheetField<String?>(
                    label: strings.t('subcategoriaOpcional'),
                    value: _subcategoryId,
                    placeholder: strings.noSubcategory,
                    sheetTitle: strings.subcategory,
                    sheetDescription:
                        strings.t('siAplicaElegiUnDetalleMasEspecifico'),
                    items: [
                      SelectionSheetItem<String?>(
                        value: null,
                        label: strings.noSubcategory,
                        iconData: Icons.remove_circle_outline_rounded,
                      ),
                      ...subcategories.map(
                        (category) => SelectionSheetItem<String?>(
                          value: category.id,
                          label: DefaultCategoryNameLocalizer.localize(
                            category.name,
                            strings,
                          ),
                          iconKey: category.iconKey,
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _subcategoryId = value);
                      _loadReminderForCurrentSelection();
                    },
                  ),
                ],
                if (_type == MovementType.expense &&
                    _subcategoryId != null) ...[
                  const SizedBox(height: 12),
                  _MonthlyExpenseReminderCard(
                    state: reminderState,
                    onChanged: (value) async {
                      final messenger = ScaffoldMessenger.of(context);
                      final strings = AppStrings.of(context);
                      try {
                        await ref
                            .read(
                              movementFormReminderControllerProvider.notifier,
                            )
                            .setEnabled(
                              enabled: value,
                              type: _type,
                              subcategoryId: _subcategoryId,
                              occurredOn: _selectedDate,
                            );
                        if (!mounted) {
                          return;
                        }
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              value
                                  ? strings.movementReminderActive
                                  : strings.movementReminderDisabled,
                            ),
                          ),
                        );
                      } catch (error) {
                        if (!mounted) {
                          return;
                        }
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(strings.technicalErrorDetails(error)),
                          ),
                        );
                      }
                    },
                  ),
                ],
                if (_type == MovementType.saving) ...[
                  const SizedBox(height: 12),
                  goalsState.when(
                    data: (goals) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectionSheetField<String?>(
                          label: strings.savingGoal,
                          value: _goalId,
                          placeholder: strings.noGoal,
                          sheetTitle: strings.savingGoal,
                          sheetDescription:
                              strings.t('vinculaElMovimientoConUnaDeTus'),
                          items: [
                            SelectionSheetItem<String?>(
                              value: null,
                              label: strings.noGoal,
                              iconData: Icons.remove_circle_outline_rounded,
                            ),
                            ...goals.map(
                              (goal) => SelectionSheetItem<String?>(
                                value: goal.goal.id,
                                label: goal.goal.name,
                                iconData: Icons.savings_outlined,
                              ),
                            ),
                          ],
                          onChanged: (value) => setState(() => _goalId = value),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          goals.isEmpty
                              ? strings
                                  .t('siGuardasAhoraQuedaraEnAhorroGeneral')
                              : strings.t('tipSiElegisUnaMetaVasA'),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
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
                SelectionSheetField<String?>(
                  label: strings.movementPaymentMethod,
                  value: _paymentMethodController.text.isEmpty
                      ? null
                      : _paymentMethodController.text,
                  placeholder: strings.t('elegiUnMedioDePago'),
                  sheetTitle: strings.movementPaymentMethod,
                  items: paymentMethods
                      .map(
                        (method) => SelectionSheetItem<String?>(
                          value: method,
                          label: strings.paymentMethodDisplayName(method),
                          iconData: PaymentMethodIconResolver.resolve(method),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _paymentMethodController.text = value == null
                          ? ''
                          : PaymentMethodUtils.canonicalizeLabel(value);
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: strings.note,
                    hintText: strings.t('ejemploCompraSemanalOPagoDeServicio'),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _save,
                  child: Text(
                      isEditing ? strings.saveChanges : strings.saveMovement),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              strings.movementFormLoadCategoriesError(error),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthlyExpenseReminderCard extends StatelessWidget {
  const _MonthlyExpenseReminderCard({
    required this.state,
    required this.onChanged,
  });

  final MovementFormReminderState state;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final reminderDay = state.reminderDay;

    return SectionCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: state.reminderEnabled ? scheme.primary : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.movementReminderTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  strings.movementReminderSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                if (state.reminderEnabled && reminderDay != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    strings.movementReminderMonthlyDay(reminderDay),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  strings.movementReminderSettingsHint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: state.reminderEnabled,
            onChanged: state.isLoading ? null : onChanged,
          ),
        ],
      ),
    );
  }
}
