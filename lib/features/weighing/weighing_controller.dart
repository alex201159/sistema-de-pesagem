import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/weight_utils.dart';
import '../../data/models/audit_log_model.dart';
import '../../data/models/employee_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/weighing_model.dart';
import '../../data/repositories/employee_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/weighing_repository.dart';
import '../../services/barcode/barcode_service.dart';
import '../../services/printer/print_queue_service.dart';
import '../../services/printer/printer_providers.dart';
import '../../services/printer/printer_service.dart';
import '../../services/scale/scale_providers.dart';
import '../../services/scale/scale_service.dart';
import '../../services/scale/weight_stability_service.dart';
import '../labels/barcode_settings_controller.dart';

/// Estado de exibição da balança na tela principal
/// (ver escopo, item 11): SEM BALANÇA, CONECTANDO, CONECTADA,
/// PESO INSTÁVEL, PESO ESTÁVEL, ERRO.
enum ScaleDisplayStatus { semBalanca, conectando, conectada, instavel, estavel, erro }

class WeighingState {
  final String codeInput;
  final List<ProductModel> searchResults;
  final ProductModel? selectedProduct;
  final double weightKg;
  final ScaleDisplayStatus scaleStatus;

  /// Dígitos digitados no teclado numérico quando o produto
  /// selecionado é vendido por unidade (em vez de aguardar peso da
  /// balança) — mesmo padrão de [codeInput], mas para a quantidade.
  final String quantidadeInput;

  final bool isPrinting;
  final String? lastError;
  final WeighingModel? lastPrinted;

  /// Modo de venda configurado para o totem (ver `SettingsRepository`):
  /// `etiqueta` segue o fluxo normal de impressão; `comanda` pede
  /// número da comanda e funcionário(s) em vez de imprimir.
  final SalesMode salesMode;

  /// Número da comanda digitado (só usado quando [salesMode] é
  /// `comanda`).
  final String comandaNumero;

  /// Funcionários ativos disponíveis para vincular à venda por
  /// comanda — carregado uma vez ao abrir a tela.
  final List<EmployeeModel> employees;

  /// Funcionário(s) selecionado(s) para a venda por comanda em
  /// andamento — pode ter mais de um (ver escopo: "vai ter horas que
  /// vai ter mais de um funcionário por comanda").
  final Set<int> selectedEmployeeIds;

  const WeighingState({
    this.codeInput = '',
    this.searchResults = const [],
    this.selectedProduct,
    this.weightKg = 0,
    this.scaleStatus = ScaleDisplayStatus.semBalanca,
    this.quantidadeInput = '',
    this.isPrinting = false,
    this.lastError,
    this.lastPrinted,
    this.salesMode = SalesMode.etiqueta,
    this.comandaNumero = '',
    this.employees = const [],
    this.selectedEmployeeIds = const {},
  });

  /// `true` quando o totem está configurado para vendas por comanda
  /// (sem impressão) em vez do fluxo padrão de etiqueta.
  bool get precisaComanda => salesMode == SalesMode.comanda;

  /// `true` quando o produto selecionado é vendido por unidade (ex.:
  /// um bolo inteiro) em vez de por peso/kg — nesse caso a tela pede
  /// quantidade pelo teclado em vez de aguardar a balança.
  bool get porUnidade => selectedProduct?.unidade == AppConstants.defaultUnitUnit;

  double get quantidade => double.tryParse(quantidadeInput.replaceAll(',', '.')) ?? 0;

  /// Valor usado para calcular o total e para registrar/imprimir a
  /// operação: quantidade digitada quando por unidade, peso da
  /// balança nos demais casos.
  double get valorOperacao => porUnidade ? quantidade : weightKg;

  double get total => selectedProduct == null
      ? 0
      : CurrencyUtils.calculateTotal(weightKg: valorOperacao, pricePerKg: selectedProduct!.preco);

  /// Peso/quantidade prontos para fechar a venda, independentemente do
  /// modo (impressão ou comanda) — compartilhado por [canPrint] e
  /// [canRegisterComanda].
  bool get _valorPronto =>
      porUnidade ? quantidade > 0 : (weightKg > 0 && scaleStatus == ScaleDisplayStatus.estavel);

  bool get canPrint => selectedProduct != null && !isPrinting && _valorPronto;

  /// Equivalente a [canPrint] para o modo comanda: além do
  /// peso/quantidade prontos, exige número da comanda preenchido e
  /// pelo menos um funcionário selecionado.
  bool get canRegisterComanda =>
      selectedProduct != null &&
      !isPrinting &&
      _valorPronto &&
      comandaNumero.trim().isNotEmpty &&
      selectedEmployeeIds.isNotEmpty;

