/// Constantes gerais do aplicativo.
class AppConstants {
  AppConstants._();

  static const String appName = 'Sistema de Pesagem';
  static const String appVersion = '1.0.0';

  /// Casas decimais padrão para peso (kg).
  static const int weightDecimalPlaces = 3;

  /// Casas decimais padrão para valores monetários (R$).
  static const int currencyDecimalPlaces = 2;

  /// Unidade padrão de peso quando o produto não especificar.
  static const String defaultWeightUnit = 'KG';

  /// Unidade usada quando o produto é vendido por unidade (não por
  /// peso) — ver `ItensMgvParser`/`ImportValidator`.
  static const String defaultUnitUnit = 'UN';

  /// Tempo máximo de espera por serviços externos na inicialização
  /// antes de liberar a tela operacional (não bloqueante).
  static const Duration startupServiceTimeout = Duration(seconds: 5);

  /// Porta padrão do servidor HTTP de importação (ver escopo, item 6)
  /// que recebe arquivos enviados pelo app companheiro Windows/Mac.
  static const int defaultImportServerPort = 8090;
}
