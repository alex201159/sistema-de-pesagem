import 'package:drift/drift.dart';

import '../../core/constants/app_constants.dart';
import '../../services/scale/scale_line_weight_parser.dart';
import '../../services/scale/serial_protocol.dart';
import '../database/app_database.dart';
import '../models/barcode_config_model.dart';
import '../models/weighing_model.dart';

/// Chaves conhecidas de configuração persistente (ver escopo, item 47).
///
/// Novas telas de configuração (balança, impressora, rede, código de
/// barras, etiquetas — Etapas 3 a 9) devem declarar suas chaves aqui em
/// vez de espalhar strings mágicas pelo código.
class SettingsKeys {
  SettingsKeys._();

  static const String selectedPrinterId = 'selected_printer_id';
  static const String selectedScaleId = 'selected_scale_id';
  static const String defaultLabelId = 'default_label_id';

  /// Servidor HTTP de importação (ver escopo, item 6) — recebe arquivos
  /// enviados pelo app companheiro Windows/Mac que vigia a pasta do ERP.
  static const String importServerEnabled = 'import_server_enabled';
  static const String importServerPort = 'import_server_port';

  static const String barcodePrefix = 'barcode_prefix';
  static const String barcodeProductDigits = 'barcode_product_digits';
  static const String barcodeValueType = 'barcode_value_type';

  static const String totemModeEnabled = 'totem_mode_enabled';
  static const String screenOrientation = 'screen_orientation';

  /// Modo de venda do totem (ver `SalesMode`): impressão de etiqueta
  /// ou comanda (sem impressão, com funcionário(s) vinculados) —
  /// configuração fixa por instalação, não escolhida a cada venda.
  static const String salesMode = 'sales_mode';

  /// Protocolo serial (baud/paridade/stop/data bits) usado pela
  /// balança, tanto no gateway BLE quanto no adaptador USB (ver
  /// escopo, item 10). Mantido em `app_settings` em vez de colunas na
  /// tabela `scales` porque, na prática, um totem opera com uma única
  /// balança configurada por vez.
  static const String scaleSerialBaud = 'scale_serial_baud';
  static const String scaleSerialParity = 'scale_serial_parity';
  static const String scaleSerialStopBits = 'scale_serial_stop_bits';
  static const String scaleSerialDataBits = 'scale_serial_data_bits';

  /// Recorte do peso dentro da linha crua recebida da balança
  /// (ver escopo, item 12).
  static const String scaleWeightExtractStart = 'scale_weight_extract_start';
  static const String scaleWeightExtractLength = 'scale_weight_extract_length';
  static const String scaleWeightImplicitDecimals =
      'scale_weight_implicit_decimals';
}

