import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/import_model.dart';
import '../../data/repositories/repository_providers.dart';

/// Histórico de importações (ver escopo, item 9):
///
/// ```text
/// 25/08/2026 14:32
/// PRODUTOS.TXT
/// 1847 produtos
/// SUCESSO
/// ```
class ImportHistoryScreen extends ConsumerWidget {
  const ImportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(_importHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Importações')),
      body: historyAsync.when(
        data: (imports) {
          if (imports.isEmpty) {
            return const Center(child: Text('Nenhuma importação registrada ainda.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            itemCount: imports.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spaceSm),
            itemBuilder: (context, index) => _ImportHistoryCard(import: imports[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar histórico: $error')),
      ),
    );
  }
}

final _importHistoryProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(historyRepositoryProvider).watchRecent();
});

class _ImportHistoryCard extends StatelessWidget {
  final ImportModel import;

  const _ImportHistoryCard({required this.import});

  Color get _statusColor => switch (import.status) {
        ImportStatus.sucesso => AppColors.statusOk,
        ImportStatus.parcial => AppColors.statusWarning,
        ImportStatus.erro => AppColors.statusError,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.spaceMd),
        title: Text(import.arquivo, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(AppDateUtils.formatDateTimeShort(import.dataImportacao)),
            Text('${import.quantidadeLinhas} produtos'
                '${import.produtosComErro > 0 ? " (${import.produtosComErro} com erro)" : ""}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Text(
            import.status.label,
            style: TextStyle(color: _statusColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        onTap: import.erros.isEmpty
            ? null
            : () => _showErrors(context, import),
      ),
    );
  }

  void _showErrors(BuildContext context, ImportModel import) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erros em ${import.arquivo}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: import.erros.length,
            itemBuilder: (context, index) {
              final error = import.erros[index];
              return ListTile(
                dense: true,
                leading: const Icon(Icons.error_outline, color: AppColors.statusError),
                title: Text('Linha ${error.linha}'),
                subtitle: Text(error.motivo),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('FECHAR')),
        ],
      ),
    );
  }
}
