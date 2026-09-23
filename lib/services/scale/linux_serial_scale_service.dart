import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../core/errors/scale_exception.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/scale_model.dart';
import 'scale_line_weight_parser.dart';
import 'scale_service.dart';
import 'serial_protocol.dart';

/// Balança comum conectada a uma porta serial do Linux (`/dev/ttyUSB0`,
/// `/dev/ttyACM0`, UART nativa `/dev/ttyS*` — ver adaptação para rodar
/// no Orange Pi com Armbian).
///
/// Equivalente Linux de [WindowsSerialScaleService]: a porta é
/// configurada com `stty` e lida por um processo `cat` separado, em vez
/// de ler o dispositivo direto na isolate do Flutter. Assim um driver
/// USB-serial travado (CH340/PL2303 instáveis) prende só aquele
/// processo — que é simplesmente morto no [disconnect] — e nunca uma
/// thread do app. `stty` e `cat` fazem parte do coreutils, presente em
/// qualquer instalação do Armbian.
///
/// O recorte em linhas replica `windows/runner/serial_port_channel.cpp`:
/// corta em `\r`/`\n` e, se a balança parar de transmitir por
/// [_idleFlush] com dados no buffer, entrega o quadro assim mesmo
/// (balanças que mandam quadros fixos sem CR/LF).
class LinuxSerialScaleService implements ScaleService {
  LinuxSerialScaleService({
    SerialProtocol protocol = SerialProtocol.defaultProtocol,
    ScaleLineWeightParser weightParser = const ScaleLineWeightParser(),
  })  : _protocol = protocol,
        _weightParser = weightParser;

  static const _idleFlush = Duration(milliseconds: 500);
  static const _overflowThreshold = 512;

  final SerialProtocol _protocol;
  ScaleLineWeightParser _weightParser;

  final _weightController = StreamController<ScaleReading>.broadcast();
  final _statusController = StreamController<ScaleConnectionStatus>.broadcast();
  final _rawLineController = StreamController<String>.broadcast();
  ScaleConnectionStatus _status = ScaleConnectionStatus.semBalanca;

  Process? _reader;
  StreamSubscription<List<int>>? _stdoutSub;
  Timer? _idleTimer;
  final _buffer = StringBuffer();

  @override
  Stream<ScaleReading> get weightStream => _weightController.stream;

  @override
  Stream<ScaleConnectionStatus> get connectionStatusStream => _statusController.stream;

  @override
  Stream<String> get rawLineStream => _rawLineController.stream;

  @override
  ScaleConnectionStatus get currentStatus => _status;

  void updateWeightParser(ScaleLineWeightParser parser) => _weightParser = parser;

  /// Portas seriais disponíveis. Os links de `/dev/serial/by-id` vêm
  /// primeiro: continuam apontando para o mesmo adaptador mesmo que ele
  /// troque de `ttyUSB0` para `ttyUSB1` ao ser reconectado, então são o
  /// endereço mais estável para salvar como balança padrão.
  static Future<List<String>> listPorts() async {
    final ports = <String>[];
    final covered = <String>{};

    try {
      final byId = Directory('/dev/serial/by-id');
      if (await byId.exists()) {
        await for (final entry in byId.list(followLinks: false)) {
          ports.add(entry.path);
          try {
            covered.add(await File(entry.path).resolveSymbolicLinks());
          } catch (_) {}
        }
      }

      final devices = <String>[];
      await for (final entry in Directory('/dev').list(followLinks: false)) {
        final name = entry.path.substring('/dev/'.length);
        if (RegExp(r'^tty(USB|ACM|S|AMA)\d+$').hasMatch(name) && !covered.contains(entry.path)) {
          devices.add(entry.path);
        }
      }
      devices.sort(_compareDevicePaths);
      ports.addAll(devices);
    } catch (e, st) {
      AppLogger.e('Falha ao listar portas seriais (Linux)', e, st);
    }
    return ports;
  }

  /// USB/ACM antes das UARTs nativas (`ttyS*` quase sempre é console
  /// ou pino não usado na placa) e `ttyUSB2` antes de `ttyUSB10`.
  static int _compareDevicePaths(String a, String b) {
    int rank(String p) => p.contains('ttyUSB') || p.contains('ttyACM') ? 0 : 1;
    final byRank = rank(a).compareTo(rank(b));
    if (byRank != 0) return byRank;
    final prefixA = a.replaceAll(RegExp(r'\d+$'), '');
    final prefixB = b.replaceAll(RegExp(r'\d+$'), '');
    if (prefixA != prefixB) return prefixA.compareTo(prefixB);
    int number(String p) => int.tryParse(RegExp(r'\d+$').stringMatch(p) ?? '') ?? 0;
    return number(a).compareTo(number(b));
  }

