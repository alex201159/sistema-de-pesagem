import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pesagem_totem/app.dart';

void main() {
  testWidgets('App abre na tela inicial sem lançar exceções', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    // O bootstrap assíncrono do App (modo totem, orientação — ver
    // `app.dart`) precisa de um tempo real para resolver as chamadas
    // de plataforma (SystemChrome/Wakelock); um único `pump()` sem
    // avançar o relógio deixa isso pendente na hora do teardown.
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(App), findsOneWidget);
    expect(find.text('Sistema de Pesagem'), findsWidgets);
  });
}
