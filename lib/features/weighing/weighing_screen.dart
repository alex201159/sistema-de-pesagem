import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/weight_utils.dart';
import '../../data/models/product_model.dart';
import '../../data/models/weighing_model.dart';
import '../../widgets/numeric_keyboard.dart';
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
        // Barra escura, contínua com o fundo da tela — a barra branca
        // padrão cortava a tela ao meio. O status da balança fica no
        // próprio visor do peso, não aqui.
        backgroundColor: AppColors.weighingBackground,
        foregroundColor: AppColors.textOnPrimary,
        surfaceTintColor: Colors.transparent,
        title: const Text('Pesagem', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceMd),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textOnPrimary,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
              ),
              icon: const Icon(Icons.list_alt),
              label: const Text('PRODUTOS'),
              onPressed: () async {
                final selected = await Navigator.of(context).push<ProductModel>(
                  MaterialPageRoute(builder: (_) => const ProductsScreen(selectable: true)),
                );
                if (selected != null) controller.selectProduct(selected);
              },
            ),
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

/// Layout em pé: tudo empilhado verticalmente, com rolagem quando não
/// couber — informação (produto, peso, preço) em cima, entrada (código,
/// teclado, imprimir) embaixo.
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
          _Banners(state: state),
          _ProductPanel(product: state.selectedProduct, onChange: controller.clearProduct),
          const SizedBox(height: AppDimensions.spaceMd),
          SizedBox(height: 300, child: _WeightDisplay(state: state)),
          const SizedBox(height: AppDimensions.spaceMd),
          _PriceRow(state: state),
          const SizedBox(height: AppDimensions.spaceLg),
          _InputField(state: state, controller: controller),
          if (!state.porUnidade && state.searchResults.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spaceMd),
            _SearchResultsList(
              results: state.searchResults,
              onSelect: controller.selectProduct,
            ),
          ],
          const SizedBox(height: AppDimensions.spaceMd),
          _Keypad(state: state, controller: controller, keySize: 120),
          const SizedBox(height: AppDimensions.spaceLg),
          _PrintButton(state: state, controller: controller),
        ],
      ),
    );
  }
}

/// Layout em paisagem (totem): à esquerda a informação — produto, visor
/// do peso (ocupa o espaço restante) e preço/total; à direita o painel
/// de ação — código, teclado numérico e o botão de imprimir, na ordem
/// em que o operador usa (digita, confirma, imprime).
class _LandscapeBody extends StatelessWidget {
  const _LandscapeBody({required this.state, required this.controller});

  final WeighingState state;
  final WeighingController controller;

  @override
  Widget build(BuildContext context) {
    // Com a busca retornando resultados, a lista flutua por cima do
    // produto/peso/preço em vez de dividir espaço com eles — o operador
    // está escolhendo o produto, não olhando pro total ainda. Vale
    // também com um produto já selecionado: digitar o próximo código
    // direto (sem tocar em "TROCAR") precisa mostrar a lista. O teclado,
    // do outro lado, nunca se move.
    final showResultsOverlay = !state.porUnidade && state.searchResults.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceLg,
        AppDimensions.spaceSm,
        AppDimensions.spaceLg,
        AppDimensions.spaceLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 62,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Banners(state: state),
                        _ProductPanel(
                          product: state.selectedProduct,
                          onChange: controller.clearProduct,
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Expanded(child: _WeightDisplay(state: state)),
                        const SizedBox(height: AppDimensions.spaceMd),
                        _PriceRow(state: state),
                      ],
                    ),
                    if (showResultsOverlay)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: _SearchResultsList(
                          results: state.searchResults,
                          onSelect: controller.selectProduct,
                          maxHeight: constraints.maxHeight,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: AppDimensions.spaceLg),
          Expanded(
            flex: 38,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.weighingPanel,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(color: AppColors.weighingPanelBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InputField(state: state, controller: controller),
                  const SizedBox(height: AppDimensions.spaceMd),
                  // Busca e teclado ficam sempre disponíveis, mesmo com
                  // um produto já selecionado — permite já digitar o
                  // próximo código sem tocar em "TROCAR" antes.
                  Expanded(child: _Keypad(state: state, controller: controller)),
                  const SizedBox(height: AppDimensions.spaceMd),
                  _PrintButton(state: state, controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rótulo pequeno em caixa alta usado acima dos blocos da tela.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {this.color = AppColors.weighingSectionLabel});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _Banners extends StatelessWidget {
  const _Banners({required this.state});

  final WeighingState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.lastError != null) _ErrorBanner(message: state.lastError!),
        if (state.lastPrinted != null) _LastPrintedBanner(weighing: state.lastPrinted!),
      ],
    );
  }
}

/// Produto em venda. Sem produto, um painel discreto orienta o operador
/// a digitar o código; com produto, um cartão claro com código, nome e
/// preço, e o botão para trocar.
class _ProductPanel extends StatelessWidget {
  const _ProductPanel({required this.product, required this.onChange});

