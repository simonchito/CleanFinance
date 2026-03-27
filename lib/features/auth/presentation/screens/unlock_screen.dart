import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers.dart';

class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  final _pinController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _unlockWithPin() async {
    setState(() => _loading = true);
    final success = await ref
        .read(authControllerProvider.notifier)
        .unlockWithPin(_pinController.text.trim());
    setState(() => _loading = false);
    if (!success && mounted) {
      _showMessage(ref.read(authControllerProvider).errorMessage ?? 'Error.');
    }
  }

  Future<void> _unlockWithBiometrics() async {
    setState(() => _loading = true);
    final success = await ref
        .read(authControllerProvider.notifier)
        .unlockWithBiometrics();
    setState(() => _loading = false);
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
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                'Volvé a entrar',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Desbloqueá tu información con tu PIN local o biometría.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PIN',
                ),
                onSubmitted: (_) => _unlockWithPin(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loading ? null : _unlockWithPin,
                child: Text(_loading ? 'Validando...' : 'Desbloquear'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _loading ||
                        !authState.biometricEnabled ||
                        !authState.biometricAvailable
                    ? null
                    : _unlockWithBiometrics,
                child: const Text('Usar biometría'),
              ),
              if (!authState.biometricAvailable)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'La biometría no está disponible en este dispositivo.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
