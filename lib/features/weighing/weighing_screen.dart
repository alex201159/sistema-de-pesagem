import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/weight_utils.dart';
import '../../data/models/product_model.dart';
import '../../data/models/weighing_model.dart';
import '../../widgets/numeric_keyboard.dart';
import '../../widgets/status_indicator.dart';
import '../products/products_screen.dart';
import 'weighing_controller.dart';

/// Tela principal de pesagem/venda do totem (ver escopo, item 13).
///
/// Seleção do produto por código/pesquisa, peso ao vivo da balança com
/// indicação de estabilidade, preço/kg, total e impressão da etiqueta.
class WeighingScreen extends ConsumerWidget {
  const WeighingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weighingControllerProvider);
    final controller = ref.read(weighingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.weighingBackground,
      appBar: AppBar(
        title: const Text('Pesagem'),
        actions: [
          IconButton(
            tooltip: 'Ver todos os produtos',
            icon: const Icon(Icons.list_alt),
            onPressed: () async {
              final selected = await Navigator.of(context).push<ProductModel>(
                MaterialPageRoute(builder: (_) => const ProductsScreen(selectable: true)),
              );
              if (selected != null) controller.selectProduct(selected);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceMd),
            child: Center(child: _ScaleStatusIndicator(status: state.scaleStatus)),
          ),
        ],
      ),
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.landscape
            ? _LandscapeBody(state: state, controller: controller)
            : _PortraitBody(state: state, controller: controller),
      ),
    );
  }
}

/// Layout em pé (padrão original): tudo empilhado verticalmente, com
/// rolagem quando não couber.
class _PortraitBody extends StatelessWidget {
  const _PortraitBody({required this.state, required this.controller});

  final WeighingState state;
  final WeighingController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.lastError != null) _ErrorBanner(message: state.lastError!),
          if (state.lastPrinted != null) _LastPrintedBanner(weighing: state.lastPrinted!),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            'PRODUTO',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.weighingSectionLabel),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          if (state.selectedProduct == null)
            _ProductSearch(
              codeInput: state.codeInput,
              results: state.searchResults,
              onChanged: controller.updateSearchTerm,
              onSelect: controller.selectProduct,
              onDigit: controller.appendDigit,
              onClear: controller.clearInput,
              onConfirm: controller.confirmSelection,
            )
          else
            _SelectedProductCard(
              product: state.selectedProduct!,
              onChange: controller.clearProduct,
            ),
          const SizedBox(height: AppDimensions.spaceLg),
          if (state.porUnidade)
            _QuantityKeypad(
              quantidadeInput: state.quantidadeInput,
              onDigit: controller.appendQuantityDigit,
              onClear: controller.clearQuantityInput,
            )
          else
            _WeightCard(weightKg: state.weightKg, status: state.scaleStatus),
          const SizedBox(height: AppDimensions.spaceLg),
          _TotalsRow(
            pricePerKg: state.selectedProduct?.preco ?? 0,
            total: state.total,
          ),
          const SizedBox(height: AppDimensions.spaceXl),
          _PrintButton(state: state, controller: controller),
        ],
      ),
    );
  }
}

/// Layout em paisagem: busca/teclado numérico à esquerda; à direita —
/// de cima para baixo — peso (em destaque, ocupa o espaço restante),
/// preço/kg e total, e o botão de imprimir (ver mockups de layout
/// aprovados com o usuário — opção "Peso em destaque").
class _LandscapeBody extends StatelessWidget {
  const _LandscapeBody({required this.state, required this.controller});

