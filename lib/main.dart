import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/utils/app_logger.dart';

/// Ponto de entrada do aplicativo.
///
/// Responsabilidade única: inicializar bindings essenciais e subir a
/// árvore de widgets com o `ProviderScope` (injeção de dependências
/// via Riverpod). Abertura de banco, conexão com balança/impressora e
/// monitoramento de importação são feitos sob demanda pelos próprios
/// providers/serviços — nunca aqui de forma bloqueante
/// (ver escopo, itens 1 e 45).
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    AppLogger.e(
      'Erro não tratado do Flutter',
      details.exception,
      details.stack,
    );
  };

  runApp(const ProviderScope(child: App()));
}
