import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/providers.dart';
import '../widgets/section_card.dart';
import '../../domain/entities/savings_goal.dart';

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
  DateTime? _targetDate;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialGoal?.name ?? '';
    _targetController.text = widget.initialGoal == null
        ? ''
        : widget.initialGoal!.targetAmount.toStringAsFixed(2);
    _targetDate = widget.initialGoal?.targetDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('es'),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _targetDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final goal = SavingsGoal(
      id: widget.initialGoal?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      targetAmount: double.parse(_targetController.text.replaceAll(',', '.')),
      targetDate: _targetDate,
      isArchived: widget.initialGoal?.isArchived ?? false,
      createdAt: widget.initialGoal?.createdAt ?? now,
      updatedAt: now,
    );

    await ref.read(financeRepositoryProvider).upsertSavingsGoal(goal);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(financeOverviewProvider);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialGoal == null ? 'Nueva meta' : 'Editar meta'),
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
                    'Definí una meta simple y visible',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nombre claro, monto objetivo y fecha opcional. Nada más.',
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
              decoration: const InputDecoration(labelText: 'Nombre de la meta'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresá un nombre.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Monto objetivo'),
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
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_month_rounded),
              label: Text(
                _targetDate == null
                    ? 'Agregar fecha objetivo'
                    : DateFormat('d MMMM y', 'es').format(_targetDate!),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: const Text('Guardar meta'),
            ),
          ],
        ),
      ),
    );
  }
}