  List<String> _sttyArgs(String port) {
    return [
      '-F',
      port,
      '${_protocol.baud}',
      'raw',
      '-echo',
      '-echoe',
      '-echok',
      '-echoctl',
      '-echoke',
      '-ixon',
      '-ixoff',
      '-crtscts',
      'clocal',
      'cread',
      _protocol.dataBits == 7 ? 'cs7' : 'cs8',
      _protocol.stopBits == 2 ? 'cstopb' : '-cstopb',
      ...switch (_protocol.parity) {
        'E' => ['parenb', '-parodd'],
        'O' => ['parenb', 'parodd'],
        _ => ['-parenb'],
      },
      'min',
      '1',
      'time',
      '0',
    ];
  }

  @override
  Future<void> connect(ScaleModel scale) async {
    _setStatus(ScaleConnectionStatus.conectando);
    await _stopReader();

    final port = scale.endereco;
    try {
      final stty = await Process.run('stty', _sttyArgs(port))
          .timeout(const Duration(seconds: 5));
      if (stty.exitCode != 0) {
        throw ScaleException(_describeError(port, stty.stderr.toString()));
      }

      final reader = await Process.start('cat', [port]);
      _reader = reader;
      _stdoutSub = reader.stdout.listen(_onBytes);
      reader.stderr.transform(const SystemEncoding().decoder).listen((message) {
        if (message.trim().isNotEmpty) {
          AppLogger.e('Erro na porta serial da balança: ${message.trim()}');
        }
      });
      unawaited(reader.exitCode.then((code) {
        if (!identical(_reader, reader)) return;
        _reader = null;
        if (code != 0) {
          _setStatus(ScaleConnectionStatus.erro);
        } else if (_status != ScaleConnectionStatus.erro) {
          _setStatus(ScaleConnectionStatus.semBalanca);
        }
      }));

      // Mesma folga do WindowsSerialScaleService: uma falha imediata
      // (porta sumiu, sem permissão) encerra o `cat` quase na hora e
      // vira erro visível aqui, não depois que o operador saiu da tela.
      final exitedEarly = await reader.exitCode
          .then<int?>((code) => code)
          .timeout(const Duration(milliseconds: 400), onTimeout: () => null);
      if (exitedEarly != null) {
        throw ScaleException('Falha ao abrir a porta $port (código $exitedEarly).');
      }

      _setStatus(ScaleConnectionStatus.conectada);
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na porta serial $port', e, st);
      await _stopReader();
      _setStatus(ScaleConnectionStatus.erro);
      if (e is ScaleException) rethrow;
      throw ScaleException('Falha ao conectar na porta $port: $e');
    }
  }

  String _describeError(String port, String stderr) {
    final detail = stderr.trim();
    if (detail.contains('Permission denied')) {
      return 'Sem permissão para abrir $port. Adicione o usuário ao grupo '
          '"dialout" (sudo usermod -aG dialout \$USER) e reinicie a sessão.';
    }
    if (detail.contains('No such file')) {
      return 'Porta $port não encontrada — verifique o cabo/adaptador.';
    }
    return 'Falha ao configurar a porta $port: $detail';
  }

  void _onBytes(List<int> bytes) {
    // Latin-1: cada byte cru vira um caractere, sem perder bytes de
    // controle/status que não são UTF-8 válido (igual ao lado Windows).
    _buffer.write(latin1.decode(bytes, allowInvalid: true));
    _flushDelimited();

    _idleTimer?.cancel();
    if (_buffer.isNotEmpty) {
      _idleTimer = Timer(_idleFlush, _flushFrame);
    }
  }

  void _flushDelimited() {
    var data = _buffer.toString();
    while (data.isNotEmpty) {
      final index = data.indexOf(RegExp(r'[\r\n]'));
      if (index < 0) {
        if (data.length >= _overflowThreshold) {
          _emitLine('[sem terminador encontrado] $data');
          data = '';
        }
        break;
      }
      var consumed = index + 1;
      if (data[index] == '\r' && consumed < data.length && data[consumed] == '\n') {
        consumed++;
      }
      _emitLine(data.substring(0, index));
      data = data.substring(consumed);
    }
    _buffer
      ..clear()
      ..write(data);
  }

  void _flushFrame() {
    if (_buffer.isEmpty) return;
    final frame = _buffer.toString();
    _buffer.clear();
    _emitLine(frame);
  }

  void _emitLine(String line) {
    if (line.isEmpty || _rawLineController.isClosed) return;
    _rawLineController.add(line);
    final kg = _weightParser.extract(line);
    if (kg != null) {
      _weightController.add(ScaleReading(kg: kg, timestamp: DateTime.now()));
    }
  }

  Future<void> _stopReader() async {
    _idleTimer?.cancel();
    _idleTimer = null;
    await _stdoutSub?.cancel();
    _stdoutSub = null;
    final reader = _reader;
    _reader = null;
    reader?.kill();
    _buffer.clear();
  }

  @override
  Future<void> disconnect() async {
    await _stopReader();
    _setStatus(ScaleConnectionStatus.semBalanca);
  }

  void _setStatus(ScaleConnectionStatus status) {
    _status = status;
    if (!_statusController.isClosed) _statusController.add(status);
  }

  @override
  void dispose() {
    _stopReader();
    _weightController.close();
    _statusController.close();
    _rawLineController.close();
  }
}
