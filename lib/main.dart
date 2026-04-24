import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/errors/app_error_handler.dart';

Future<void> main() async {
  await AppErrorHandler.run(() async {
    debugPrint('[startup] main() begin');
    try {
      WidgetsFlutterBinding.ensureInitialized();
      AppErrorHandler.configure();
      debugPrint('[startup] bindings initialized, launching app');
      runApp(const ProviderScope(child: CleanFinanceApp()));
      debugPrint('[startup] runApp() completed');
    } catch (error, stackTrace) {
      AppErrorHandler.report(
        error,
        stackTrace,
        source: 'main',
        context: 'Critical failure before runApp',
      );
      rethrow;
    }
  });
}
