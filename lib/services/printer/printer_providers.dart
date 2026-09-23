import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_logger.dart';
import '../../data/models/printer_model.dart';
import '../../data/repositories/repository_providers.dart';
import 'bluetooth_thermal_printer_service.dart';
import 'linux_usb_printer_service.dart';
import 'mock_printer_service.dart';
import 'print_queue_service.dart';
import 'printer_service_manager.dart';
import 'windows_usb_printer_service.dart';

/// Instância única do serviço de impressora ativo, encapsulada em um
/// [PrinterServiceManager] para permitir trocar o transporte em tempo
/// de execução (ver escopo, item 27).
///
/// Começa com [MockPrinterService] (ver escopo, item 53) e, sem
/// bloquear a UI (item 45), busca a impressora marcada como padrão em
/// `PrinterRepository`; se houver uma configurada, troca para a
/// implementação Bluetooth real automaticamente (ver escopo, item 31).
final printerServiceProvider = Provider<PrinterServiceManager>((ref) {
  final manager = PrinterServiceManager(MockPrinterService());
  ref.onDispose(manager.dispose);

  manager.connect(const PrinterModel(
    nome: 'Impressora Simulada',
    endereco: 'mock://printer',
    tipoConexao: PrinterTransportType.bluetoothClassic,
    protocolo: PrinterProtocolType.escPos,
  ));

  final printerRepository = ref.watch(printerRepositoryProvider);
  final labelRepository = ref.watch(labelRepositoryProvider);
  () async {
    try {
      final defaultPrinter = await printerRepository.getDefault();
      if (defaultPrinter == null) return;

      final implementation = switch (defaultPrinter.tipoConexao) {
        PrinterTransportType.bluetoothClassic =>
          BluetoothThermalPrinterService(labelRepository: labelRepository),
        PrinterTransportType.usb when Platform.isWindows =>
          WindowsUsbPrinterService(labelRepository: labelRepository),
        PrinterTransportType.usb when Platform.isLinux =>
          LinuxUsbPrinterService(labelRepository: labelRepository),
        PrinterTransportType.ble || PrinterTransportType.usb || PrinterTransportType.tcp => null,
      };

      if (implementation == null) {
        AppLogger.w(
          'Transporte de impressora "${defaultPrinter.tipoConexao.label}" ainda não '
          'implementado — mantendo impressora simulada.',
        );
        return;
      }

      await manager.useImplementation(implementation, defaultPrinter);
    } catch (e, st) {
      AppLogger.e('Falha ao inicializar a impressora configurada como padrão', e, st);
    }
  }();

  return manager;
});

final printerConnectionStatusProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(printerServiceProvider).connectionStatusStream;
});

/// Fila de impressão (ver escopo, item 32) sobre o serviço de
/// impressora ativo — `WeighingController`/reimpressão do histórico
/// nunca chamam `PrinterService.printLabel` diretamente.
final printQueueServiceProvider = Provider<PrintQueueService>((ref) {
  final queue = PrintQueueService(ref.watch(printerServiceProvider));
  ref.onDispose(queue.dispose);
  return queue;
});
