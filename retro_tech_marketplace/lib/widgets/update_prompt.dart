import 'package:flutter/material.dart';

import '../constants/theme.dart';
import '../services/update_service.dart';

Future<void> checkForAppUpdate(
  BuildContext context, {
  required UpdateService service,
  required bool userInitiated,
}) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  try {
    final update = await service.checkLatestRelease();
    if (!context.mounted) return;

    if (update.updateAvailable) {
      await _showUpdateDialog(context, update, service);
      return;
    }

    if (userInitiated) {
      messenger?.showSnackBar(
        SnackBar(
          content: Text('You are up to date (${update.currentVersion}).'),
        ),
      );
    }
  } on UpdateCheckException {
    if (!context.mounted || !userInitiated) return;
    messenger?.showSnackBar(
      const SnackBar(content: Text('Update check failed. Try again later.')),
    );
  }
}

Future<void> _showUpdateDialog(
  BuildContext context,
  AppUpdateInfo update,
  UpdateService service,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('Update Available', style: AppTheme.h2),
        content: Text(
          'Version ${update.latestVersion} is available. You are using ${update.currentVersion}.',
          style: AppTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Later'),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final opened = await service.openReleasePage(update.releaseUrl);
              if (!context.mounted) return;
              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                SnackBar(
                  content: Text(
                    opened
                        ? 'Opening release download page.'
                        : 'Release link copied.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download'),
          ),
        ],
      );
    },
  );
}
