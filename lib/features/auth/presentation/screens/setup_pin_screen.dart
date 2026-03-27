import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../brand_logo_asset.dart';
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
  final _birthDateController = TextEditingController();
  final _documentController = TextEditingController();
  bool _isSubmitting = false;
  bool _enableBiometrics = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    _birthDateController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _pinController.text.trim();
    final confirm = _confirmController.text.trim();
    final birthDate = _birthDateController.text.trim();
    final document = _documentController.text.trim();
    if (pin != confirm) {
      _showMessage('Los PIN no coinciden.');
      return;
    }
    if (birthDate.isEmpty || document.isEmpty) {
      _showMessage('Completá tus dos preguntas de recuperación.');
      return;
    }

    setState(() => _isSubmitting = true);
    final success = await ref.read(authControllerProvider.notifier).createPin(
          pin,
          birthDate: birthDate,
          documentId: document,
          enableBiometrics: _enableBiometrics,
        );
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
    final scheme = Theme.of(context).colorScheme;
    final biometricAvailable =
        ref.watch(authControllerProvider).biometricAvailable;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              scheme.primaryContainer.withValues(alpha: 0.28),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 26),
              const Center(
                child: BrandLogo(size: 72),
              ),
              const SizedBox(height: 24),
              Text(
                'Tu dinero, claro y bajo control',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Creá un PIN corto para proteger tus datos. Todo queda guardado solo en tu dispositivo.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: AppConstants.defaultPinLength,
                      decoration: const InputDecoration(
                        labelText: 'Elegí tu PIN',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: AppConstants.defaultPinLength,
                      decoration: const InputDecoration(
                        labelText: 'Repetí tu PIN',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _birthDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        hintText: 'Ejemplo: 10/02/1996',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _documentController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Documento personal',
                        hintText: 'Ejemplo: 12345678',
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _enableBiometrics,
                      onChanged: biometricAvailable
                          ? (value) => setState(() => _enableBiometrics = value)
                          : null,
                      title: const Text('Activar huella para entrar más rápido'),
                      subtitle: Text(
                        biometricAvailable
                            ? 'La app te la va a ofrecer en el próximo desbloqueo.'
                            : 'La biometría no está disponible en este dispositivo.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: Text(
                        _isSubmitting ? 'Configurando...' : 'Empezar',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'Guardamos estas respuestas solo para ayudarte a recuperar el acceso si olvidás tu PIN.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