/// Persistência de configurações do aplicativo (tabela `app_settings`,
/// chave/valor) — ver escopo, item 47.
class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);

  Future<void> setString(String key, String? value) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: Value(value)),
        );
  }

  Future<String?> getString(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setInt(String key, int? value) =>
      setString(key, value?.toString());

  Future<int?> getInt(String key) async {
    final raw = await getString(key);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<void> setDouble(String key, double? value) =>
      setString(key, value?.toString());

  Future<double?> getDouble(String key) async {
    final raw = await getString(key);
    return raw == null ? null : double.tryParse(raw);
  }

  Future<void> setBool(String key, bool? value) =>
      setString(key, value == null ? null : (value ? '1' : '0'));

  Future<bool?> getBool(String key) async {
    final raw = await getString(key);
    if (raw == null) return null;
    return raw == '1' || raw.toLowerCase() == 'true';
  }

  Future<void> remove(String key) async {
    await (_db.delete(_db.appSettings)..where((t) => t.key.equals(key))).go();
  }

  /// Carrega a configuração de código de barras (ver escopo, itens
  /// 18-21), com os padrões definidos em [BarcodeConfigModel] quando
  /// nada foi configurado ainda.
  Future<BarcodeConfigModel> getBarcodeConfig() async {
    const defaults = BarcodeConfigModel();
    final prefix =
        await getString(SettingsKeys.barcodePrefix) ?? defaults.prefix;
    final productDigits =
        await getInt(SettingsKeys.barcodeProductDigits) ??
        defaults.productDigits;
    final valueTypeName =
        await getString(SettingsKeys.barcodeValueType) ??
        defaults.valueType.name;

    return BarcodeConfigModel(
      prefix: prefix,
      productDigits: productDigits,
      valueType: BarcodeValueType.fromName(valueTypeName),
    );
  }

  Future<void> setBarcodeConfig(BarcodeConfigModel config) async {
    await setString(SettingsKeys.barcodePrefix, config.prefix);
    await setInt(SettingsKeys.barcodeProductDigits, config.productDigits);
    await setString(SettingsKeys.barcodeValueType, config.valueType.name);
  }

  /// Carrega o protocolo serial configurado para a balança (ver
  /// escopo, item 10), com [SerialProtocol.defaultProtocol] quando
  /// nada foi configurado ainda.
  Future<SerialProtocol> getScaleSerialProtocol() async {
    const defaults = SerialProtocol.defaultProtocol;
    return SerialProtocol(
      baud: await getInt(SettingsKeys.scaleSerialBaud) ?? defaults.baud,
      parity:
          await getString(SettingsKeys.scaleSerialParity) ?? defaults.parity,
      stopBits:
          await getInt(SettingsKeys.scaleSerialStopBits) ?? defaults.stopBits,
      dataBits:
          await getInt(SettingsKeys.scaleSerialDataBits) ?? defaults.dataBits,
    );
  }

  Future<void> setScaleSerialProtocol(SerialProtocol protocol) async {
    await setInt(SettingsKeys.scaleSerialBaud, protocol.baud);
    await setString(SettingsKeys.scaleSerialParity, protocol.parity);
    await setInt(SettingsKeys.scaleSerialStopBits, protocol.stopBits);
    await setInt(SettingsKeys.scaleSerialDataBits, protocol.dataBits);
  }

  /// Carrega a configuração de extração do peso na linha crua da
  /// balança (ver escopo, item 12), com os defaults de
  /// [ScaleLineWeightParser] quando nada foi configurado ainda.
  Future<ScaleLineWeightParser> getScaleWeightParser() async {
    const defaults = ScaleLineWeightParser();
    return ScaleLineWeightParser(
      extractStart:
          await getInt(SettingsKeys.scaleWeightExtractStart) ??
          defaults.extractStart,
      extractLength:
          await getInt(SettingsKeys.scaleWeightExtractLength) ??
          defaults.extractLength,
      implicitDecimals:
          await getInt(SettingsKeys.scaleWeightImplicitDecimals) ??
          defaults.implicitDecimals,
    );
  }

  Future<void> setScaleWeightParser(ScaleLineWeightParser parser) async {
    await setInt(SettingsKeys.scaleWeightExtractStart, parser.extractStart);
    await setInt(SettingsKeys.scaleWeightExtractLength, parser.extractLength);
    await setInt(
      SettingsKeys.scaleWeightImplicitDecimals,
      parser.implicitDecimals,
    );
  }

  /// Carrega a porta do servidor HTTP de importação (ver escopo, item
  /// 6), com o default definido em [AppConstants] quando nada foi
  /// configurado ainda.
  Future<int> getImportServerPort() async {
    return await getInt(SettingsKeys.importServerPort) ??
        AppConstants.defaultImportServerPort;
  }

  Future<void> setImportServerPort(int port) =>
      setInt(SettingsKeys.importServerPort, port);

  /// Carrega o modo de venda configurado (ver `SalesMode`), com
  /// `SalesMode.etiqueta` como padrão quando nada foi configurado.
  Future<SalesMode> getSalesMode() async {
    final raw = await getString(SettingsKeys.salesMode);
    return raw == null ? SalesMode.etiqueta : SalesMode.fromName(raw);
  }

  Future<void> setSalesMode(SalesMode mode) => setString(SettingsKeys.salesMode, mode.name);
}
