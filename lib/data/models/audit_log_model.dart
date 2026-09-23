/// Tipos de evento auditados (ver escopo, item 38).
enum AuditEventType {
  produtoImportado,
  produtoAtualizado,
  arquivoImportado,
  configuracaoModificada,
  impressoraConectada,
  impressaoRealizada,
  reimpressao,
  falhaImpressao,
  falhaBalanca,
  etiquetaRecebida,
  vendaComanda;

  String get label => switch (this) {
        AuditEventType.produtoImportado => 'Produto importado',
        AuditEventType.produtoAtualizado => 'Produto atualizado',
        AuditEventType.arquivoImportado => 'Arquivo importado',
        AuditEventType.configuracaoModificada => 'Configuração modificada',
        AuditEventType.impressoraConectada => 'Impressora conectada',
        AuditEventType.impressaoRealizada => 'Impressão realizada',
        AuditEventType.reimpressao => 'Reimpressão',
        AuditEventType.falhaImpressao => 'Falha de impressão',
        AuditEventType.falhaBalanca => 'Falha de balança',
        AuditEventType.etiquetaRecebida => 'Etiqueta recebida via rede',
        AuditEventType.vendaComanda => 'Venda registrada por comanda',
      };
}

class AuditLogModel {
  final int? id;
  final DateTime dataHora;
  final AuditEventType tipo;
  final String descricao;
  final String? detalhes;

  const AuditLogModel({
    this.id,
    required this.dataHora,
    required this.tipo,
    required this.descricao,
    this.detalhes,
  });
}