  WeighingState copyWith({
    String? codeInput,
    List<ProductModel>? searchResults,
    ProductModel? selectedProduct,
    bool clearSelectedProduct = false,
    double? weightKg,
    ScaleDisplayStatus? scaleStatus,
    String? quantidadeInput,
    bool? isPrinting,
    String? lastError,
    bool clearLastError = false,
    WeighingModel? lastPrinted,
    SalesMode? salesMode,
    String? comandaNumero,
    List<EmployeeModel>? employees,
    Set<int>? selectedEmployeeIds,
  }) {
    return WeighingState(
      codeInput: codeInput ?? this.codeInput,
      searchResults: searchResults ?? this.searchResults,
      selectedProduct: clearSelectedProduct ? null : (selectedProduct ?? this.selectedProduct),
      weightKg: weightKg ?? this.weightKg,
      scaleStatus: scaleStatus ?? this.scaleStatus,
      quantidadeInput: quantidadeInput ?? this.quantidadeInput,
      isPrinting: isPrinting ?? this.isPrinting,
      lastError: clearLastError ? null : (lastError ?? this.lastError),
      lastPrinted: lastPrinted ?? this.lastPrinted,
      salesMode: salesMode ?? this.salesMode,
      comandaNumero: comandaNumero ?? this.comandaNumero,
      employees: employees ?? this.employees,
      selectedEmployeeIds: selectedEmployeeIds ?? this.selectedEmployeeIds,
    );
  }
}

/// Controla a tela principal de pesagem/venda: recebe peso da balança
/// continuamente, avalia estabilidade, permite selecionar o produto e
/// confirma a impressão da etiqueta (ver escopo, itens 11-17, 59).
class WeighingController extends StateNotifier<WeighingState> {
  final ScaleService _scaleService;
  final WeightStabilityService _stabilityService;
  final ProductRepository _productRepository;
  final WeighingRepository _weighingRepository;
  final PrintQueueService _printQueueService;
  final BarcodeService _barcodeService;
  final SettingsRepository _settingsRepository;
  final EmployeeRepository _employeeRepository;
  final Ref _ref;

  StreamSubscription<ScaleReading>? _weightSub;
  StreamSubscription<ScaleConnectionStatus>? _statusSub;

  WeighingController({
    required ScaleService scaleService,
    required WeightStabilityService stabilityService,
    required ProductRepository productRepository,
    required WeighingRepository weighingRepository,
    required PrintQueueService printQueueService,
    required BarcodeService barcodeService,
    required SettingsRepository settingsRepository,
    required EmployeeRepository employeeRepository,
    required Ref ref,
  })  : _scaleService = scaleService,
        _stabilityService = stabilityService,
        _productRepository = productRepository,
        _weighingRepository = weighingRepository,
        _printQueueService = printQueueService,
        _barcodeService = barcodeService,
        _settingsRepository = settingsRepository,
        _employeeRepository = employeeRepository,
        _ref = ref,
        super(WeighingState(scaleStatus: _mapConnStatus(scaleService.currentStatus))) {
    _weightSub = _scaleService.weightStream.listen(_onWeightReading);
    _statusSub = _scaleService.connectionStatusStream.listen(_onConnectionStatus);
    _loadSalesConfig();
  }

  /// Carrega, ao abrir a tela, o modo de venda configurado (ver
  /// `SettingsRepository.getSalesMode`) e os funcionários ativos
  /// disponíveis para vincular a uma venda por comanda.
  Future<void> _loadSalesConfig() async {
    final salesMode = await _settingsRepository.getSalesMode();
    final employees = await _employeeRepository.getAll(onlyActive: true);
    state = state.copyWith(salesMode: salesMode, employees: employees);
  }

  static ScaleDisplayStatus _mapConnStatus(ScaleConnectionStatus status) => switch (status) {
        ScaleConnectionStatus.semBalanca => ScaleDisplayStatus.semBalanca,
        ScaleConnectionStatus.conectando => ScaleDisplayStatus.conectando,
        ScaleConnectionStatus.conectada => ScaleDisplayStatus.conectada,
        ScaleConnectionStatus.erro => ScaleDisplayStatus.erro,
      };

  void _onConnectionStatus(ScaleConnectionStatus status) {
    _stabilityService.reset();
    state = state.copyWith(
      scaleStatus: _mapConnStatus(status),
      weightKg: status == ScaleConnectionStatus.conectada ? state.weightKg : 0,
    );
  }

