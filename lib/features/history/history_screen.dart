import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/weight_utils.dart';
import '../../data/models/weighing_model.dart';
import 'history_controller.dart';
import 'history_detail_screen.dart';

/// Histórico de pesagens impressas (ver escopo, itens 33-36), com
/// filtros por período/código/status.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyControllerProvider);
    final controller = ref.read(historyControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: Column(
        children: [
          _Filters(state: state, controller: controller),
          const Divider(height: 1),
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : state.results.isEmpty
                    ? const Center(child: Text('Nenhuma pesagem encontrada para este filtro.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppDimensions.spaceMd),
                        itemCount: state.results.length,
                        itemBuilder: (context, index) {
                          final item = state.results[index];
                          return _HistoryTile(item: item);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.state, required this.controller});

  final HistoryFilterState state;
  final HistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      child: Column(
        children: [
          Wrap(
            spacing: AppDimensions.spaceSm,
            children: [
              ChoiceChip(
                label: const Text('Hoje'),
                selected: state.period == HistoryPeriodFilter.hoje,
                onSelected: (_) => controller.setPeriod(HistoryPeriodFilter.hoje),
              ),
              ChoiceChip(
                label: const Text('Ontem'),
                selected: state.period == HistoryPeriodFilter.ontem,
                onSelected: (_) => controller.setPeriod(HistoryPeriodFilter.ontem),
              ),
              ChoiceChip(
                label: const Text('Todos'),
                selected: state.period == HistoryPeriodFilter.todos,
                onSelected: (_) => controller.setPeriod(HistoryPeriodFilter.todos),
              ),
              ActionChip(
                label: const Text('Período...'),
                onPressed: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (range != null) {
                    controller.setCustomRange(
                      AppDateUtils.startOfDay(range.start),
                      AppDateUtils.endOfDay(range.end),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Filtrar por código'),
                  onChanged: controller.setCodigo,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              DropdownButton<PrintStatus?>(
                value: state.status,
                hint: const Text('Status'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todos')),
                  ...PrintStatus.values.map(
                    (s) => DropdownMenuItem(value: s, child: Text(s.label)),
                  ),
                ],
                onChanged: controller.setStatus,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final WeighingModel item;

  @override
  Widget build(BuildContext context) {
    final isOk = item.statusImpressao == PrintStatus.impresso ||
        item.statusImpressao == PrintStatus.comanda;
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      child: ListTile(
        title: Text(item.descricao),
        subtitle: Text(
          '${AppDateUtils.formatDateTimeShort(item.dataHora)} · '
          '${WeightUtils.format(item.peso)} · ${CurrencyUtils.format(item.valorTotal)}'
          '${item.comandaNumero != null ? ' · Comanda ${item.comandaNumero}' : ''}',
        ),
        trailing: Text(
          item.statusImpressao.label,
          style: TextStyle(
            color: isOk ? AppColors.statusOk : AppColors.statusError,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => HistoryDetailScreen(weighing: item)),
        ),
      ),
    );
  }
}