  final WeighingState state;
  final WeighingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 34,
            // Busca e teclado ficam sempre disponíveis aqui, mesmo com
            // um produto já selecionado — permite já digitar/escanear
            // o próximo código sem precisar tocar em "TROCAR" antes.
            // O teclado fica fixo nesta coluna; a lista de resultados
            // aparece do outro lado (ver mais abaixo), não aqui.
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Enquanto um produto por unidade está
                        // selecionado, esta área alimenta a quantidade
                        // em vez da busca do próximo produto — não há
                        // balança envolvida para aguardar em paralelo.
                        if (state.porUnidade)
                          _QuantityKeypad(
                            quantidadeInput: state.quantidadeInput,
                            onDigit: controller.appendQuantityDigit,
                            onClear: controller.clearQuantityInput,
                            compact: true,
                          )
                        else
                          _ProductSearch(
                            codeInput: state.codeInput,
                            results: state.searchResults,
                            onChanged: controller.updateSearchTerm,
                            onSelect: controller.selectProduct,
                            onDigit: controller.appendDigit,
                            onClear: controller.clearInput,
                            onConfirm: controller.confirmSelection,
                            compact: true,
                            showResultsInline: false,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            flex: 66,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Altura do card de peso como fração do espaço
                // disponível, nunca abaixo do que o próprio conteúdo
                // do card precisa (texto `displayLarge` + status +
                // padding — por volta de 190px) para não cortar o
                // texto; cresce em telas maiores (tablet). Tudo dentro
                // de rolagem: se ainda assim não couber numa tela muito
                // baixa, rola em vez de estourar.
                final weightCardHeight = (constraints.maxHeight * 0.4).clamp(170.0, 260.0);
                // Enquanto ainda não há produto selecionado e a busca
                // já tem resultados, a lista flutua por cima do
                // peso/preço/total em vez de dividir espaço com eles —
                // grande, mesmo que cubra esses campos: o operador está
                // escolhendo o produto, não olhando pro total ainda.
                final showResultsOverlay = !state.porUnidade &&
                    state.selectedProduct == null &&
                    state.searchResults.isNotEmpty;
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (state.lastError != null) _ErrorBanner(message: state.lastError!),
                            if (state.lastPrinted != null)
                              _LastPrintedBanner(weighing: state.lastPrinted!),
                            if (state.selectedProduct != null) ...[
                              _SelectedProductCard(
                                product: state.selectedProduct!,
                                onChange: controller.clearProduct,
                                compact: true,
                              ),
                              const SizedBox(height: AppDimensions.spaceMd),
                            ],
                            SizedBox(
                              height: weightCardHeight,
                              child: state.porUnidade
                                  ? _QuantityCard(quantidadeInput: state.quantidadeInput)
                                  : _WeightCard(weightKg: state.weightKg, status: state.scaleStatus),
                            ),
                            const SizedBox(height: AppDimensions.spaceMd),
                            _TotalsRow(
                              pricePerKg: state.selectedProduct?.preco ?? 0,
                              total: state.total,
                            ),
                            const SizedBox(height: AppDimensions.spaceMd),
                            _PrintButton(state: state, controller: controller),
                          ],
                        ),
                      ),
                    ),
                    if (showResultsOverlay)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: _SearchResultsList(
                          results: state.searchResults,
                          onSelect: controller.selectProduct,
                          maxHeight: constraints.maxHeight * 0.85,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PrintButton extends StatelessWidget {
  const _PrintButton({required this.state, required this.controller});

  final WeighingState state;
  final WeighingController controller;

  @override
  Widget build(BuildContext context) {
    final isComanda = state.precisaComanda;
    // No modo comanda, o número/funcionário(s) são pedidos no popup ao
    // confirmar — não bloqueiam o botão antecipadamente, só o
    // peso/quantidade prontos (mesma condição do modo etiqueta).
    final canConfirm = state.canPrint;

    return SizedBox(
      height: AppDimensions.buttonHeightPrimary,
      child: ElevatedButton.icon(
        onPressed: canConfirm
            ? () => isComanda ? _openComandaDialog(context) : controller.confirmPrint()
            : null,
        style: ElevatedButton.styleFrom(
          // O estilo desabilitado padrão do Material 3 usa um cinza
          // translúcido pensado para ficar sobre fundo claro — sobre o
          // fundo escuro desta tela ([AppColors.weighingBackground])
          // ele quase some. Um cinza sólido garante que o botão
          // continue visível (ainda que "desligado") em qualquer fundo.
          disabledBackgroundColor: AppColors.surfaceAlt.withValues(alpha: 0.25),
          disabledForegroundColor: AppColors.surfaceAlt,
        ),
        icon: state.isPrinting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Icon(isComanda ? Icons.receipt_long : Icons.print),
        label: Text(
          state.isPrinting
              ? (isComanda ? 'REGISTRANDO...' : 'IMPRIMINDO...')
              : (isComanda ? 'REGISTRAR COMANDA' : 'IMPRIMIR ETIQUETA'),
        ),
      ),
    );
  }

  Future<void> _openComandaDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const _ComandaDialog(),
    );
  }
}