  void _onWeightReading(ScaleReading reading) {
    if (_scaleService.currentStatus != ScaleConnectionStatus.conectada) return;
    final result = _stabilityService.evaluate(reading.kg);
    state = state.copyWith(
      weightKg: result.kg,
      scaleStatus: result.stable ? ScaleDisplayStatus.estavel : ScaleDisplayStatus.instavel,
    );
  }

  /// Atualiza o campo de código/pesquisa e busca produtos
  /// correspondentes (ver escopo, item 14).
  Future<void> updateSearchTerm(String term) async {
    state = state.copyWith(codeInput: term, clearLastError: true);
    if (term.trim().isEmpty) {
      state = state.copyWith(searchResults: const []);
      return;
    }
    final results = await _productRepository.search(term);
    // Evita sobrescrever uma digitação mais recente com um resultado
    // de busca que chegou atrasado.
    if (state.codeInput == term) {
      state = state.copyWith(searchResults: results);
    }
  }

  void appendDigit(String digit) => updateSearchTerm(state.codeInput + digit);

  void clearInput() => updateSearchTerm('');

  /// Equivalentes a [appendDigit]/[clearInput], mas para a quantidade
  /// digitada quando o produto selecionado é vendido por unidade (ver
  /// [WeighingState.porUnidade]) — o teclado numérico da busca é
  /// reaproveitado para isso, ligado a estes métodos em vez dos de
  /// código enquanto houver um produto por unidade selecionado.
  void appendQuantityDigit(String digit) {
    state = state.copyWith(quantidadeInput: state.quantidadeInput + digit, clearLastError: true);
  }

  void clearQuantityInput() {
    state = state.copyWith(quantidadeInput: '', clearLastError: true);
  }

  /// Confirma a seleção pelo teclado numérico: usa o código exato
  /// digitado ou, se houver uma única correspondência na busca,
  /// seleciona-a.
  Future<void> confirmSelection() async {
    final term = state.codeInput.trim();
    if (term.isEmpty) return;

    final exact = await _productRepository.getByCodigo(term);
    if (exact != null) {
      selectProduct(exact);
      return;
    }
    if (state.searchResults.length == 1) {
      selectProduct(state.searchResults.first);
    }
  }

  void selectProduct(ProductModel product) {
    state = state.copyWith(
      selectedProduct: product,
      codeInput: '',
      searchResults: const [],
      quantidadeInput: '',
      clearLastError: true,
    );
  }

  void clearProduct() {
    state = state.copyWith(
      clearSelectedProduct: true,
      quantidadeInput: '',
      clearLastError: true,
    );
  }

  /// Atualiza o número da comanda digitado no popup pedido ao
  /// confirmar o produto (modo comanda — ver
  /// [WeighingState.precisaComanda]).
  void setComandaNumero(String value) {
    state = state.copyWith(comandaNumero: value, clearLastError: true);
  }

  /// Define o(s) funcionário(s) selecionados no popup da comanda —
  /// mais de um pode ser selecionado quando a comanda foi atendida por
  /// mais de um funcionário.
  void setSelectedEmployees(Set<int> employeeIds) {
    state = state.copyWith(selectedEmployeeIds: employeeIds, clearLastError: true);
  }

  /// Confirma a venda com o método adequado ao modo configurado (ver
  /// [WeighingState.salesMode]): imprime a etiqueta ou registra a
  /// venda por comanda.
  Future<void> confirmSale() =>
      state.precisaComanda ? confirmComanda() : confirmPrint();

  /// Registra a venda por comanda: sem impressão, salva o número da
  /// comanda e o(s) funcionário(s) selecionados vinculados ao
  /// histórico (ver `WeighingRepository.insertWithEmployees`).
  Future<void> confirmComanda() async {
    final product = state.selectedProduct;
    if (product == null || !state.canRegisterComanda) return;

    state = state.copyWith(isPrinting: true, clearLastError: true);
    try {
      final total = state.total;
      final valor = state.valorOperacao;
      final now = DateTime.now();
      final uuid = const Uuid().v4();
      final comanda = state.comandaNumero.trim();

      final weighing = WeighingModel(
        uuid: uuid,
        dataHora: now,
        produtoId: product.id!,
        codigo: product.codigo,
        descricao: product.descricao,
        peso: valor,
        precoKg: product.preco,
        valorTotal: total,
        comandaNumero: comanda,
        statusImpressao: PrintStatus.comanda,
      );
      final id = await _weighingRepository.insertWithEmployees(
        weighing,
        employeeIds: state.selectedEmployeeIds.toList(),
      );
      final valorFormatado =
          state.porUnidade ? '${valor.round()} un' : WeightUtils.format(valor);
      await _ref.read(auditRepositoryProvider).insert(AuditLogModel(
            dataHora: now,
            tipo: AuditEventType.vendaComanda,
            descricao: '${product.descricao} · $valorFormatado · '
                '${CurrencyUtils.format(total)} · Comanda $comanda',
          ));

      _stabilityService.reset();
      state = state.copyWith(
        isPrinting: false,
        clearSelectedProduct: true,
        quantidadeInput: '',
        comandaNumero: '',
        selectedEmployeeIds: const {},
        lastPrinted: weighing.copyWith(id: id),
      );
    } catch (e, st) {
      AppLogger.e('Falha ao registrar venda por comanda', e, st);
      state = state.copyWith(isPrinting: false, lastError: 'Falha ao registrar comanda: $e');
    }
  }

