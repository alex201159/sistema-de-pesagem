/// Status de impressão de uma pesagem/etiqueta.
///
/// Usado tanto no histórico de pesagens quanto na fila de impressão
/// (ver escopo, itens 32 e 33).
enum PrintStatus {
  pendente,
  enviando,
  impresso,
  erro,
  cancelado,

  /// Venda registrada por comanda (ver `SalesMode.comanda`): não há
  /// etiqueta impressa, apenas o número da comanda e o(s)
  /// funcionário(s) vinculados no histórico.
  comanda;

  String get label => switch (this) {
        PrintStatus.pendente => 'PENDENTE',
        PrintStatus.enviando => 'ENVIANDO',
        PrintStatus.impresso => 'IMPRESSO',
        PrintStatus.erro => 'ERRO',
        PrintStatus.cancelado => 'CANCELADO',
        PrintStatus.comanda => 'COMANDA',
      };

  static PrintStatus fromName(String name) =>
      PrintStatus.values.firstWhere((e) => e.name == name, orElse: () => PrintStatus.pendente);
}

/// Modo de venda configurado para o totem (ver `SettingsRepository`):
/// alguns clientes imprimem etiqueta, outros trabalham com comandas e
/// não usam impressora — configuração fixa por instalação.
enum SalesMode {
  etiqueta,
  comanda;

  static SalesMode fromName(String name) =>
      SalesMode.values.firstWhere((e) => e.name == name, orElse: () => SalesMode.etiqueta);
}

/// Modelo de domínio de uma pesagem registrada (impressa) no totem.
///
/// Representa uma linha imutável do histórico. Reimpressões
/// (ver escopo item 37) reutilizam estes dados sem recalcular preço.
class WeighingModel {
  final int? id;
  final String uuid;
  final DateTime dataHora;
  final int produtoId;
  final String codigo;
  final String descricao;
  final double peso;
  final double precoKg;
  final double valorTotal;
  final String? codigoBarras;
  final String? layoutEtiqueta;
  final String? impressora;

  /// Número da comanda, quando a venda foi registrada para um cliente
  /// que trabalha com comandas em vez de impressão de etiqueta (ver
  /// `SalesMode.comanda`) — nulo nas vendas impressas normalmente.
  final String? comandaNumero;

  final PrintStatus statusImpressao;
  final int quantidadeImpressoes;

  const WeighingModel({
    this.id,
    required this.uuid,
    required this.dataHora,
    required this.produtoId,
    required this.codigo,
    required this.descricao,
    required this.peso,
    required this.precoKg,
    required this.valorTotal,
    this.codigoBarras,
    this.layoutEtiqueta,
    this.impressora,
    this.comandaNumero,
    this.statusImpressao = PrintStatus.pendente,
    this.quantidadeImpressoes = 0,
  });

  WeighingModel copyWith({
    int? id,
    String? uuid,
    DateTime? dataHora,
    int? produtoId,
    String? codigo,
    String? descricao,
    double? peso,
    double? precoKg,
    double? valorTotal,
    String? codigoBarras,
    String? layoutEtiqueta,
    String? impressora,
    String? comandaNumero,
    PrintStatus? statusImpressao,
    int? quantidadeImpressoes,
  }) {
    return WeighingModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      dataHora: dataHora ?? this.dataHora,
      produtoId: produtoId ?? this.produtoId,
      codigo: codigo ?? this.codigo,
      descricao: descricao ?? this.descricao,
      peso: peso ?? this.peso,
      precoKg: precoKg ?? this.precoKg,
      valorTotal: valorTotal ?? this.valorTotal,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      layoutEtiqueta: layoutEtiqueta ?? this.layoutEtiqueta,
      impressora: impressora ?? this.impressora,
      comandaNumero: comandaNumero ?? this.comandaNumero,
      statusImpressao: statusImpressao ?? this.statusImpressao,
      quantidadeImpressoes: quantidadeImpressoes ?? this.quantidadeImpressoes,
    );
  }

  @override
  String toString() =>
      'WeighingModel(uuid: $uuid, produto: $descricao, peso: $peso, total: $valorTotal)';
}
