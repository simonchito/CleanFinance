import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/providers.dart';
import '../../../../brand_logo_asset.dart';

class RecoverAccessScreen extends ConsumerStatefulWidget {
  const RecoverAccessScreen({super.key});

  @override
  ConsumerState<RecoverAccessScreen> createState() => _RecoverAccessScreenState();
}

class _RecoverAccessScreenState extends ConsumerState<RecoverAccessScreen> {
  final _birthDateController = TextEditingController();
  final _documentController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _enableBiometrics = false;
  bool _loading = false;

  @override
  void dispose() {
    _birthDateController.dispose();
    _documentController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _recover() async {
    final birthDate = _birthDateController.text.trim();
    final document = _documentController.text.trim();
    final newPin = _newPinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    if (birthDate.isEmpty || document.isEmpty) {
      _showMessage('Completá ambas respuestas de recuperación.');
      return;
    }
    if (newPin != confirmPin) {
      _showMessage('Los PIN no coinciden.');
      return;
    }

    setState(() => _loading = true);
    final success = await ref.read(authControllerProvider.notifier).recoverAccess(
          birthDate: birthDate,
          documentId: document,
          newPin: newPin,
          enableBiometrics: _enableBiometrics,
        );
    setState(() => _loading = false);

    if (!success && mounted) {
      _showMessage(ref.read(authControllerProvider).errorMessage ?? 'Error.');
      return;
    }

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
    final biometricAvailable =
        ref.watch(authControllerProvider).biometricAvailable;

    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar acceso')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
        children: [
          const Center(child: BrandLogo(size: 64)),
          const SizedBox(height: 20),
          Text(
            'Recuperá tu acceso sin complicarte',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Respondé tus dos preguntas personales y elegí un PIN nuevo.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 12),
          TextField(
            controller: _newPinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: AppConstants.defaultPinLength,
            decoration: const InputDecoration(labelText: 'Nuevo PIN'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmPinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: AppConstants.defaultPinLength,
            decoration: const InputDecoration(labelText: 'Confirmar PIN'),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _enableBiometrics,
            onChanged: biometricAvailable
                ? (value) => setState(() => _enableBiometrics = value)
                : null,
            title: const Text('Activar huella para próximos accesos'),
            subtitle: Text(
              biometricAvailable
                  ? 'Así vas a poder entrar más rápido después de recuperar tu cuenta.'
                  : 'La biometría no está disponible en este dispositivo.',
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _loading ? null : _recover,
            child: Text(_loading ? 'Validando...' : 'Recuperar acceso'),
          ),
        ],
      ),
    );
  }
}
