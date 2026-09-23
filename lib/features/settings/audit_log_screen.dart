import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_dimensions.dart';
import '../../core/utils/date_utils.dart';
import '../../data/repositories/repository_providers.dart';

final _auditLogProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(auditRepositoryProvider).watchRecent();
});

/// Consulta o registro de auditoria (ver escopo, item 38): produto
/// importado, arquivo importado, configuração modificada, impressora
/// conectada, impressão/reimpressão, falhas de balança/impressora.
class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(_auditLogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Auditoria')),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text('Nenhum evento registrado ainda.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                child: ListTile(
                  title: Text(log.descricao),
                  subtitle: Text(
                    '${log.tipo.label} · ${AppDateUtils.formatDateTime(log.dataHora)}'
                    '${log.detalhes != null ? '\n${log.detalhes}' : ''}',
                  ),
                  isThreeLine: log.detalhes != null,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar auditoria: $e')),
      ),
    );
  }
}