/// Popup pedido ao confirmar o produto quando o totem está em modo
/// comanda (ver [WeighingState.precisaComanda]): número da comanda e
/// o(s) funcionário(s) que atenderam a venda — pode haver mais de um.
/// Só fecha sozinho quando o registro é concluído com sucesso.
class _ComandaDialog extends ConsumerStatefulWidget {
  const _ComandaDialog();

  @override
  ConsumerState<_ComandaDialog> createState() => _ComandaDialogState();
}

class _ComandaDialogState extends ConsumerState<_ComandaDialog> {
  late final TextEditingController _comandaController;
  late Set<int> _selectedIds;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(weighingControllerProvider);
    _comandaController = TextEditingController(text: state.comandaNumero);
    _selectedIds = Set<int>.from(state.selectedEmployeeIds);
  }

  @override
  void dispose() {
    _comandaController.dispose();
    super.dispose();
  }

  bool get _canConfirm =>
      !_submitting && _comandaController.text.trim().isNotEmpty && _selectedIds.isNotEmpty;

  Future<void> _confirm() async {
    if (!_canConfirm) return;
    setState(() => _submitting = true);

    final controller = ref.read(weighingControllerProvider.notifier);
    controller.setComandaNumero(_comandaController.text.trim());
    controller.setSelectedEmployees(_selectedIds);
    await controller.confirmComanda();

    if (!mounted) return;
    if (ref.read(weighingControllerProvider).lastError != null) {
      // Falhou ao registrar: mantém o popup aberto com o erro visível
      // e os dados preenchidos, para o operador tentar de novo.
      setState(() => _submitting = false);
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weighingControllerProvider);
    final employees = state.employees;
    final error = state.lastError;

    return AlertDialog(
      title: const Text('Registrar Comanda'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _comandaController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número da comanda',
                prefixIcon: Icon(Icons.confirmation_number_outlined),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _confirm(),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text('FUNCIONÁRIO(S)', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppDimensions.spaceSm),
            if (employees.isEmpty)
              const Text('Nenhum funcionário ativo cadastrado.')
            else
              Wrap(
                spacing: AppDimensions.spaceSm,
                runSpacing: AppDimensions.spaceSm,
                children: employees.map((employee) {
                  final selected = _selectedIds.contains(employee.id);
                  return FilterChip(
                    label: Text(employee.nome),
                    selected: selected,
                    onSelected: (_) => setState(() {
                      if (!_selectedIds.remove(employee.id)) {
                        _selectedIds.add(employee.id!);
                      }
                    }),
                  );
                }).toList(),
              ),
            if (error != null) ...[
              const SizedBox(height: AppDimensions.spaceMd),
              Text(error, style: const TextStyle(color: AppColors.statusError)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('CANCELAR'),
        ),
        FilledButton(
          onPressed: _canConfirm ? _confirm : null,
          child: _submitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('CONFIRMAR'),
        ),
      ],
    );
  }
}

class _ScaleStatusIndicator extends StatelessWidget {
  final ScaleDisplayStatus status;

  const _ScaleStatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, level) = switch (status) {
      ScaleDisplayStatus.semBalanca => ('SEM BALANÇA', StatusLevel.error),
      ScaleDisplayStatus.conectando => ('CONECTANDO', StatusLevel.warning),
      ScaleDisplayStatus.conectada => ('CONECTADA', StatusLevel.info),
      ScaleDisplayStatus.instavel => ('PESO INSTÁVEL', StatusLevel.warning),
      ScaleDisplayStatus.estavel => ('PESO ESTÁVEL', StatusLevel.ok),
      ScaleDisplayStatus.erro => ('ERRO', StatusLevel.error),
    };
    return StatusIndicator(label: label, level: level);
  }
}

class _ProductSearch extends StatefulWidget {
  final String codeInput;
  final List<ProductModel> results;
  final ValueChanged<String> onChanged;
  final ValueChanged<ProductModel> onSelect;
  final ValueChanged<String> onDigit;
  final VoidCallback onClear;
  final VoidCallback onConfirm;

  /// Campo de busca menor e teclas menores (usado no layout em
  /// paisagem, onde a coluna esquerda é mais estreita) em vez do
  /// tamanho grande pensado para a tela cheia do modo retrato.
  final bool compact;

  /// Mostra a lista de resultados empilhada logo acima do teclado,
  /// aqui mesmo. `false` no layout em paisagem (`_LandscapeBody`), que
  /// mostra a lista do outro lado — a mesma coluna onde aparece o
  /// produto depois de escolhido — e mantém o teclado sempre no mesmo
  /// lugar, sem ser empurrado pela lista aparecendo/sumindo.
  final bool showResultsInline;

