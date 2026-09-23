import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../core/theme/app_dimensions.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/audit_log_model.dart';
import '../../data/models/printer_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../services/printer/bluetooth_thermal_printer_service.dart';
import '../../services/printer/linux_usb_printer_service.dart';
import '../../services/printer/printer_providers.dart';
import '../../services/printer/printer_service.dart';
import '../../services/printer/windows_usb_printer_service.dart';
import '../../widgets/status_indicator.dart';

/// Configuração da impressora térmica (ver escopo, itens 30 e 46):
/// listar impressoras Bluetooth pareadas, conectar e testar impressão.
class PrinterSettingsScreen extends ConsumerStatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  ConsumerState<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends ConsumerState<PrinterSettingsScreen> {
  bool _loading = false;
  bool _connecting = false;
  String? _connectingEndereco;
  bool _printingTest = false;
  String? _error;
  List<BluetoothInfo> _devices = [];
  List<String> _usbPrinters = [];

  /// Impressora USB sem Bluetooth: spooler no Windows, `/dev/usb/lp*`
  /// ou CUPS no Linux (Orange Pi).
  static bool get _usesUsbPrinter => Platform.isWindows || Platform.isLinux;

  Future<void> _scanPaired() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final enabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!enabled) {
        setState(() => _error = 'Bluetooth desligado.');
        return;
      }
      final devices = await PrintBluetoothThermal.pairedBluetooths;
      if (mounted) setState(() => _devices = devices);
    } catch (e) {
      if (mounted) setState(() => _error = 'Falha ao buscar impressoras: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refreshUsbPrinters() async {
    final printers = Platform.isLinux
        ? await LinuxUsbPrinterService.listPrinters()
        : WindowsUsbPrinterService.listPrinters();
    if (mounted) setState(() => _usbPrinters = printers);
  }

  Future<void> _connectUsbPrinter(String name) async {
    setState(() {
      _connecting = true;
      _connectingEndereco = name;
      _error = null;
    });
    try {
      final printer = PrinterModel(
        nome: name,
        endereco: name,
        tipoConexao: PrinterTransportType.usb,
        protocolo: PrinterProtocolType.tspl,
        padrao: true,
        ultimaConexao: DateTime.now(),
      );
      final id = await ref.read(printerRepositoryProvider).save(printer);
      await ref.read(printerRepositoryProvider).updateLastConnection(id, DateTime.now());

      final labelRepository = ref.read(labelRepositoryProvider);
      final implementation = Platform.isLinux
          ? LinuxUsbPrinterService(labelRepository: labelRepository)
          : WindowsUsbPrinterService(labelRepository: labelRepository);
      await ref.read(printerServiceProvider).useImplementation(implementation, printer);

      await ref.read(auditRepositoryProvider).insert(AuditLogModel(
            dataHora: DateTime.now(),
            tipo: AuditEventType.impressoraConectada,
            descricao: name,
          ));
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na impressora USB configurada', e, st);
      if (mounted) setState(() => _error = 'Falha ao conectar: $e');
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  Future<void> _connect(BluetoothInfo device) async {
    setState(() {
      _connecting = true;
      _connectingEndereco = device.macAdress;
      _error = null;
    });
    try {
      final printer = PrinterModel(
        nome: device.name,
        endereco: device.macAdress,
        tipoConexao: PrinterTransportType.bluetoothClassic,
        protocolo: PrinterProtocolType.tspl,
        padrao: true,
        ultimaConexao: DateTime.now(),
      );
      final id = await ref.read(printerRepositoryProvider).save(printer);
      await ref.read(printerRepositoryProvider).updateLastConnection(id, DateTime.now());

      final implementation =
          BluetoothThermalPrinterService(labelRepository: ref.read(labelRepositoryProvider));
      await ref.read(printerServiceProvider).useImplementation(implementation, printer);

      await ref.read(auditRepositoryProvider).insert(AuditLogModel(
            dataHora: DateTime.now(),
            tipo: AuditEventType.impressoraConectada,
            descricao: '${device.name} (${device.macAdress})',
          ));
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na impressora configurada', e, st);
      if (mounted) setState(() => _error = 'Falha ao conectar: $e');
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  Future<void> _printTest() async {
    setState(() {
      _printingTest = true;
      _error = null;
    });
    try {
      final queue = ref.read(printQueueServiceProvider);
      await queue.enqueue(
        LabelPrintData(
          produto: 'TESTE DE IMPRESSÃO',
          codigo: '0',
          peso: 1.000,
          precoKg: 10.00,
          total: 10.00,
          codigoBarras: '1234567890128',
          dataHora: DateTime.now(),
        ),
        jobId: 'teste-${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      if (mounted) setState(() => _error = 'Falha ao imprimir teste: $e');
    } finally {
      if (mounted) setState(() => _printingTest = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(printerConnectionStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Impressora')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  status.when(
                    data: (s) => StatusIndicator(
                      label: switch (s) {
                        PrinterConnectionStatus.conectada => 'IMPRESSORA CONECTADA',
                        PrinterConnectionStatus.conectando => 'CONECTANDO...',
                        PrinterConnectionStatus.erro => 'ERRO',
                        PrinterConnectionStatus.desconectada => 'IMPRESSORA DESCONECTADA',
                      },
                      level: switch (s) {
                        PrinterConnectionStatus.conectada => StatusLevel.ok,
                        PrinterConnectionStatus.conectando => StatusLevel.warning,
                        PrinterConnectionStatus.erro => StatusLevel.error,
                        PrinterConnectionStatus.desconectada => StatusLevel.error,
                      },
                    ),
                    loading: () => const StatusIndicator(label: '...', level: StatusLevel.info),
                    error: (_, _) => const StatusIndicator(label: 'ERRO', level: StatusLevel.error),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  FilledButton.icon(
                    icon: _printingTest
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.print),
                    label: const Text('IMPRIMIR TESTE'),
                    onPressed: _printingTest ? null : _printTest,
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
          const SizedBox(height: AppDimensions.spaceLg),
          if (_usesUsbPrinter) ...[
            FilledButton.icon(
              icon: const Icon(Icons.print),
              label: const Text('BUSCAR IMPRESSORAS INSTALADAS'),
              onPressed: _refreshUsbPrinters,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            if (_usbPrinters.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceSm),
                child: Text(
                  Platform.isLinux
                      ? 'Nenhuma impressora encontrada. Conecte a impressora USB, '
                          'confira se /dev/usb/lp0 existe (sudo modprobe usblp) e busque novamente.'
                      : 'Nenhuma impressora encontrada. Instale a impressora no Windows '
                          '(driver do fabricante) e busque novamente.',
                ),
              )
            else
              for (final name in _usbPrinters)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.print),
                    title: Text(name),
                    trailing: FilledButton(
                      onPressed: _connecting ? null : () => _connectUsbPrinter(name),
                      child: _connecting && _connectingEndereco == name
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('CONECTAR'),
                    ),
                  ),
                ),
          ] else ...[
            FilledButton.icon(
              icon: _loading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.bluetooth_searching),
              label: const Text('BUSCAR IMPRESSORAS PAREADAS'),
              onPressed: _loading ? null : _scanPaired,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            for (final device in _devices)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.print),
                  title: Text(device.name),
                  subtitle: Text(device.macAdress),
                  trailing: FilledButton(
                    onPressed: _connecting ? null : () => _connect(device),
                    child: _connecting && _connectingEndereco == device.macAdress
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
