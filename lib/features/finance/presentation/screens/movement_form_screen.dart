import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/providers.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/movement.dart';

class MovementFormScreen extends ConsumerStatefulWidget {
  const MovementFormScreen({
    this.initialMovement,
    super.key,
  });

  final Movement? initialMovement;

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
  DateTime _selectedDate = DateTime.now();
  String? _categoryId;
  String? _subcategoryId;
  String? _goalId;

  @override
  void initState() {
    super.initState();
    final movement = widget.initialMovement;
    _type = movement?.type ?? MovementType.expense;
    _selectedDate = movement?.occurredOn ?? DateTime.now();
    _amountController.text = movement != null && movement.amount > 0
        ? movement.amount.toStringAsFixed(2)
        : '';
    _noteController.text = movement?.note ?? '';
    _paymentMethodController.text = movement?.paymentMethod ?? '';
    _categoryId = movement?.categoryId?.isEmpty == true
        ? null
        : movement?.categoryId;
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
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('es'),
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
      amount: double.parse(_amountController.text.replaceAll(',', '.')),
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

    await ref.read(financeRepositoryProvider).upsertMovement(movement);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(movementsProvider);
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
    final categoriesState =
        ref.watch(categoriesProvider(_scopeFromMovementType(_type)));
    final goalsState = ref.watch(savingsGoalsProvider);
    final isEditing =
        widget.initialMovement != null && widget.initialMovement!.id.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar movimiento' : 'Nuevo movimiento'),
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
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<MovementType>(
                  value: _type,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: const [
                    DropdownMenuItem(
                      value: MovementType.income,
                      child: Text('Ingreso'),
                    ),
                    DropdownMenuItem(
                      value: MovementType.expense,
                      child: Text('Gasto'),
                    ),
                    DropdownMenuItem(
                      value: MovementType.saving,
                      child: Text('Ahorro'),
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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Monto'),
                  validator: (value) {
                    final parsed =
                        double.tryParse((value ?? '').replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      return 'Ingresá un monto válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _categoryId,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: topLevel
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
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
                    value: _subcategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Subcategoría',
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Sin subcategoría'),
                      ),
                      ...subcategories.map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
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
                      value: _goalId,
                      decoration: const InputDecoration(
                        labelText: 'Meta de ahorro',
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Sin meta'),
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
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    suffixIcon: const Icon(Icons.calendar_month),
                    hintText:
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _paymentMethodController,
                  decoration: const InputDecoration(
                    labelText: 'Medio de pago',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Nota'),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _save,
                  child: Text(isEditing ? 'Guardar cambios' : 'Crear movimiento'),
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
