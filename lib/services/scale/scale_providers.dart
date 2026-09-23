import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_logger.dart';
import '../../data/models/scale_model.dart';
import '../../data/repositories/repository_providers.dart';
import 'ble_gateway_scale_service.dart';
import 'null_scale_service.dart';
import 'scale_service.dart';
import 'scale_service_manager.dart';
import 'serial_port_scale_service.dart';
import 'usb_serial_scale_service.dart';

/// Instância única do serviço de balança ativo, encapsulada em um
/// [ScaleServiceManager] para permitir trocar o transporte em tempo de
/// execução (ver escopo, item 10).
///
/// Começa com [NullScaleService] (estado "SEM BALANÇA", sem simular
/// hardware) e, sem bloquear a UI (item 45), busca a balança marcada
/// como padrão em `ScaleRepository`; se houver uma configurada (BLE ou
/// USB serial), troca para ela automaticamente.
final scaleServiceProvider = Provider<ScaleServiceManager>((ref) {
  final manager = ScaleServiceManager(NullScaleService());
  ref.onDispose(manager.dispose);

  final scaleRepository = ref.watch(scaleRepositoryProvider);
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  () async {
    try {
      final defaultScale = await scaleRepository.getDefault();
      if (defaultScale == null) return;

      final protocol = await settingsRepository.getScaleSerialProtocol();
      final weightParser = await settingsRepository.getScaleWeightParser();

      final ScaleService? implementation = switch (defaultScale.tipoConexao) {
        ScaleTransportType.ble =>
          BleGatewayScaleService(protocol: protocol, weightParser: weightParser),
        ScaleTransportType.usbSerial =>
          UsbSerialScaleService(protocol: protocol, weightParser: weightParser),
        ScaleTransportType.serialPort =>
          SerialPortScaleService.create(protocol: protocol, weightParser: weightParser),
        ScaleTransportType.bluetoothClassic || ScaleTransportType.tcp => null,
      };

      if (implementation == null) {
        AppLogger.w(
          'Transporte de balança "${defaultScale.tipoConexao.label}" ainda não '
          'implementado — mantendo estado SEM BALANÇA.',
        );
        return;
      }

      await manager.useImplementation(implementation, defaultScale);
    } catch (e, st) {
      AppLogger.e('Falha ao inicializar a balança configurada como padrão', e, st);
    }
  }();

  return manager;
});

final scaleWeightStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(scaleServiceProvider).weightStream;
});

final scaleConnectionStatusProvider = StreamProvider.autoDispose((ref) {
  final service = ref.watch(scaleServiceProvider);
  return service.connectionStatusStream;
});

final scaleRawLineStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(scaleServiceProvider).rawLineStream;
});