  const _ProductSearch({
    required this.codeInput,
    required this.results,
    required this.onChanged,
    required this.onSelect,
    required this.onDigit,
    required this.onClear,
    required this.onConfirm,
    this.compact = false,
    this.showResultsInline = true,
  });

  @override
  State<_ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<_ProductSearch> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.codeInput);
  }

  @override
  void didUpdateWidget(covariant _ProductSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Mantém o campo sincronizado quando o texto muda por fora do
    // teclado do sistema (ex.: teclado numérico virtual ou "limpar"),
    // sem mexer no cursor quando a mudança já veio do próprio TextField.
    if (widget.codeInput != _textController.text) {
      _textController.value = TextEditingValue(
        text: widget.codeInput,
        selection: TextSelection.collapsed(offset: widget.codeInput.length),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = widget.results;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _textController,
          onChanged: widget.onChanged,
          onSubmitted: (_) => widget.onConfirm(),
          style: widget.compact
              ? Theme.of(context).textTheme.titleMedium
              : Theme.of(context).textTheme.headlineMedium,
          decoration: InputDecoration(
            hintText: widget.compact ? 'Código...' : 'Digite o código ou pesquise...',
            prefixIcon: const Icon(Icons.search),
            isDense: widget.compact,
            contentPadding: widget.compact
                ? const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMd, vertical: AppDimensions.spaceSm)
                : null,
          ),
        ),
        SizedBox(height: widget.compact ? AppDimensions.spaceMd : AppDimensions.spaceLg),
        // Quando a lista aparece aqui mesmo (modo retrato), fica
        // sempre acima do teclado, nunca no lugar dele — com altura
        // limitada e rolagem própria, então nunca cresce a ponto de
        // empurrar/cobrir o teclado. O operador continua conseguindo
        // digitar mais dígitos, apagar ou confirmar mesmo com
        // resultados visíveis.
        if (widget.showResultsInline && results.isNotEmpty) ...[
          _SearchResultsList(results: results, onSelect: widget.onSelect),
          SizedBox(height: widget.compact ? AppDimensions.spaceMd : AppDimensions.spaceLg),
        ],
        Center(
          child: NumericKeyboard(
            onDigit: widget.onDigit,
            onClear: widget.onClear,
            onConfirm: widget.onConfirm,
            keySize: widget.compact ? 60 : AppDimensions.numericKeyboardKeySize,
          ),
        ),
      ],
    );
  }
}

/// Lista de produtos correspondentes à busca — separada de
/// `_ProductSearch` para poder ser exibida em outro lugar da tela (ver
/// layout em paisagem: aparece na coluna direita, acima do peso, em
/// vez de empurrar o teclado numérico para baixo).
class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    required this.results,
    required this.onSelect,
    this.maxHeight = 180,
  });

  final List<ProductModel> results;
  final ValueChanged<ProductModel> onSelect;

  /// Altura máxima do cartão — pequena e sem sobrepor nada no modo
  /// retrato (empilhada acima do teclado, ver `_ProductSearch`); grande
  /// no layout em paisagem, onde flutua por cima do peso/preço/total em
  /// vez de dividir espaço com eles (ver `_LandscapeBody`).
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.elevationDialog,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: results.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final product = results[index];
            return ListTile(
              title: Text('${product.codigo} - ${product.descricao}'),
              subtitle: Text(CurrencyUtils.format(product.preco)),
              onTap: () => onSelect(product),
            );
          },
        ),
      ),
    );
  }
}

class _SelectedProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onChange;

  /// Versão menor (usada no layout em paisagem, onde este card só
  /// precisa identificar o produto rapidamente acima do peso, sem
  /// competir por espaço com ele) em vez do tamanho grande pensado
  /// para a tela cheia do modo retrato.
  final bool compact;

  const _SelectedProductCard({
    required this.product,
    required this.onChange,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceAlt,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(compact ? AppDimensions.spaceSm : AppDimensions.spaceLg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!compact) Text(product.codigo, style: Theme.of(context).textTheme.bodySmall),
                  Text(
                    compact ? '${product.codigo} - ${product.descricao}' : product.descricao,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: compact
                        ? Theme.of(context).textTheme.bodyLarge
                        : Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            TextButton(onPressed: onChange, child: const Text('TROCAR')),
          ],
        ),
      ),
    );
  }
}

