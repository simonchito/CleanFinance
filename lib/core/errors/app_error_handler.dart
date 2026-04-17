import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppErrorHandler {
  const AppErrorHandler._();

  static void configure() {
    FlutterError.onError = (details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
      report(
        details.exception,
        details.stack ?? StackTrace.current,
        source: 'FlutterError',
        context: details.context?.toDescription(),
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      report(error, stack, source: 'PlatformDispatcher');
      return true;
    };

    ErrorWidget.builder = (details) {
      report(
        details.exception,
        details.stack ?? StackTrace.current,
        source: 'ErrorWidget',
        context: details.context?.toDescription(),
      );

      return Material(
        color: const Color(0xFFFFF3F2),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CleanFinance detectó un error',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8A1C12),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                readableMessage(details.exception),
                style: const TextStyle(color: Color(0xFF8A1C12)),
              ),
              if (kDebugMode && details.context != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Contexto: ${details.context!.toDescription()}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A1C12),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    };
  }

  static Future<void> run(FutureOr<void> Function() body) async {
    await runZonedGuarded(() async {
      await body();
    }, (error, stack) {
      report(error, stack, source: 'runZonedGuarded');
    });
  }

  static void report(
    Object error,
    StackTrace stackTrace, {
    required String source,
    String? context,
  }) {
    if (!kDebugMode) {
      return;
    }

    final hint = diagnosticHint(error);
    final buffer = StringBuffer()
      ..writeln('========== CleanFinance Error ==========')
      ..writeln('Timestamp: ${DateTime.now().toIso8601String()}')
      ..writeln('Source: $source')
      ..writeln('Type: ${error.runtimeType}')
      ..writeln('Message: ${readableMessage(error)}');

    if (context != null && context.isNotEmpty) {
      buffer.writeln('Context: $context');
    }
    if (hint != null) {
      buffer.writeln('Hint: $hint');
    }

    debugPrint(buffer.toString());
    debugPrintStack(stackTrace: stackTrace, label: 'Stack trace');
  }

  static String readableMessage(Object error) {
    final raw = error.toString();
    if (raw.contains('There are multiple heroes that share the same tag')) {
      return 'Hay varios Hero/FloatingActionButton con el mismo heroTag dentro de la misma pantalla.';
    }
    if (raw.contains('A RenderFlex overflowed')) {
      return 'Un layout desbordó el espacio disponible. Revisá Row/Column, textos largos y restricciones de ancho.';
    }
    if (error is FlutterError) {
      return error.message;
    }
    if (error is AssertionError) {
      return error.message?.toString() ?? error.toString();
    }
    if (error is StateError || error is FormatException) {
      return error.toString();
    }
    return error.toString();
  }

  static String? diagnosticHint(Object error) {
    final raw = error.toString();

    if (raw.contains('There are multiple heroes that share the same tag')) {
      return 'Asigná heroTag únicos a cada FloatingActionButton o desactivá Hero en FAB que convivan dentro de un IndexedStack o TabBarView.';
    }

    if (raw.contains('A RenderFlex overflowed')) {
      return 'Probá usando Expanded, Flexible, FittedBox o layouts adaptativos con LayoutBuilder para pantallas angostas.';
    }

    if (error is FormatException) {
      return 'Verificá el formato del dato de entrada antes de parsearlo.';
    }

    if (error is StateError) {
      return 'Revisá precondiciones y valores nulos/ausentes antes de usar el estado actual.';
    }

    return null;
  }
}
