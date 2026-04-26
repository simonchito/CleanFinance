import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_strings.dart';
import '../../../../brand_logo_asset.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../finance/presentation/providers/finance_providers.dart';
import '../auth_error_localizer.dart';
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
      _showMessage(
        AppStrings.of(context).t('losPinNoCoinciden'),
      );
      return;
    }
    if (birthDate.isEmpty || document.isEmpty) {
      _showMessage(
        AppStrings.of(context).t('completaTusDosPreguntasDeRecuperacion'),
      );
      return;
    }
    if (!_isValidBirthDate(birthDate) || !_isValidDocument(document)) {
      _showMessage(
        AppStrings.of(context).t('usaUnaFechaValidaYUnDocumento'),
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
      _showMessage(
        localizeAuthError(context, ref.read(authControllerProvider).error),
      );
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
    final authState = ref.watch(authControllerProvider);
    final biometricAvailable = authState.biometricAvailable;

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
                strings.t('creaUnPinCortoParaProtegerTus'),
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
                        labelText: strings.t('elegiTuPin'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: AppConstants.defaultPinLength,
                      decoration: InputDecoration(
                        labelText: strings.t('repetiTuPin'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _birthDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: strings.birthDate,
                        hintText: strings.t('ejemplo10021996'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _documentController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: strings.documentId,
                        hintText: strings.t('authRecoveryDocumentExample'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (authState.error != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.errorContainer.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          localizeAuthError(context, authState.error),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _enableBiometrics,
                      onChanged: biometricAvailable
                          ? (value) => setState(() => _enableBiometrics = value)
                          : null,
                      title: Text(
                        strings.t('activarHuellaParaEntrarMasRapido'),
                      ),
                      subtitle: Text(
                        biometricAvailable
                            ? (strings.t('laAppTeLaVaAOfrecer'))
                            : (strings.t('laBiometriaNoEstaDisponibleEnEste')),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: Text(
                        _isSubmitting
                            ? (strings.t('configurando'))
                            : (strings.t('empezar')),
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
                  strings.t('guardamosEstasRespuestasSoloParaAyudarteA'),
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
                  strings.t('lasRespuestasDeRecuperacionSonMasDebiles'),
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
