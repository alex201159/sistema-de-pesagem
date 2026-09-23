import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/import_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../services/printer/printer_providers.dart';
import '../../services/printer/printer_service.dart';
import '../../services/scale/scale_providers.dart';
import '../../services/scale/scale_service.dart';
import '../../widgets/status_indicator.dart';
import '../employees/employees_screen.dart';
import '../import/import_screen.dart';
import '../products/products_screen.dart';
import '../settings/settings_screen.dart';
import '../weighing/weighing_screen.dart';

/// Tela inicial: acesso à venda/pesagem e à importação de produtos
/// (ver escopo, item 46 — tela de configurações chega em etapa futura).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productCountAsync = ref.watch(_productCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'Configurações',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              const _StatusDashboard(),
              const SizedBox(height: AppDimensions.spaceLg),
              const Icon(Icons.scale_outlined, size: 96, color: AppColors.primary),
              const SizedBox(height: AppDimensions.spaceLg),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              productCountAsync.when(
                data: (count) => Text(
                  '$count produto(s) cadastrado(s)',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text(
                  'Erro ao acessar o banco de dados: $error',
                  style: const TextStyle(color: AppColors.statusError),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              SizedBox(
                width: 280,
                height: AppDimensions.buttonHeightPrimary,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WeighingScreen()),
                  ),
                  icon: const Icon(Icons.scale),
                  label: const Text('INICIAR VENDA'),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              SizedBox(
                width: 280,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProductsScreen()),
                  ),
                  icon: const Icon(Icons.list_alt),
                  label: const Text('PRODUTOS'),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              SizedBox(
                width: 280,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ImportScreen()),
                  ),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('IMPORTAR PRODUTOS'),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              SizedBox(
                width: 280,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EmployeesScreen()),
                  ),
                  icon: const Icon(Icons.badge_outlined),
                  label: const Text('FUNCIONÁRIOS'),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _productCountProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.watchAll(onlyActive: false).map((products) => products.length);
});

final _lastImportStatusProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(historyRepositoryProvider).watchRecent(limit: 1);
});

/// Barra de status da tela principal (ver escopo, item 39): balança,
/// impressora, rede e importação — cada indicador abre a configuração
/// correspondente ao ser tocado.
class _StatusDashboard extends ConsumerWidget {
  const _StatusDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaleStatus = ref.watch(scaleConnectionStatusProvider);
    final printerStatus = ref.watch(printerConnectionStatusProvider);
    final lastImport = ref.watch(_lastImportStatusProvider);

    return Wrap(
      spacing: AppDimensions.spaceSm,
      runSpacing: AppDimensions.spaceSm,
      alignment: WrapAlignment.center,
      children: [
        StatusIndicator(
          label: 'BALANÇA',
          level: scaleStatus.when(
            data: (s) => switch (s) {
              ScaleConnectionStatus.conectada => StatusLevel.ok,
              ScaleConnectionStatus.conectando => StatusLevel.warning,
              ScaleConnectionStatus.semBalanca => StatusLevel.error,
              ScaleConnectionStatus.erro => StatusLevel.error,
            },
            loading: () => StatusLevel.info,
            error: (_, _) => StatusLevel.error,
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
        ),
        StatusIndicator(
          label: 'IMPRESSORA',
          level: printerStatus.when(
            data: (s) => switch (s) {
              PrinterConnectionStatus.conectada => StatusLevel.ok,
              PrinterConnectionStatus.conectando => StatusLevel.warning,
              PrinterConnectionStatus.desconectada => StatusLevel.error,
              PrinterConnectionStatus.erro => StatusLevel.error,
            },
            loading: () => StatusLevel.info,
            error: (_, _) => StatusLevel.error,
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
        ),
        StatusIndicator(
          label: 'REDE',
          level: StatusLevel.info,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
        ),
        StatusIndicator(
          label: 'IMPORTAÇÃO',
          level: lastImport.when(
            data: (list) {
              if (list.isEmpty) return StatusLevel.info;
              return switch (list.first.status) {
                ImportStatus.sucesso => StatusLevel.ok,
                ImportStatus.parcial => StatusLevel.warning,
                ImportStatus.erro => StatusLevel.error,
              };
            },
            loading: () => StatusLevel.info,
            error: (_, _) => StatusLevel.error,
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
        ),
      ],
    );
  }
}
