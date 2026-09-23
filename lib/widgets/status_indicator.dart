import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Nível semântico de status, usado em toda a UI operacional
/// (ver escopo, item 41). A cor nunca é o único indicador: sempre
/// acompanhada de ícone e texto.
enum StatusLevel { ok, warning, error, info }

extension on StatusLevel {
  Color get color => switch (this) {
        StatusLevel.ok => AppColors.statusOk,
        StatusLevel.warning => AppColors.statusWarning,
        StatusLevel.error => AppColors.statusError,
        StatusLevel.info => AppColors.statusInfo,
      };

  IconData get icon => switch (this) {
        StatusLevel.ok => Icons.check_circle,
        StatusLevel.warning => Icons.warning_rounded,
        StatusLevel.error => Icons.cancel,
        StatusLevel.info => Icons.info,
      };
}

/// Indicador de status compacto usado na barra superior/dashboard
/// (ex.: 🟢 BALANÇA, 🔴 IMPRESSORA — ver escopo, item 39).
class StatusIndicator extends StatelessWidget {
  final String label;
  final StatusLevel level;
  final VoidCallback? onTap;

  const StatusIndicator({
    super.key,
    required this.label,
    required this.level,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(level.icon, color: level.color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
