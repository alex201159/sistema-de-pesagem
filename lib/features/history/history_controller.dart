import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../data/models/weighing_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/repositories/weighing_repository.dart';

/// Filtro de período do histórico (ver escopo, item 35).
enum HistoryPeriodFilter { hoje, ontem, periodo, todos }

class HistoryFilterState {
  final HistoryPeriodFilter period;
  final DateTime? customFrom;
  final DateTime? customTo;
  final String codigo;
  final PrintStatus? status;
  final List<WeighingModel> results;
  final bool loading;

  const HistoryFilterState({
    this.period = HistoryPeriodFilter.hoje,
    this.customFrom,
    this.customTo,
    this.codigo = '',
    this.status,
    this.results = const [],
    this.loading = false,
  });

  HistoryFilterState copyWith({
    HistoryPeriodFilter? period,
    DateTime? customFrom,
    DateTime? customTo,
    String? codigo,
    PrintStatus? status,
    bool clearStatus = false,
    List<WeighingModel>? results,
    bool? loading,
  }) {
    return HistoryFilterState(
      period: period ?? this.period,
      customFrom: customFrom ?? this.customFrom,
      customTo: customTo ?? this.customTo,
      codigo: codigo ?? this.codigo,
      status: clearStatus ? null : (status ?? this.status),
      results: results ?? this.results,
      loading: loading ?? this.loading,
    );
  }
}

/// Controla a tela de histórico: filtros (hoje/ontem/período/código/
/// status — ver escopo, item 35) sobre `WeighingRepository.query`.
class HistoryController extends StateNotifier<HistoryFilterState> {
  HistoryController(this._repository) : super(const HistoryFilterState()) {
    reload();
  }

  final WeighingRepository _repository;

  void setPeriod(HistoryPeriodFilter period) {
    state = state.copyWith(period: period);
    reload();
  }

  void setCustomRange(DateTime from, DateTime to) {
    state = state.copyWith(period: HistoryPeriodFilter.periodo, customFrom: from, customTo: to);
    reload();
  }

  void setCodigo(String codigo) {
    state = state.copyWith(codigo: codigo);
    reload();
  }

  void setStatus(PrintStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
    reload();
  }

  Future<void> reload() async {
    state = state.copyWith(loading: true);
    final (from, to) = _resolveRange();
    final results = await _repository.query(
      from: from,
      to: to,
      codigo: state.codigo.isEmpty ? null : state.codigo,
      status: state.status,
    );
    state = state.copyWith(results: results, loading: false);
  }

  (DateTime?, DateTime?) _resolveRange() {
    switch (state.period) {
      case HistoryPeriodFilter.hoje:
        final now = DateTime.now();
        return (AppDateUtils.startOfDay(now), AppDateUtils.endOfDay(now));
      case HistoryPeriodFilter.ontem:
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        return (AppDateUtils.startOfDay(yesterday), AppDateUtils.endOfDay(yesterday));
      case HistoryPeriodFilter.periodo:
        return (state.customFrom, state.customTo);
      case HistoryPeriodFilter.todos:
        return (null, null);
    }
  }
}

final historyControllerProvider =
    StateNotifierProvider.autoDispose<HistoryController, HistoryFilterState>((ref) {
  return HistoryController(ref.watch(weighingRepositoryProvider));
});
