import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usb_serial/usb_serial.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/audit_log_model.dart';
import '../../data/models/scale_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../services/scale/ble_gateway_scale_service.dart';
import '../../services/scale/ble_scale_scanner.dart';
import '../../services/scale/scale_line_weight_parser.dart';
import '../../services/scale/scale_providers.dart';
import '../../services/scale/scale_service.dart';
import '../../services/scale/serial_port_scale_service.dart';
import '../../services/scale/serial_protocol.dart';
import '../../services/scale/usb_serial_scale_service.dart';
import '../../widgets/status_indicator.dart';

/// Configuração da balança (ver escopo, itens 10 e 46): escolher o
/// transporte (gateway BLE ou cabo serial USB-OTG), parear/selecionar
/// o dispositivo e ajustar o protocolo serial e o recorte do peso.
class ScaleSettingsScreen extends ConsumerStatefulWidget {
  const ScaleSettingsScreen({super.key});

  @override
  ConsumerState<ScaleSettingsScreen> createState() => _ScaleSettingsScreenState();
}

class _ScaleSettingsScreenState extends ConsumerState<ScaleSettingsScreen> {
  ScaleTransportType _transport = SerialPortScaleService.isSupported
      ? ScaleTransportType.serialPort
      : ScaleTransportType.ble;
  SerialProtocol _protocol = SerialProtocol.defaultProtocol;
  ScaleLineWeightParser _weightParser = const ScaleLineWeightParser();

  bool _scanning = false;
  bool _connecting = false;
  String? _connectingEndereco;
  String? _error;
  List<fbp.ScanResult> _bleResults = [];
  List<UsbDevice> _usbDevices = [];
  List<String> _serialPorts = [];

  /// Endereço (porta COM, MAC BLE, device USB) da última balança
  /// conectada com sucesso — usado só para destacar visualmente o item
  /// correspondente nas listas abaixo, nunca para decidir o que
  /// conectar.
  String? _connectedEndereco;

  final List<String> _rawLines = [];
  static const _maxRawLines = 20;
  StreamSubscription<String>? _rawLineSub;

  @override
  void initState() {
    super.initState();
    _load();
    _rawLineSub = ref.read(scaleServiceProvider).rawLineStream.listen((line) {
      if (!mounted) return;
      setState(() {
        _rawLines.insert(0, line);
        if (_rawLines.length > _maxRawLines) _rawLines.removeLast();
      });
    });
  }

  Future<void> _load() async {
    final settings = ref.read(settingsRepositoryProvider);
    final scaleRepo = ref.read(scaleRepositoryProvider);
    final protocol = await settings.getScaleSerialProtocol();
    final weightParser = await settings.getScaleWeightParser();
    final defaultScale = await scaleRepo.getDefault();
    if (!mounted) return;
    setState(() {
      _protocol = protocol;
      _weightParser = weightParser;
      if (defaultScale != null) {
        _transport = defaultScale.tipoConexao;
        _connectedEndereco = defaultScale.endereco;
      }
    });
  }

  @override
  void dispose() {
    if (_transport == ScaleTransportType.ble) BleScaleScanner.stopScan();
    _rawLineSub?.cancel();
    super.dispose();
  }

