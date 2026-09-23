import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/totem/totem_idle_guard.dart';
import 'core/totem/totem_mode_service.dart';
import 'data/repositories/repository_providers.dart';
import 'data/repositories/settings_repository.dart';
import 'features/home/home_screen.dart';
import 'services/background/background_monitor_service.dart';

/// Widget raiz do aplicativo: define tema, rota inicial e aplica as
/// configurações persistidas de inicialização (modo totem, orientação,
/// monitoramento de importação) de forma assíncrona e não-bloqueante
/// (ver escopo, itens 1 e 45 — nunca travar a tela esperando esses
/// serviços).
///
/// Não contém regra de negócio de venda/pesagem — apenas bootstrap.
class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _totemModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final settings = ref.read(settingsRepositoryProvider);
    final totemEnabled = await settings.getBool(SettingsKeys.totemModeEnabled) ?? false;
    final orientation = await settings.getString(SettingsKeys.screenOrientation) ?? 'auto';

    await TotemModeService.apply(totemEnabled: totemEnabled, orientation: orientation);
    if (mounted) setState(() => _totemModeEnabled = totemEnabled);

    final importServerEnabled = await settings.getBool(SettingsKeys.importServerEnabled) ?? false;
    if (importServerEnabled) {
      await BackgroundMonitorService.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) => TotemIdleGuard(
        enabled: _totemModeEnabled,
        navigatorKey: _navigatorKey,
        child: child!,
      ),
      home: const HomeScreen(),
    );
  }
}
