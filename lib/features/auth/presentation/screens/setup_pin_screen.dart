import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/providers.dart';

class SetupPinScreen extends ConsumerStatefulWidget {
  const SetupPinScreen({super.key});

  @override
  ConsumerState<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends ConsumerState<SetupPinScreen> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _pinController.text.trim();
    final confirm = _confirmController.text.trim();
    if (pin != confirm) {
      _showMessage('Los PIN no coinciden.');
      return;
    }

    setState(() => _isSubmitting = true);
    final success =
        await ref.read(authControllerProvider.notifier).createPin(pin);
    setState(() => _isSubmitting = false);

    if (!success && mounted) {
      _showMessage(ref.read(authControllerProvider).errorMessage ?? 'Error.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                'Protegé tu app',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Creá un PIN local de ${AppConstants.defaultPinLength} dígitos para desbloquear la app.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: AppConstants.defaultPinLength,
                decoration: const InputDecoration(
                  labelText: 'PIN',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: AppConstants.defaultPinLength,
                decoration: const InputDecoration(
                  labelText: 'Confirmar PIN',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: Text(
                  _isSubmitting ? 'Guardando...' : 'Crear acceso',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tu PIN se guarda de forma local y segura. No se envía a ningún servidor.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