  Future<void> _scanBle() async {
    setState(() {
      _scanning = true;
      _bleResults = [];
      _error = null;
    });
    try {
      await BleScaleScanner.startScan();
      BleScaleScanner.scanResults.listen((results) {
        if (mounted) setState(() => _bleResults = results);
      });
      await Future.delayed(const Duration(seconds: 10));
    } catch (e) {
      if (mounted) setState(() => _error = 'Falha ao escanear: $e');
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  Future<void> _refreshUsbDevices() async {
    final devices = await UsbSerialScaleService.listDevices();
    if (mounted) setState(() => _usbDevices = devices);
  }

  Future<void> _refreshSerialPorts() async {
    final ports = await SerialPortScaleService.listPorts();
    if (mounted) setState(() => _serialPorts = ports);
  }

  Future<void> _connect(String endereco, String nome) async {
    setState(() {
      _connecting = true;
      _connectingEndereco = endereco;
      _error = null;
    });
    try {
      final settings = ref.read(settingsRepositoryProvider);
      await settings.setScaleSerialProtocol(_protocol);
      await settings.setScaleWeightParser(_weightParser);

      final scale = ScaleModel(
        nome: nome,
        endereco: endereco,
        tipoConexao: _transport,
        protocolo: 'generico',
        padrao: true,
      );
      await ref.read(scaleRepositoryProvider).save(scale);

      final implementation = switch (_transport) {
        ScaleTransportType.ble =>
          BleGatewayScaleService(protocol: _protocol, weightParser: _weightParser),
        ScaleTransportType.serialPort =>
          SerialPortScaleService.create(protocol: _protocol, weightParser: _weightParser),
        _ => UsbSerialScaleService(protocol: _protocol, weightParser: _weightParser),
      };
      await ref.read(scaleServiceProvider).useImplementation(implementation, scale);
      if (mounted) setState(() => _connectedEndereco = endereco);
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na balança configurada', e, st);
      await ref.read(auditRepositoryProvider).insert(AuditLogModel(
            dataHora: DateTime.now(),
            tipo: AuditEventType.falhaBalanca,
            descricao: 'Falha ao conectar em "$nome" ($endereco)',
            detalhes: e.toString(),
          ));
      if (mounted) setState(() => _error = 'Falha ao conectar: $e');
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(scaleConnectionStatusProvider);
    final weight = ref.watch(scaleWeightStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Balança')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: Row(
                children: [
                  status.when(
                    data: (s) => StatusIndicator(
                      label: s.name.toUpperCase(),
                      level: s == ScaleConnectionStatus.conectada
                          ? StatusLevel.ok
                          : s == ScaleConnectionStatus.erro
                              ? StatusLevel.error
                              : StatusLevel.warning,
                    ),
                    loading: () => const StatusIndicator(label: '...', level: StatusLevel.info),
                    error: (_, _) => const StatusIndicator(label: 'ERRO', level: StatusLevel.error),
                  ),
                  const Spacer(),
                  weight.when(
                    data: (w) => Text('${w.kg.toStringAsFixed(3)} kg'),
                    loading: () => const Text('—'),
                    error: (_, _) => const Text('—'),
                  ),
                ],
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceSm),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text('TRANSPORTE', style: Theme.of(context).textTheme.bodySmall),
          RadioGroup<ScaleTransportType>(
            groupValue: _transport,
            onChanged: (v) => setState(() => _transport = v!),
            child: Column(
              children: [
                if (Platform.isWindows)
                  const RadioListTile(
                    value: ScaleTransportType.serialPort,
                    title: Text('Porta Serial (COM)'),
                    subtitle: Text('Balança conectada a uma porta COM do PC'),
                  )
                else if (Platform.isLinux) ...const [
                  RadioListTile(
                    value: ScaleTransportType.serialPort,
                    title: Text('Porta Serial'),
                    subtitle: Text('Adaptador USB-serial (/dev/ttyUSB*) ou UART da placa (/dev/ttyS*)'),
                  ),
                  RadioListTile(
                    value: ScaleTransportType.ble,
                    title: Text('Bluetooth BLE (gateway)'),
                  ),
                ] else ...const [
                  RadioListTile(
                    value: ScaleTransportType.ble,
                    title: Text('Bluetooth BLE (gateway)'),
                  ),
                  RadioListTile(
                    value: ScaleTransportType.usbSerial,
                    title: Text('Cabo USB (adaptador serial RS232-USB)'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text('PROTOCOLO SERIAL', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppDimensions.spaceSm),
          _SerialProtocolFields(
            protocol: _protocol,
            onChanged: (p) => setState(() => _protocol = p),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text('RECORTE DO PESO NA LINHA', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppDimensions.spaceSm),
          _WeightExtractionFields(
            parser: _weightParser,
            onChanged: (p) => setState(() => _weightParser = p),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text('DADOS BRUTOS RECEBIDOS', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppDimensions.spaceSm),
          _RawDataPanel(lines: _rawLines, parser: _weightParser),
          const SizedBox(height: AppDimensions.spaceLg),
          if (_transport == ScaleTransportType.ble) ...[
            FilledButton.icon(
              icon: const Icon(Icons.bluetooth_searching),
              label: Text(_scanning ? 'ESCANEANDO...' : 'ESCANEAR GATEWAYS BLE'),
              onPressed: _scanning ? null : _scanBle,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            for (final result in _bleResults)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.scale),
                  title: Text(result.device.platformName.isNotEmpty
                      ? result.device.platformName
                      : result.device.remoteId.str),
                  subtitle: Text(result.device.remoteId.str),
                  trailing: FilledButton(
                    onPressed: _connecting ? null : () => _connect(
                          result.device.remoteId.str,
                          result.device.platformName.isNotEmpty
                              ? result.device.platformName
                              : 'Balança BLE',
                        ),
                    child: _connecting && _connectingEndereco == result.device.remoteId.str
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('CONECTAR'),
                  ),
                ),
              ),
          ] else if (_transport == ScaleTransportType.serialPort) ...[
            FilledButton.icon(
              icon: const Icon(Icons.cable),
              label: const Text('BUSCAR PORTAS SERIAIS'),
              onPressed: _refreshSerialPorts,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            for (final port in _serialPorts)
              Builder(builder: (context) {
                final isConnected =
                    port == _connectedEndereco && status.value == ScaleConnectionStatus.conectada;
                return Card(
                  color: isConnected ? AppColors.primary.withValues(alpha: 0.12) : null,
                  shape: isConnected
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          side: const BorderSide(color: AppColors.primary, width: 2),
                        )
                      : null,
                  child: ListTile(
                    leading: Icon(
                      isConnected ? Icons.check_circle : Icons.settings_input_component,
                      color: isConnected ? AppColors.statusOk : null,
                    ),
                    title: Text(port),
                    trailing: isConnected
                        ? const Text(
                            'CONECTADA',
                            style: TextStyle(color: AppColors.statusOk, fontWeight: FontWeight.bold),
                          )
                        : FilledButton(
                            onPressed: _connecting ? null : () => _connect(port, port),
                            child: _connecting && _connectingEndereco == port
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('CONECTAR'),
                          ),
                  ),
                );
              }),
          ] else ...[
            FilledButton.icon(
              icon: const Icon(Icons.usb),
              label: const Text('BUSCAR ADAPTADORES USB'),
              onPressed: _refreshUsbDevices,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            for (final device in _usbDevices)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.cable),
                  title: Text(device.productName ?? device.deviceName),
                  subtitle: Text(device.deviceName),
                  trailing: FilledButton(
                    onPressed: _connecting ? null : () => _connect(device.deviceName, device.productName ?? 'Balança USB'),
                    child: _connecting && _connectingEndereco == device.deviceName
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('CONECTAR'),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SerialProtocolFields extends StatelessWidget {
  const _SerialProtocolFields({required this.protocol, required this.onChanged});

  final SerialProtocol protocol;
  final ValueChanged<SerialProtocol> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spaceMd,
      runSpacing: AppDimensions.spaceSm,
      children: [
        DropdownMenu<int>(
          label: const Text('Baud'),
          initialSelection: protocol.baud,
          dropdownMenuEntries: SerialProtocol.bauds
              .map((b) => DropdownMenuEntry(value: b, label: '$b'))
              .toList(),
          onSelected: (v) {
            if (v != null) {
              onChanged(SerialProtocol(
                baud: v,
                parity: protocol.parity,
                stopBits: protocol.stopBits,
                dataBits: protocol.dataBits,
              ));
            }
          },
        ),
        DropdownMenu<String>(
          label: const Text('Paridade'),
          initialSelection: protocol.parity,
          dropdownMenuEntries: List.generate(
            SerialProtocol.parities.length,
            (i) => DropdownMenuEntry(
              value: SerialProtocol.parities[i],
              label: SerialProtocol.parityLabels[i],
            ),
          ),
          onSelected: (v) {
            if (v != null) {
              onChanged(SerialProtocol(
                baud: protocol.baud,
                parity: v,
                stopBits: protocol.stopBits,
                dataBits: protocol.dataBits,
              ));
            }
          },
        ),
        DropdownMenu<int>(
          label: const Text('Stop bits'),
          initialSelection: protocol.stopBits,
          dropdownMenuEntries: SerialProtocol.stopBitOptions
              .map((b) => DropdownMenuEntry(value: b, label: '$b'))
              .toList(),
          onSelected: (v) {
            if (v != null) {
              onChanged(SerialProtocol(
                baud: protocol.baud,
                parity: protocol.parity,
                stopBits: v,
                dataBits: protocol.dataBits,
              ));
            }
          },
        ),
        DropdownMenu<int>(
          label: const Text('Data bits'),
          initialSelection: protocol.dataBits,
          dropdownMenuEntries: SerialProtocol.dataBitOptions
              .map((b) => DropdownMenuEntry(value: b, label: '$b'))
              .toList(),
          onSelected: (v) {
            if (v != null) {
              onChanged(SerialProtocol(
                baud: protocol.baud,
                parity: protocol.parity,
                stopBits: protocol.stopBits,
                dataBits: v,
              ));
            }
          },
        ),
      ],
    );
  }
}

class _WeightExtractionFields extends StatelessWidget {
  const _WeightExtractionFields({required this.parser, required this.onChanged});

  final ScaleLineWeightParser parser;
  final ValueChanged<ScaleLineWeightParser> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            key: ValueKey('start-${parser.extractStart}'),
            initialValue: '${parser.extractStart}',
            decoration: const InputDecoration(labelText: 'Posição inicial'),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              final n = int.tryParse(v);
              if (n != null) onChanged(parser.copyWith(extractStart: n));
            },
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMd),
        Expanded(
          child: TextFormField(
            key: ValueKey('length-${parser.extractLength}'),
            initialValue: '${parser.extractLength}',
            decoration: const InputDecoration(labelText: 'Tamanho'),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              final n = int.tryParse(v);
              if (n != null) onChanged(parser.copyWith(extractLength: n));
            },
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMd),
        Expanded(
          child: TextFormField(
            key: ValueKey('decimals-${parser.implicitDecimals}'),
            initialValue: '${parser.implicitDecimals}',
            decoration: const InputDecoration(labelText: 'Casas decimais'),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              final n = int.tryParse(v);
              if (n != null) onChanged(parser.copyWith(implicitDecimals: n));
            },
          ),
        ),
      ],
    );
  }
}

/// Mostra as últimas linhas cruas recebidas do transporte ativo
/// (BLE/serial) e, para a mais recente, destaca o trecho que o recorte
/// configurado ([parser]) usaria e o peso resultante — permite calibrar
/// posição/tamanho/casas decimais vendo o efeito imediatamente, mesmo
/// quando o recorte atual ainda não extrai um peso válido (ver escopo,
/// item 12).
class _RawDataPanel extends StatelessWidget {
  const _RawDataPanel({required this.lines, required this.parser});

  final List<String> lines;
  final ScaleLineWeightParser parser;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spaceMd),
          child: Text(
            'Nenhum dado bruto recebido ainda. Escaneie e conecte um '
            'dispositivo para ver as linhas chegando aqui.',
          ),
        ),
      );
    }

    final latest = lines.first;
    final weight = parser.extract(latest);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weight != null
                  ? 'Peso extraído da última linha: ${weight.toStringAsFixed(3)} kg'
                  : 'O recorte atual não encontrou um peso nesta linha.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: weight != null ? AppColors.statusOk : AppColors.statusError,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            _HighlightedLine(line: latest, parser: parser),
            const Divider(height: AppDimensions.spaceLg),
            SizedBox(
              height: 160,
              child: ListView.builder(
                itemCount: lines.length,
                itemBuilder: (context, index) => Text(
                  lines[index],
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightedLine extends StatelessWidget {
  const _HighlightedLine({required this.line, required this.parser});

  final String line;
  final ScaleLineWeightParser parser;

  @override
  Widget build(BuildContext context) {
    final start = (parser.extractStart - 1).clamp(0, line.length);
    final end = (start + parser.extractLength).clamp(start, line.length);

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        children: [
          TextSpan(text: line.substring(0, start)),
          TextSpan(
            text: line.substring(start, end),
            style: const TextStyle(
              backgroundColor: AppColors.accent,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextSpan(text: line.substring(end)),
        ],
      ),
    );
  }
}
