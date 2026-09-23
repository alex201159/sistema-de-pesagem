import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_dimensions.dart';
import '../../data/models/audit_log_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/background/background_monitor_service.dart';
import '../../widgets/status_indicator.dart';

/// Configuração do servidor de importação (ver escopo, itens 6 e 46).
///
/// O totem expõe um servidor HTTP simples na rede local; um app
/// companheiro Windows/Mac (`totem_import_sender`) vigia a pasta do
/// ERP e envia o arquivo diretamente para este endereço quando detecta
/// algo novo/estável — substitui a antiga tentativa de importação via
/// SMB, que nunca chegou a ser implementada de verdade.
class NetworkSettingsScreen extends ConsumerStatefulWidget {
  const NetworkSettingsScreen({super.key});

  @override
  ConsumerState<NetworkSettingsScreen> createState() => _NetworkSettingsScreenState();
}

class _NetworkSettingsScreenState extends ConsumerState<NetworkSettingsScreen> {
  final _portController = TextEditingController();

  List<String> _localIps = [];
  bool _serverEnabled = false;
  bool _serverRunning = false;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _portController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final settings = ref.read(settingsRepositoryProvider);
    final port = await settings.getImportServerPort();
    final enabled = await settings.getBool(SettingsKeys.importServerEnabled) ?? false;
    final running = await BackgroundMonitorService.isRunningService;
    final ips = await _resolveLocalIps();

    if (!mounted) return;
    setState(() {
      _portController.text = '$port';
      _serverEnabled = enabled;
      _serverRunning = running;
      _localIps = ips;
      _loading = false;
    });
  }

  Future<List<String>> _resolveLocalIps() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      return interfaces.expand((i) => i.addresses).map((a) => a.address).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _toggleServer(bool value) async {
    setState(() => _busy = true);
    final settings = ref.read(settingsRepositoryProvider);
    final port = int.tryParse(_portController.text) ?? 8090;

    await settings.setImportServerPort(port);
    await settings.setBool(SettingsKeys.importServerEnabled, value);

    if (value) {
      await BackgroundMonitorService.start();
    } else {
      await BackgroundMonitorService.stop();
    }

    await ref.read(auditRepositoryProvider).insert(AuditLogModel(
          dataHora: DateTime.now(),
          tipo: AuditEventType.configuracaoModificada,
          descricao: value
              ? 'Servidor de importação ativado (porta $port)'
              : 'Servidor de importação desativado',
        ));

    final running = await BackgroundMonitorService.isRunningService;
    if (!mounted) return;
    setState(() {
      _serverEnabled = value;
      _serverRunning = running;
      _busy = false;
    });
  }

  Future<void> _savePort() async {
    final port = int.tryParse(_portController.text);
    if (port == null || port < 1 || port > 65535) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Porta inválida.')),
      );
      return;
    }
    await ref.read(settingsRepositoryProvider).setImportServerPort(port);
    if (_serverEnabled) {
      // Reinicia o servidor para aplicar a nova porta.
      await BackgroundMonitorService.stop();
      await BackgroundMonitorService.start();
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Porta salva.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Rede (Importação)')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        children: [
          Text('ENDEREÇO DESTE TOTEM', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppDimensions.spaceSm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceLg),
              child: _localIps.isEmpty
                  ? const Text('Nenhuma rede Wi-Fi conectada no momento.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _localIps
                          .map((ip) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppDimensions.spaceXs),
                                child: Text(
                                  ip,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontFeatures: const [FontFeature.tabularFigures()],
                                      ),
                                ),
                              ))
                          .toList(),
                    ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            'Configure este IP e a porta abaixo no app "totem_import_sender" '
            '(Windows/Mac) para que ele saiba enviar os arquivos pra cá.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _portController,
                  decoration: const InputDecoration(labelText: 'Porta do servidor'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              FilledButton(onPressed: _savePort, child: const Text('SALVAR')),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Card(
            child: SwitchListTile(
              title: const Text('Servidor de importação'),
              subtitle: Text(
                _serverEnabled && _serverRunning
                    ? 'Ativo — pronto para receber arquivos'
                    : 'Desligado',
              ),
              secondary: StatusIndicator(
                label: _serverEnabled && _serverRunning ? 'ATIVO' : 'PARADO',
                level: _serverEnabled && _serverRunning ? StatusLevel.ok : StatusLevel.error,
              ),
              value: _serverEnabled,
              onChanged: _busy ? null : _toggleServer,
            ),
          ),
        ],
      ),
    );
  }
}