  final ProductModel? product;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    if (product == null) {
      return Container(
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.weighingPanelBorder, width: 2),
        ),
        child: const Row(
          children: [
            Icon(Icons.shopping_basket_outlined, color: AppColors.weighingSectionLabel, size: 36),
            SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nenhum produto selecionado',
                    style: TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Digite o código do produto no teclado',
                    style: TextStyle(color: AppColors.weighingSectionLabel, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final unit = product.unidade == AppConstants.defaultUnitUnit ? 'un' : 'kg';
    return Container(
      height: 104,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(
              product.codigo,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.descricao,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${CurrencyUtils.format(product.preco)} / $unit',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 56),
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            onPressed: onChange,
            icon: const Icon(Icons.swap_horiz),
            label: const Text('TROCAR'),
          ),
        ],
      ),
    );
  }
}

/// Visor do peso, no estilo do display de uma balança. Para produtos
/// vendidos por unidade mostra a quantidade digitada no lugar do peso
/// (nunca depende de [ScaleDisplayStatus] nesse caso).
class _WeightDisplay extends StatelessWidget {
  const _WeightDisplay({required this.state});

  final WeighingState state;

  @override
  Widget build(BuildContext context) {
    final String value;
    final String unit;
    final String label;
    final Color statusColor;
    final IconData statusIcon;
    var dimmed = false;

    if (state.porUnidade) {
      value = state.quantidadeInput.isEmpty ? '0' : state.quantidadeInput;
      unit = 'un';
      label = 'QUANTIDADE';
      statusColor = AppColors.statusInfoOnDark;
      statusIcon = Icons.pin_outlined;
    } else {
      value = WeightUtils.format(state.weightKg, withUnit: false);
      unit = 'kg';
      (label, statusColor, statusIcon) = switch (state.scaleStatus) {
        ScaleDisplayStatus.estavel => ('PESO ESTÁVEL', AppColors.statusOkOnDark, Icons.check_circle),
        ScaleDisplayStatus.instavel => ('PESO INSTÁVEL', AppColors.statusWarningOnDark, Icons.sync),
        ScaleDisplayStatus.conectando => ('CONECTANDO...', AppColors.statusWarningOnDark, Icons.sync),
        ScaleDisplayStatus.conectada => ('AGUARDANDO PESO', AppColors.statusInfoOnDark, Icons.scale),
        ScaleDisplayStatus.semBalanca => ('SEM BALANÇA', AppColors.statusErrorOnDark, Icons.link_off),
        ScaleDisplayStatus.erro => ('ERRO NA BALANÇA', AppColors.statusErrorOnDark, Icons.error),
      };
      dimmed = state.scaleStatus == ScaleDisplayStatus.semBalanca ||
          state.scaleStatus == ScaleDisplayStatus.erro;
    }

    final digitColor = dimmed
        ? AppColors.weighingDisplayText.withValues(alpha: 0.3)
        : AppColors.weighingDisplayText;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.weighingDisplay,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.weighingPanelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SectionLabel(state.porUnidade ? 'QUANTIDADE' : 'PESO'),
              const Spacer(),
              _StatusPill(label: label, color: statusColor, icon: statusIcon),
            ],
          ),
          Expanded(
            // O número cresce com o espaço disponível (tela cheia do
            // totem) e encolhe sem cortar em telas baixas.
            child: FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: digitColor,
                        fontSize: 140,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      unit,
                      style: TextStyle(
                        color: digitColor.withValues(alpha: dimmed ? 0.3 : 0.7),
                        fontSize: 56,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color, required this.icon});

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

/// Preço unitário e total lado a lado — o total em destaque.
class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.state});

  final WeighingState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: _PriceCard(
              label: state.porUnidade ? 'PREÇO / UN' : 'PREÇO / KG',
              value: CurrencyUtils.format(state.selectedProduct?.preco ?? 0),
              background: AppColors.weighingPanel,
              labelColor: AppColors.weighingSectionLabel,
              valueColor: AppColors.textOnPrimary,
              valueSize: 36,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            flex: 3,
            child: _PriceCard(
              label: 'TOTAL A PAGAR',
              value: CurrencyUtils.format(state.total),
              background: AppColors.surface,
              labelColor: AppColors.textSecondary,
              valueColor: AppColors.primary,
              valueSize: 56,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.label,
    required this.value,
    required this.background,
    required this.labelColor,
    required this.valueColor,
    required this.valueSize,
  });

  final String label;
  final String value;
  final Color background;
  final Color labelColor;
  final Color valueColor;
  final double valueSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLg,
        vertical: AppDimensions.spaceMd,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label, color: labelColor),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: valueSize,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Campo acima do teclado: código/busca do produto ou, com um produto
/// por unidade selecionado, a quantidade sendo digitada.
class _InputField extends StatelessWidget {
  const _InputField({required this.state, required this.controller});