class _WeightCard extends StatelessWidget {
  final double weightKg;
  final ScaleDisplayStatus status;

  const _WeightCard({required this.weightKg, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ScaleDisplayStatus.estavel => ('PESO ESTÁVEL', AppColors.statusOk),
      ScaleDisplayStatus.instavel => ('PESO INSTÁVEL', AppColors.statusWarning),
      ScaleDisplayStatus.conectando => ('CONECTANDO...', AppColors.statusWarning),
      ScaleDisplayStatus.semBalanca => ('SEM BALANÇA', AppColors.statusError),
      ScaleDisplayStatus.erro => ('ERRO NA BALANÇA', AppColors.statusError),
      ScaleDisplayStatus.conectada => ('AGUARDANDO PESO', AppColors.statusInfo),
    };

    return Card(
      color: AppColors.surfaceAlt,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              WeightUtils.format(weightKg),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Equivalente ao [_WeightCard] para produtos vendidos por unidade:
/// mesmo visual (número grande + rótulo), mas mostra a quantidade
/// digitada em vez do peso da balança — nunca depende de
/// [ScaleDisplayStatus].
class _QuantityCard extends StatelessWidget {
  final String quantidadeInput;

  const _QuantityCard({required this.quantidadeInput});

  @override
  Widget build(BuildContext context) {
    final display = quantidadeInput.isEmpty ? '0' : quantidadeInput;
    return Card(
      color: AppColors.surfaceAlt,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$display un',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              'QUANTIDADE',
              style: TextStyle(
                color: AppColors.statusInfo,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Teclado numérico para digitar a quantidade de um produto vendido
/// por unidade — reaproveita o mesmo [NumericKeyboard] do campo de
/// busca, mas alimenta [WeighingController.appendQuantityDigit]/
/// [WeighingController.clearQuantityInput] em vez da busca de produto
/// (ver [WeighingState.porUnidade]).
class _QuantityKeypad extends StatelessWidget {
  final String quantidadeInput;
  final ValueChanged<String> onDigit;
  final VoidCallback onClear;

  /// Teclas menores (usado no layout em paisagem, mesma lógica de
  /// `_ProductSearch.compact`).
  final bool compact;

  const _QuantityKeypad({
    required this.quantidadeInput,
    required this.onDigit,
    required this.onClear,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: compact ? AppDimensions.spaceSm : AppDimensions.spaceMd,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            children: [
              const Icon(Icons.pin_outlined, size: 20),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Text(
                  quantidadeInput.isEmpty ? 'Quantidade...' : '$quantidadeInput un',
                  style: compact
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? AppDimensions.spaceMd : AppDimensions.spaceLg),
        Center(
          child: NumericKeyboard(
            onDigit: onDigit,
            onClear: onClear,
            onConfirm: () {},
            keySize: compact ? 60 : AppDimensions.numericKeyboardKeySize,
          ),
        ),
      ],
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final double pricePerKg;
  final double total;

  const _TotalsRow({required this.pricePerKg, required this.total});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _TotalCard(label: 'R\$/kg', value: CurrencyUtils.format(pricePerKg)),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: _TotalCard(
              label: 'TOTAL',
              value: CurrencyUtils.format(total),
              highlight: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _TotalCard({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: highlight ? AppColors.primary : null,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: highlight ? AppColors.textOnPrimary.withValues(alpha: 0.75) : null,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: (highlight
                      ? Theme.of(context).textTheme.headlineLarge
                      : Theme.of(context).textTheme.titleMedium)
                  ?.copyWith(color: highlight ? AppColors.textOnPrimary : null),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.statusError.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.statusError),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(child: Text(message, style: const TextStyle(color: AppColors.statusError))),
        ],
      ),
    );
  }
}

class _LastPrintedBanner extends StatelessWidget {
  final WeighingModel weighing;

  const _LastPrintedBanner({required this.weighing});

  @override
  Widget build(BuildContext context) {
    final isComanda = weighing.statusImpressao == PrintStatus.comanda;
    final message = isComanda
        ? 'Venda de "${weighing.descricao}" registrada na comanda ${weighing.comandaNumero}.'
        : 'Etiqueta de "${weighing.descricao}" impressa com sucesso.';
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.statusOk.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(isComanda ? Icons.receipt_long : Icons.check_circle, color: AppColors.statusOk),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
