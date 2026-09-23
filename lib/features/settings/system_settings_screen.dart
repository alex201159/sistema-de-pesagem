import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_dimensions.dart';
import '../../core/totem/totem_mode_service.dart';
import '../../data/models/weighing_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/repositories/settings_repository.dart';
import 'audit_log_screen.dart';

/// Configurações gerais do sistema (ver escopo, itens 42 e 46): modo
/// totem, orientação da tela e acesso à auditoria.
class SystemSettingsScreen extends ConsumerStatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  ConsumerState<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends ConsumerState<SystemSettingsScreen> {
  bool _totemModeEnabled = false;
  String _orientation = 'auto';
  SalesMode _salesMode = SalesMode.etiqueta;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = ref.read(settingsRepositoryProvider);
    final totemEnabled = await settings.getBool(SettingsKeys.totemModeEnabled) ?? false;
    final orientation = await settings.getString(SettingsKeys.screenOrientation) ?? 'auto';
    final salesMode = await settings.getSalesMode();
    if (!mounted) return;
    setState(() {
      _totemModeEnabled = totemEnabled;
      _orientation = orientation;
      _salesMode = salesMode;
      _loaded = true;
    });
  }

  Future<void> _apply() async {
    final settings = ref.read(settingsRepositoryProvider);
    await settings.setBool(SettingsKeys.totemModeEnabled, _totemModeEnabled);
    await settings.setString(SettingsKeys.screenOrientation, _orientation);
    await settings.setSalesMode(_salesMode);
    await TotemModeService.apply(totemEnabled: _totemModeEnabled, orientation: _orientation);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sistema')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        children: [
          SwitchListTile(
            title: const Text('Modo totem'),
            subtitle: const Text(
              'Tela cheia, bloqueia o botão voltar e retorna à tela principal '
              'automaticamente após inatividade (ver escopo, item 42).',
            ),
            value: _totemModeEnabled,
            onChanged: (v) async {
              setState(() => _totemModeEnabled = v);
              await _apply();
            },
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text('ORIENTAÇÃO DA TELA', style: Theme.of(context).textTheme.bodySmall),
          RadioGroup<String>(
            groupValue: _orientation,
            onChanged: (v) async {
              setState(() => _orientation = v!);
              await _apply();
            },
            child: const Column(
              children: [
                RadioListTile(value: 'auto', title: Text('Automática')),
                RadioListTile(value: 'portrait', title: Text('Retrato')),
                RadioListTile(value: 'landscape', title: Text('Paisagem')),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text('MODO DE VENDA', style: Theme.of(context).textTheme.bodySmall),
          RadioGroup<SalesMode>(
            groupValue: _salesMode,
            onChanged: (v) async {
              setState(() => _salesMode = v!);
              await _apply();
            },
            child: const Column(
              children: [
                RadioListTile(
                  value: SalesMode.etiqueta,
                  title: Text('Imprimir etiqueta'),
                  subtitle: Text('Fluxo padrão: pesa e imprime a etiqueta com código de barras.'),
                ),
                RadioListTile(
                  value: SalesMode.comanda,
                  title: Text('Comanda (sem impressão)'),
                  subtitle: Text(
                    'Registra o número da comanda e o(s) funcionário(s) da venda, '
                    'sem enviar para a impressora.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Card(
            child: ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: const Text('Auditoria'),
              subtitle: const Text('Eventos importantes do sistema'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AuditLogScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
