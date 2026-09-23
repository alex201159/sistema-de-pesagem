import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_dimensions.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/weight_utils.dart';
import '../../data/models/audit_log_model.dart';
import '../../data/models/employee_model.dart';
import '../../data/models/weighing_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../services/printer/printer_providers.dart';
import '../../services/printer/printer_service.dart';

/// Detalhe de uma pesagem do histórico (ver escopo, item 36), com
/// opção de reimpressão (item 37): reutiliza os dados originais sem
/// recalcular preço, registra que houve reimpressão e incrementa o
/// contador de impressões.
class HistoryDetailScreen extends ConsumerStatefulWidget {
  const HistoryDetailScreen({super.key, required this.weighing});

  final WeighingModel weighing;

  @override
  ConsumerState<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends ConsumerState<HistoryDetailScreen> {
  bool _reprinting = false;
  String? _message;
  List<EmployeeModel> _employees = const [];

  @override
  void initState() {
    super.initState();
    final weighing = widget.weighing;
    if (weighing.comandaNumero != null && weighing.id != null) {
      ref.read(weighingRepositoryProvider).getEmployeesForWeighing(weighing.id!).then((list) {
        if (mounted) setState(() => _employees = list);
      });
    }
  }

  Future<void> _reprint() async {
    final weighing = widget.weighing;
    setState(() {
      _reprinting = true;
      _message = null;
    });
    try {
      final queue = ref.read(printQueueServiceProvider);
      await queue.enqueue(
        LabelPrintData(
          produto: weighing.descricao,
          codigo: weighing.codigo,
          peso: weighing.peso,
          precoKg: weighing.precoKg,
          total: weighing.valorTotal,
          codigoBarras: weighing.codigoBarras ?? '',
          dataHora: weighing.dataHora,
        ),
        jobId: '${weighing.uuid}-reimpressao-${DateTime.now().millisecondsSinceEpoch}',
      );

      await ref.read(weighingRepositoryProvider).updateStatus(
            weighing.id!,
            status: PrintStatus.impresso,
            incrementPrintCount: 1,
          );
      await ref.read(auditRepositoryProvider).insert(AuditLogModel(
            dataHora: DateTime.now(),
            tipo: AuditEventType.reimpressao,
            descricao: 'Reimpressão de "${weighing.descricao}" (${weighing.dataHora})',
          ));

      if (mounted) setState(() => _message = 'Etiqueta reimpressa com sucesso.');
    } catch (e, st) {
      AppLogger.e('Falha ao reimprimir etiqueta', e, st);
      if (mounted) setState(() => _message = 'Falha ao reimprimir: $e');
    } finally {
      if (mounted) setState(() => _reprinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weighing = widget.weighing;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe da Pesagem')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        children: [
          _DetailRow(label: 'Produto', value: weighing.descricao),
          _DetailRow(label: 'Código', value: weighing.codigo),
          _DetailRow(label: 'Peso', value: WeightUtils.format(weighing.peso)),
          _DetailRow(label: 'Preço/kg', value: CurrencyUtils.format(weighing.precoKg)),
          _DetailRow(label: 'Total', value: CurrencyUtils.format(weighing.valorTotal)),
          _DetailRow(label: 'Código de barras', value: weighing.codigoBarras ?? '—'),
          _DetailRow(label: 'Data', value: AppDateUtils.formatDateTime(weighing.dataHora)),
          _DetailRow(label: 'Impressora', value: weighing.impressora ?? '—'),
          _DetailRow(label: 'Status', value: weighing.statusImpressao.label),
          _DetailRow(label: 'Qtd. impressões', value: '${weighing.quantidadeImpressoes}'),
          if (weighing.comandaNumero != null) ...[
            _DetailRow(label: 'Comanda', value: weighing.comandaNumero!),
            _DetailRow(
              label: 'Funcionário(s)',
              value: _employees.isEmpty ? '—' : _employees.map((e) => e.nome).join(', '),
            ),
          ],
          const SizedBox(height: AppDimensions.spaceLg),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
              child: Text(_message!),
            ),
          if (weighing.statusImpressao != PrintStatus.comanda)
            FilledButton.icon(
              icon: _reprinting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.print),
              label: const Text('REIMPRIMIR ETIQUETA'),
              onPressed: _reprinting ? null : _reprint,
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
