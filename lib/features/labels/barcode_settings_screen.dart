import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/barcode_config_model.dart';
import '../../services/barcode/barcode_service.dart';
import 'barcode_settings_controller.dart';

/// Configuração do formato do código de barras montado pelo app
/// (ver escopo, itens 18-21): quantidade de dígitos do código/PLU e o
/// que o campo de valor representa.
class BarcodeSettingsScreen extends ConsumerWidget {
  const BarcodeSettingsScreen({super.key});

  // Valores de exemplo para a pré-visualização em tempo real.
  static const _sampleProductCode = '125';
  static const _samplePricePerKg = 42.90;
  static const _sampleWeightKg = 0.485;
  static const _sampleTotal = 20.81;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(barcodeConfigProvider);
    final controller = ref.read(barcodeConfigProvider.notifier);

    final barcode = BarcodeService().build(
      config,
      const BarcodeInput(
        productCode: _sampleProductCode,
        pricePerKg: _samplePricePerKg,
        total: _sampleTotal,
        weightKg: _sampleWeightKg,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Configuração do Código de Barras')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        children: [
          Text('CÓDIGO DO PRODUTO', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppDimensions.spaceSm),
          Card(
            child: RadioGroup<int>(
              groupValue: config.productDigits,
              onChanged: (value) => controller.updateProductDigits(value!),
              child: Column(
                children: [4, 5, 6].map((digits) {
                  final example = _sampleProductCode.padLeft(digits, '0');
                  return RadioListTile<int>(
                    value: digits,
                    title: Text('$digits dígitos'),
                    subtitle: Text('Exemplo: $example'),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text('TIPO DE VALOR', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppDimensions.spaceSm),
          Card(
            child: RadioGroup<BarcodeValueType>(
              groupValue: config.valueType,
              onChanged: (value) => controller.updateValueType(value!),
              child: Column(
                children: BarcodeValueType.values.map((type) {
                  return RadioListTile<BarcodeValueType>(
                    value: type,
                    title: Text(type.label),
                    subtitle: Text(_descriptionFor(type)),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text('PRÉ-VISUALIZAÇÃO', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppDimensions.spaceSm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceLg),
              child: Column(
                children: [
                  Text(
                    'Produto $_sampleProductCode · Peso ${_sampleWeightKg}kg · '
                    'R\$/kg $_samplePricePerKg · Total R\$ $_sampleTotal',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  BarcodeWidget(
                    barcode: Barcode.ean13(),
                    data: barcode,
                    width: 260,
                    height: 90,
                    drawText: false,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: AppDimensions.spaceSm),
                  Text(
                    barcode,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(letterSpacing: 2, fontFeatures: const [FontFeature.tabularFigures()]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _descriptionFor(BarcodeValueType type) => switch (type) {
        BarcodeValueType.preco => 'Grava o preço por kg no código de barras.',
        BarcodeValueType.precoTotal => 'Grava o valor total da pesagem no código de barras.',
        BarcodeValueType.peso => 'Grava o peso (em gramas) no código de barras.',
        BarcodeValueType.importado =>
          'Usa o código de barras do arquivo do ERP, quando existir; monta um automaticamente quando não houver.',
      };
}
