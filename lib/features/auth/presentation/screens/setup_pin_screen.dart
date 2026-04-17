import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_strings.dart';
import '../../../../brand_logo_asset.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../finance/presentation/providers/finance_providers.dart';
import '../providers/auth_providers.dart';

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
    if (!_isValidBirthDate(birthDate) || !_isValidDocument(document)) {
      _showMessage(
        'Usá una fecha válida y un documento con al menos 6 caracteres.',
      );
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
      return;
    }

    if (success) {
      ref.invalidate(settingsControllerProvider);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _isValidBirthDate(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '').length == 8;
  }

  bool _isValidDocument(String value) {
    final normalized =
        value.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '').toUpperCase();
    return normalized.length >= 6 && normalized.length <= 16;
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
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
                strings.setupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                strings.isEnglish
                    ? 'Create a short PIN to protect your data. Everything stays only on your device.'
                    : 'Creá un PIN corto para proteger tus datos. Todo queda guardado solo en tu dispositivo.',
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
                      decoration: InputDecoration(
                        labelText: strings.isEnglish
                            ? 'Choose your PIN'
                            : 'Elegí tu PIN',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: AppConstants.defaultPinLength,
                      decoration: InputDecoration(
                        labelText: strings.isEnglish
                            ? 'Repeat your PIN'
                            : 'Repetí tu PIN',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _birthDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: strings.birthDate,
                        hintText: 'Ejemplo: 10/02/1996',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _documentController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: strings.documentId,
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
                      title: Text(
                        strings.isEnglish
                            ? 'Enable fingerprint for faster access'
                            : 'Activar huella para entrar más rápido',
                      ),
                      subtitle: Text(
                        biometricAvailable
                            ? (strings.isEnglish
                                ? 'The app will offer it on the next unlock.'
                                : 'La app te la va a ofrecer en el próximo desbloqueo.')
                            : (strings.isEnglish
                                ? 'Biometrics are not available on this device.'
                                : 'La biometría no está disponible en este dispositivo.'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: Text(
                        _isSubmitting
                            ? (strings.isEnglish
                                ? 'Setting up...'
                                : 'Configurando...')
                            : (strings.isEnglish ? 'Start' : 'Empezar'),
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
                  strings.isEnglish
                      ? 'We store these answers only to help you recover access if you forget your PIN.'
                      : 'Guardamos estas respuestas solo para ayudarte a recuperar el acceso si olvidás tu PIN.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: scheme.errorContainer.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  strings.isEnglish
                      ? 'Recovery answers are weaker than your PIN. Use real values, but remember that anyone who knows them could try to reset access on this device.'
                      : 'Las respuestas de recuperación son más débiles que tu PIN. Usá datos reales, pero tené en cuenta que alguien que los conozca podría intentar restablecer el acceso en este dispositivo.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface,
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