  /// Confirma a impressão: monta o código de barras, envia para a
  /// impressora e registra a pesagem no histórico — nessa ordem, para
  /// nunca registrar uma impressão que não foi de fato enviada
  /// (ver escopo, item 59).
  Future<void> confirmPrint() async {
    final product = state.selectedProduct;
    if (product == null || !state.canPrint) return;

    state = state.copyWith(isPrinting: true, clearLastError: true);
    try {
      final total = state.total;
      final valor = state.valorOperacao;
      final now = DateTime.now();
      final uuid = const Uuid().v4();
      final barcodeConfig = _ref.read(barcodeConfigProvider);
      final barcode = _barcodeService.build(
        barcodeConfig,
        BarcodeInput(
          productCode: product.codigo,
          pricePerKg: product.preco,
          total: total,
          weightKg: valor,
          porUnidade: state.porUnidade,
          importedBarcode: product.codigoBarras,
        ),
      );
      final validade = product.validadeDias != null
          ? AppDateUtils.calculateExpiryDate(product.validadeDias!, from: now)
          : null;

      await _printQueueService.enqueue(
        LabelPrintData(
          produto: product.descricao,
          codigo: product.codigo,
          peso: valor,
          precoKg: product.preco,
          total: total,
          codigoBarras: barcode,
          dataHora: now,
          validade: validade,
          porUnidade: state.porUnidade,
        ),
        jobId: uuid,
      );

      final printerName =
          (await _ref.read(printerRepositoryProvider).getDefault())?.nome ?? 'Impressora Simulada';

      final weighing = WeighingModel(
        uuid: uuid,
        dataHora: now,
        produtoId: product.id!,
        codigo: product.codigo,
        descricao: product.descricao,
        peso: valor,
        precoKg: product.preco,
        valorTotal: total,
        codigoBarras: barcode,
        impressora: printerName,
        statusImpressao: PrintStatus.impresso,
        quantidadeImpressoes: 1,
      );
      final id = await _weighingRepository.insert(weighing);
      final valorFormatado =
          state.porUnidade ? '${valor.round()} un' : WeightUtils.format(valor);
      await _ref.read(auditRepositoryProvider).insert(AuditLogModel(
            dataHora: now,
            tipo: AuditEventType.impressaoRealizada,
            descricao: '${product.descricao} · $valorFormatado · '
                '${CurrencyUtils.format(total)}',
            detalhes: barcode,
          ));

      _stabilityService.reset();
      state = state.copyWith(
        isPrinting: false,
        clearSelectedProduct: true,
        quantidadeInput: '',
        lastPrinted: weighing.copyWith(id: id),
      );
    } catch (e, st) {
      AppLogger.e('Falha ao imprimir/registrar pesagem', e, st);
      state = state.copyWith(isPrinting: false, lastError: 'Falha ao imprimir: $e');
      await _ref.read(auditRepositoryProvider).insert(AuditLogModel(
            dataHora: DateTime.now(),
            tipo: AuditEventType.falhaImpressao,
            descricao: 'Falha ao imprimir etiqueta de "${product.descricao}"',
            detalhes: e.toString(),
          ));
    }
  }

  @override
  void dispose() {
    _weightSub?.cancel();
    _statusSub?.cancel();
    super.dispose();
  }
}

final weighingControllerProvider =
    StateNotifierProvider.autoDispose<WeighingController, WeighingState>((ref) {
  return WeighingController(
    scaleService: ref.watch(scaleServiceProvider),
    stabilityService: WeightStabilityService(),
    productRepository: ref.watch(productRepositoryProvider),
    weighingRepository: ref.watch(weighingRepositoryProvider),
    printQueueService: ref.watch(printQueueServiceProvider),
    barcodeService: BarcodeService(),
    settingsRepository: ref.watch(settingsRepositoryProvider),
    employeeRepository: ref.watch(employeeRepositoryProvider),
    ref: ref,
  );
});
