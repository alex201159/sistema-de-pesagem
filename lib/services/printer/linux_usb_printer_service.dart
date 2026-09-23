import 'dart:async';
import 'dart:io';

import '../../core/errors/printer_exception.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/label_model.dart';
import '../../data/models/printer_model.dart';
import '../../data/repositories/label_repository.dart';
import 'drivers/printer_driver.dart';
import 'drivers/tspl_driver.dart';
import 'printer_service.dart';

/// Impressora térmica de etiquetas USB no Linux (Orange Pi/Armbian) —
/// equivalente de [WindowsUsbPrinterService]. Os bytes TSPL prontos do
/// [PrinterDriver] são enviados crus por um de dois caminhos, conforme
/// o endereço salvo:
///
/// - `/dev/usb/lpN`: direto no dispositivo do módulo `usblp` do kernel,
///   sem nenhum software extra — o caminho padrão no totem.
/// - nome de uma fila CUPS: via `lp -o raw`, para quem já tem a
///   impressora instalada no CUPS.
///
/// A escrita roda num processo separado (`dd`/`lp`) com tempo limite:
/// impressora desligada ou sem papel pode travar a escrita no
/// dispositivo, e isso nunca deve prender uma thread do app.
class LinuxUsbPrinterService implements PrinterService {
  LinuxUsbPrinterService({
    required LabelRepository labelRepository,
    PrinterDriver driver = const TsplDriver(),
  })  : _labelRepository = labelRepository,
        _driver = driver;

  static const _writeTimeout = Duration(seconds: 15);

  final LabelRepository _labelRepository;
  final PrinterDriver _driver;

  final _statusController = StreamController<PrinterConnectionStatus>.broadcast();
  PrinterConnectionStatus _status = PrinterConnectionStatus.desconectada;
  String? _address;

  @override
  Stream<PrinterConnectionStatus> get connectionStatusStream => _statusController.stream;

  @override
  PrinterConnectionStatus get currentStatus => _status;

  static bool _isDevicePath(String address) => address.startsWith('/dev/');

  /// Dispositivos `/dev/usb/lp*` presentes e filas CUPS instaladas (se
  /// o CUPS existir) — usado pela tela de configuração.
  static Future<List<String>> listPrinters() async {
    final printers = <String>[];
    try {
      final usbDir = Directory('/dev/usb');
      if (await usbDir.exists()) {
        final devices = await usbDir
            .list(followLinks: false)
            .map((e) => e.path)
            .where((path) => RegExp(r'/lp\d+$').hasMatch(path))
            .toList();
        devices.sort();
        printers.addAll(devices);
      }
    } catch (e, st) {
      AppLogger.e('Falha ao listar /dev/usb/lp*', e, st);
    }
    printers.addAll(await _listCupsQueues());
    return printers;
  }

  static Future<List<String>> _listCupsQueues() async {
    try {
      final result = await Process.run('lpstat', ['-e']).timeout(const Duration(seconds: 5));
      if (result.exitCode != 0) return const [];
      return result.stdout
          .toString()
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
    } catch (_) {
      // CUPS não instalado — só os dispositivos /dev/usb/lp* valem.
      return const [];
    }
  }

  @override
  Future<void> connect(PrinterModel printer) async {
    _setStatus(PrinterConnectionStatus.conectando);
    try {
      final address = printer.endereco;
      if (_isDevicePath(address)) {
        if (!await File(address).exists()) {
          throw PrinterConnectionException(
            'Impressora "$address" não encontrada — verifique o cabo USB e se o '
            'módulo usblp está carregado (sudo modprobe usblp).',
          );
        }
      } else if (!(await _listCupsQueues()).contains(address)) {
        throw PrinterConnectionException('Fila de impressão "$address" não encontrada no CUPS.');
      }

      _address = address;
      _setStatus(PrinterConnectionStatus.conectada);
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na impressora USB (Linux)', e, st);
      _setStatus(PrinterConnectionStatus.erro);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    _address = null;
    _setStatus(PrinterConnectionStatus.desconectada);
  }

  @override
  Future<void> printLabel(LabelPrintData data) async {
    final address = _address;
    if (address == null) {
      throw const PrinterNotConfiguredException();
    }

    final label = await _labelRepository.getDefault() ?? LabelModel.builtInDefault();
    final bytes = _driver.render(label, data);

    try {
      await _sendRawBytes(address, bytes);
      _setStatus(PrinterConnectionStatus.conectada);
    } on PrinterException {
      _setStatus(PrinterConnectionStatus.erro);
      rethrow;
    } catch (e, st) {
      AppLogger.e('Falha ao enviar etiqueta para a impressora USB (Linux)', e, st);
      _setStatus(PrinterConnectionStatus.erro);
      throw const PrinterConnectionException('Falha ao enviar a etiqueta para a impressora.');
    }
  }

  Future<void> _sendRawBytes(String address, List<int> bytes) async {
    final process = _isDevicePath(address)
        ? await Process.start('dd', ['of=$address', 'conv=notrunc', 'status=none'])
        : await Process.start('lp', ['-d', address, '-o', 'raw', '-t', 'Etiqueta de pesagem']);

    final stderr = StringBuffer();
    final stderrDone = process.stderr
        .transform(const SystemEncoding().decoder)
        .forEach(stderr.write);
    unawaited(process.stdout.drain<void>());

    process.stdin.add(bytes);
    await process.stdin.close();

    final exitCode = await process.exitCode.timeout(_writeTimeout, onTimeout: () {
      process.kill(ProcessSignal.sigkill);
      throw const PrinterConnectionException(
        'A impressora não respondeu — verifique se está ligada e com etiquetas.',
      );
    });
    await stderrDone;

    if (exitCode != 0) {
      final detail = stderr.toString().trim();
      if (detail.contains('Permission denied')) {
        throw PrinterConnectionException(
          'Sem permissão para usar "$address". Adicione o usuário ao grupo "lp" '
          '(sudo usermod -aG lp \$USER) e reinicie a sessão.',
        );
      }
      throw PrinterConnectionException('Falha ao enviar os dados para a impressora: $detail');
    }
  }

  void _setStatus(PrinterConnectionStatus status) {
    _status = status;
    if (!_statusController.isClosed) _statusController.add(status);
  }

  @override
  void dispose() => _statusController.close();
}
