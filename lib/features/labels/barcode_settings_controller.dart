import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/barcode_config_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/repositories/settings_repository.dart';

/// Mantém a configuração de código de barras em memória (para
/// pré-visualização instantânea — ver escopo, item 21) e a persiste a
/// cada alteração via [SettingsRepository].
class BarcodeSettingsController extends StateNotifier<BarcodeConfigModel> {
  final SettingsRepository _settingsRepository;

  BarcodeSettingsController(this._settingsRepository) : super(const BarcodeConfigModel()) {
    _load();
  }

  Future<void> _load() async {
    state = await _settingsRepository.getBarcodeConfig();
  }

  Future<void> updateProductDigits(int digits) async {
    state = state.copyWith(productDigits: digits);
    await _settingsRepository.setBarcodeConfig(state);
  }

  Future<void> updateValueType(BarcodeValueType type) async {
    state = state.copyWith(valueType: type);
    await _settingsRepository.setBarcodeConfig(state);
  }
}

/// Configuração de código de barras compartilhada por toda a
/// aplicação (tela de configurações e montagem da etiqueta na venda).
final barcodeConfigProvider =
    StateNotifierProvider<BarcodeSettingsController, BarcodeConfigModel>((ref) {
  return BarcodeSettingsController(ref.watch(settingsRepositoryProvider));
});
