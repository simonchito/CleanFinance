import 'package:flutter/material.dart';

import '../../../../app/app_strings.dart';

Future<bool> showConfirmActionDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
}) async {
  final resolvedCancelLabel = cancelLabel ?? AppStrings.of(context).cancel;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(resolvedCancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );

  return confirmed == true;
}
