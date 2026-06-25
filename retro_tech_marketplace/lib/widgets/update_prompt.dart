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
) async {
  final result = await showDialog<_UpdateDialogResult>(
    context: context,
    builder: (_) {
      return _UpdateDialog(
        update: update,
        service: service,
        rootContext: context,
      );
    },
  );
  if (!context.mounted || result != _UpdateDialogResult.openedInstaller) return;
  ScaffoldMessenger.maybeOf(
    context,
  )?.showSnackBar(const SnackBar(content: Text('Opening installer.')));
}

enum _UpdateDialogResult { openedInstaller }

class _UpdateDialog extends StatefulWidget {
  const _UpdateDialog({
    required this.update,
    required this.service,
    required this.rootContext,
  });

  final AppUpdateInfo update;
  final UpdateService service;
  final BuildContext rootContext;

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  bool downloading = false;
  double? progress;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Available', style: AppTheme.h2),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Version ${widget.update.latestVersion} is available. You are using ${widget.update.currentVersion}.',
            style: AppTheme.body,
          ),
          if (downloading) ...[
            const SizedBox(height: 18),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 10),
            Text(_progressLabel, style: AppTheme.body.copyWith(fontSize: 12)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: downloading ? null : () => Navigator.of(context).pop(),
          child: const Text('Later'),
        ),
        FilledButton.icon(
          onPressed: downloading ? null : _downloadAndInstall,
          icon: const Icon(Icons.download_rounded),
          label: const Text('Download & Install'),
        ),
      ],
    );
  }

  String get _progressLabel {
    final currentProgress = progress;
    if (currentProgress == null) return 'Downloading update...';
    final percent = (currentProgress.clamp(0, 1) * 100).round();
    return 'Downloading update... $percent%';
  }

  Future<void> _downloadAndInstall() async {
    setState(() {
      downloading = true;
      progress = null;
    });

    try {
      await widget.service.downloadAndInstallUpdate(
        widget.update,
        onProgress: (value) {
          if (!mounted) return;
          setState(() => progress = value);
        },
      );
      if (!mounted) return;
      Navigator.of(context).pop(_UpdateDialogResult.openedInstaller);
    } on UpdateInstallException catch (error) {
      _showFailure(error.message);
    }
  }

  void _showFailure(String message) {
    if (!mounted) return;
    setState(() => downloading = false);
    if (!widget.rootContext.mounted) return;
    ScaffoldMessenger.maybeOf(
      widget.rootContext,
    )?.showSnackBar(SnackBar(content: Text(message)));
  }
}