  final WeighingState state;
  final WeighingController controller;

  @override
  Widget build(BuildContext context) {
    if (state.porUnidade) {
      return _FieldFrame(
        label: 'QUANTIDADE',
        icon: Icons.pin_outlined,
        child: Text(
          state.quantidadeInput.isEmpty ? 'Digite a quantidade' : '${state.quantidadeInput} un',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: state.quantidadeInput.isEmpty
                ? AppColors.textSecondary.withValues(alpha: 0.6)
                : AppColors.textPrimary,
          ),
        ),
      );
    }
    return _CodeField(
      codeInput: state.codeInput,
      onChanged: controller.updateSearchTerm,
      onConfirm: controller.confirmSelection,
    );
  }
}

class _FieldFrame extends StatelessWidget {
  const _FieldFrame({required this.label, required this.icon, required this.child});

  final String label;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(label),
        const SizedBox(height: AppDimensions.spaceSm),
        Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 28),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}

class _CodeField extends StatefulWidget {
  const _CodeField({
    required this.codeInput,
    required this.onChanged,
    required this.onConfirm,
  });

  final String codeInput;
  final ValueChanged<String> onChanged;
  final VoidCallback onConfirm;

  @override
  State<_CodeField> createState() => _CodeFieldState();
}

class _CodeFieldState extends State<_CodeField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.codeInput);
  }

  @override
  void didUpdateWidget(covariant _CodeField oldWidget) {
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
    return _FieldFrame(
      label: 'CÓDIGO DO PRODUTO',
      icon: Icons.search,
      child: TextField(
        controller: _textController,
        onChanged: widget.onChanged,
        onSubmitted: (_) => widget.onConfirm(),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Código ou nome',
          hintStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          filled: false,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }
}

/// Teclado numérico da tela: alimenta a busca do produto ou, com um
/// produto por unidade selecionado, a quantidade (ver
/// [WeighingState.porUnidade]).
class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.state,
    required this.controller,
    this.keySize = AppDimensions.numericKeyboardKeySize,
  });

  final WeighingState state;
  final WeighingController controller;

  /// Altura das teclas quando não há altura limitada (retrato, dentro
  /// da rolagem) — na paisagem o teclado preenche o painel.
  final double keySize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: state.porUnidade
          ? NumericKeyboard(
              onDigit: controller.appendQuantityDigit,
              onClear: controller.clearQuantityInput,
              onConfirm: () {},
              keySize: keySize,
            )
          : NumericKeyboard(
              onDigit: controller.appendDigit,
              onClear: controller.clearInput,
              onConfirm: controller.confirmSelection,
              keySize: keySize,
            ),
    );
  }
}

/// Lista de produtos correspondentes à busca — no layout em paisagem
/// flutua por cima do visor/preço (ver `_LandscapeBody`); no retrato
/// fica empilhada acima do teclado, com altura limitada.
class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    required this.results,
    required this.onSelect,
    this.maxHeight = 240,
  });

  final List<ProductModel> results;
  final ValueChanged<ProductModel> onSelect;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        side: const BorderSide(color: AppColors.weighingDisplayText, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spaceLg,
                AppDimensions.spaceMd,
                AppDimensions.spaceLg,
                AppDimensions.spaceSm,
              ),
              child: _SectionLabel(
                '${results.length} PRODUTO(S) ENCONTRADO(S)',
                color: AppColors.textSecondary,
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: results.length,
                separatorBuilder: (_, _) => const Divider(height: 1, indent: AppDimensions.spaceLg),
                itemBuilder: (context, index) {
                  final product = results[index];
                  return ListTile(
                    minTileHeight: 64,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
                    leading: SizedBox(
                      width: 72,
                      child: Text(
                        product.codigo,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(
                      product.descricao,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      CurrencyUtils.format(product.preco),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    onTap: () => onSelect(product),
                  );
                },
              ),
            ),
          ],
        ),
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
          backgroundColor: AppColors.weighingAction,
          foregroundColor: AppColors.textOnPrimary,
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          iconSize: 30,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          // Sólido e discreto quando desligado: o cinza translúcido
          // padrão do Material 3 some sobre o fundo escuro desta tela.
          disabledBackgroundColor: AppColors.textOnPrimary.withValues(alpha: 0.08),
          disabledForegroundColor: AppColors.textOnPrimary.withValues(alpha: 0.35),
        ),
        icon: state.isPrinting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
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

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return _Banner(
      icon: Icons.error_outline,
      message: message,
      background: const Color(0xFFFDECEA),
      foreground: AppColors.statusError,
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
    return _Banner(
      icon: isComanda ? Icons.receipt_long : Icons.check_circle,
      message: message,
      background: const Color(0xFFE6F4E8),
      foreground: AppColors.statusOk,
    );
  }
}

/// Aviso em cor sólida — as versões translúcidas ficavam apagadas
/// sobre o fundo escuro da tela.
class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.message,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String message;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: foreground),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: foreground, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
