import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import 'glass_card.dart';
import 'liquid_button.dart';

void showAppSnackBar(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppTheme.ink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}

Future<void> copyShareText(
  BuildContext context, {
  required String label,
  required String text,
}) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  showAppSnackBar(context, '$label copied to clipboard.');
}

Future<void> showInfoSheet(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String body,
  String actionLabel = 'Done',
  VoidCallback? onAction,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.white.withValues(alpha: 0.38),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: GlassCard(
            radius: 28,
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            opacity: 0.84,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppTheme.blue, size: 30),
                const SizedBox(height: 12),
                Text(title, style: AppTheme.h2.copyWith(fontSize: 20)),
                const SizedBox(height: 8),
                Text(body, style: AppTheme.body.copyWith(height: 1.45)),
                const SizedBox(height: 18),
                LiquidButton(
                  label: actionLabel,
                  height: 48,
                  icon: onAction == null ? Icons.check_rounded : null,
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    onAction?.call();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
