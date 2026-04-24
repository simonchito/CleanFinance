import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_permission_service.dart';
import 'notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final notificationPermissionServiceProvider =
    Provider<NotificationPermissionService>(
  (ref) =>
      NotificationPermissionService(ref.watch(notificationServiceProvider)),
);
