/// Constantes relacionadas ao banco de dados local.
class DatabaseConstants {
  DatabaseConstants._();

  static const String databaseFileName = 'pesagem_totem.sqlite';

  /// Versão atual do schema. Deve ser incrementada a cada migração
  /// registrada em `migrations.dart`.
  ///
  /// v2: tabela `audit_log` (ver escopo, item 38).
  /// v3: tabela `employees`, vínculo N:N `weighing_employees` e coluna
  /// `comanda_numero` em `weighing_history` (venda por comanda, sem
  /// impressão, com um ou mais funcionários vinculados).
  static const int schemaVersion = 3;
}
