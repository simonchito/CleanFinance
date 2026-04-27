import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/whole_amount_input_formatter.dart';
import '../../../finance/domain/entities/category.dart';
import '../../../finance/presentation/mappers/default_category_name_localizer.dart';
import '../../../finance/presentation/providers/finance_providers.dart';
import '../../../finance/presentation/widgets/confirm_action_dialog.dart';
import '../../../finance/presentation/widgets/selection_sheet_field.dart';
import '../../../finance/presentation/widgets/empty_state_view.dart';
import '../../../finance/presentation/widgets/section_card.dart';
import '../../domain/models/budget.dart';
import '../providers/budget_providers.dart';

class BudgetFormScreen extends ConsumerStatefulWidget {
  const BudgetFormScreen({
    this.initialBudget,
    super.key,
  });

  final Budget? initialBudget;

  @override
  ConsumerState<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends ConsumerState<BudgetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  final _uuid = const Uuid();
  late final String _localeCode;
  bool _isSaving = false;
  String? _categoryId;

  DateTime get _referenceDate => DateTime.now();
  String get _monthKey => Budget.monthKeyFor(_referenceDate);

  @override
  void initState() {
    super.initState();
    _localeCode = ref.read(appLocaleCodeProvider);
    _limitController.text = widget.initialBudget == null
        ? ''
        : CurrencyFormatter.formatWholeNumber(
            widget.initialBudget!.monthlyLimit,
            localeCode: _localeCode,
          );
    _categoryId = widget.initialBudget?.categoryId;
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _deleteBudget() async {
    final strings = AppStrings.of(context);
    final budget = widget.initialBudget;
    if (budget == null) {
      return;
    }

    final confirmed = await showConfirmActionDialog(
      context: context,
      title: strings.t('eliminarPresupuesto'),
      message: strings.t('estePresupuestoMensualSeEliminaraYEl'),
      confirmLabel: strings.t('eliminar'),
      cancelLabel: strings.cancel,
    );
    if (!confirmed) {
      return;
    }

    await ref.read(budgetRepositoryProvider).deleteBudget(budget.id);
    ref.invalidate(categoryBudgetStatusProvider);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }
    if (_categoryId == null) {
      _showMessage(
        AppStrings.of(context).t('seleccionaUnaCategoria'),
      );
      return;
    }

    final limit = CurrencyFormatter.tryParseWholeAmount(
      _limitController.text,
      localeCode: _localeCode,
    )!;
    final repo = ref.read(budgetRepositoryProvider);

    setState(() => _isSaving = true);
    try {
      final existing = await repo.getBudgetByCategoryAndMonth(
        _categoryId!,
        _monthKey,
      );
      final targetBudget = Budget(
        id: widget.initialBudget?.id ?? existing?.id ?? _uuid.v4(),
        categoryId: _categoryId!,
        monthlyLimit: limit,
        month: _monthKey,
      );

      if (widget.initialBudget != null || existing != null) {
        await repo.updateBudget(targetBudget);
      } else {
        await repo.createBudget(targetBudget);
      }

      ref.invalidate(categoryBudgetStatusProvider);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
        ref.watch(categoriesProvider(CategoryScope.expense));
    final isEditing = widget.initialBudget != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? strings.editBudget : strings.newBudget),
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _isSaving ? null : _deleteBudget,
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: strings.t('eliminarPresupuesto'),
            ),
        ],
      ),
      body: categoriesState.when(
        data: (categories) {
          final availableCategories = categories
              .where((category) => category.parentId == null)
              .toList();

          if (availableCategories.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                EmptyStateView(
                  icon: Icons.category_outlined,
                  title: strings.t('primeroCreaUnaCategoriaDeGasto'),
                  message: strings.t('losPresupuestosSeCreanAPartirDe'),
                ),
              ],
            );
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
                            ? (strings.t('ajustaEstePresupuestoMensual'))
                            : (strings
                                .t('creaUnPresupuestoMensualPorCategoria')),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.t('losPresupuestosSeGuardanLocalmenteYSe'),
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
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: strings.date,
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                  ),
                  child: Text(
                    DateFormat.yMMMM(strings.languageCode)
                        .format(_referenceDate),
                  ),
                ),
                const SizedBox(height: 12),
                SelectionSheetField<String>(
                  label: strings.category,
                  value: _categoryId,
                  placeholder: strings.t('elegiUnaCategoria'),
                  enabled: !isEditing,
                  sheetTitle: strings.category,
                  sheetDescription:
                      strings.t('elegiLaCategoriaDeGastoParaEste'),
                  items: availableCategories
                      .map(
                        (category) => SelectionSheetItem(
                          value: category.id,
                          label: DefaultCategoryNameLocalizer.localizeCategory(
                            category,
                            strings,
                          ),
                          iconKey: category.iconKey,
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _categoryId = value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _limitController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WholeAmountInputFormatter(localeCode: _localeCode),
                  ],
                  decoration: InputDecoration(
                    labelText: strings.monthlyLimit,
                  ),
                  validator: (value) {
                    final parsed = CurrencyFormatter.tryParseWholeAmount(
                      value ?? '',
                      localeCode: _localeCode,
                    );
                    if (parsed == null || parsed <= 0) {
                      return strings.t('ingresaUnLimiteMensualValido');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: Text(
                    _isSaving
                        ? (strings.t('guardando'))
                        : (isEditing ? strings.saveChanges : strings.save),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(strings.categoriesLoadError(error)),
          ),
        ),
      ),
    );
  }
}
