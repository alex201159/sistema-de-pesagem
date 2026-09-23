import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/core/utils/barcode_utils.dart';
import 'package:pesagem_totem/data/models/barcode_config_model.dart';
import 'package:pesagem_totem/services/barcode/barcode_service.dart';

void main() {
  final service = BarcodeService();

  const input = BarcodeInput(
    productCode: '125',
    pricePerKg: 42.90,
    total: 20.81,
    weightKg: 0.485,
  );

  group('BarcodeService.build (padrão: prefixo 21, 5 dígitos, preço total)', () {
    const config = BarcodeConfigModel();

    test('gera um EAN-13 válido de 13 dígitos', () {
      final barcode = service.build(config, input);
      expect(barcode.length, 13);
      expect(BarcodeUtils.isValidEan13(barcode), isTrue);
    });

    test('monta prefixo + código (5) + total em centavos (5) + DV', () {
      final barcode = service.build(config, input);
      // "21" + "00125" (código) + "02081" (total em centavos) + DV
      expect(barcode.substring(0, 2), '21');
      expect(barcode.substring(2, 7), '00125');
      expect(barcode.substring(7, 12), '02081');
    });
  });

  group('BarcodeService.build com quantidade de dígitos configurável', () {
    test('4 dígitos de código reserva 6 dígitos para o valor', () {
      const config = BarcodeConfigModel(productDigits: 4);
      final barcode = service.build(config, input);

      expect(barcode.length, 13);
      expect(barcode.substring(2, 6), '0125');
      expect(barcode.substring(6, 12), '002081');
    });

    test('6 dígitos de código reserva 4 dígitos para o valor', () {
      const config = BarcodeConfigModel(productDigits: 6);
      final barcode = service.build(config, input);

      expect(barcode.length, 13);
      expect(barcode.substring(2, 8), '000125');
      expect(barcode.substring(8, 12), '2081');
    });
  });

  group('BarcodeService.build com tipo de valor configurável', () {
    test('BarcodeValueType.preco usa o preço por kg em centavos', () {
      const config = BarcodeConfigModel(valueType: BarcodeValueType.preco);
      final barcode = service.build(config, input);
      expect(barcode.substring(7, 12), '04290');
    });

    test('BarcodeValueType.peso usa o peso em gramas', () {
      const config = BarcodeConfigModel(valueType: BarcodeValueType.peso);
      final barcode = service.build(config, input);
      expect(barcode.substring(7, 12), '00485');
    });

    test('BarcodeValueType.peso usa o total (não o peso) quando o produto é por unidade', () {
      const config = BarcodeConfigModel(valueType: BarcodeValueType.peso);
      const inputPorUnidade = BarcodeInput(
        productCode: '125',
        pricePerKg: 15.99,
        total: 47.97,
        weightKg: 3, // quantidade digitada, não peso — ver BarcodeInput.porUnidade
        porUnidade: true,
      );
      final barcode = service.build(config, inputPorUnidade);
      // Sem o fallback, sairia "00300" (3 un × 1000, como se fosse peso
      // em gramas) em vez do total em centavos.
      expect(barcode.substring(7, 12), '04797');
    });

    test('BarcodeValueType.importado usa o código do arquivo quando existir', () {
      const config = BarcodeConfigModel(valueType: BarcodeValueType.importado);
      const inputComImportado = BarcodeInput(
        productCode: '125',
        pricePerKg: 42.90,
        total: 20.81,
        weightKg: 0.485,
        importedBarcode: '2125000485208',
      );
      expect(service.build(config, inputComImportado), '2125000485208');
    });

    test('BarcodeValueType.importado monta um código como reserva quando não há importado', () {
      const config = BarcodeConfigModel(valueType: BarcodeValueType.importado);
      final barcode = service.build(config, input);

      expect(barcode.length, 13);
      expect(BarcodeUtils.isValidEan13(barcode), isTrue);
    });
  });

  test('trunca valores que excedem o tamanho do campo, mantendo os dígitos menos significativos', () {
    const config = BarcodeConfigModel();
    const bigTotalInput = BarcodeInput(
      productCode: '1234567',
      pricePerKg: 1,
      total: 12345.67,
      weightKg: 1,
    );
    final barcode = service.build(config, bigTotalInput);

    expect(barcode.substring(2, 7), '34567'); // código truncado
    expect(barcode.substring(7, 12), '34567'); // total em centavos truncado
  });
}
