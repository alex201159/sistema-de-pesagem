import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/label_element_model.dart';
import '../../data/models/label_model.dart';
import '../../services/printer/label_placeholder_resolver.dart';
import 'label_editor_controller.dart';
import 'widgets/label_element_view.dart';

/// Editor visual de etiquetas (ver escopo, itens 22-24): adicionar,
/// arrastar, redimensionar e estilizar elementos sobre um canvas do
/// tamanho real da etiqueta configurada.
class LabelEditorScreen extends ConsumerWidget {
  const LabelEditorScreen({super.key, required this.initial});

  final LabelModel initial;

  static const double pixelsPerMm = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = labelEditorControllerProvider(initial);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(initial.id == null ? 'Nova Etiqueta' : 'Editar Etiqueta'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceMd),
            child: FilledButton.icon(
              icon: state.saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check),
              label: const Text('SALVAR'),
              onPressed: state.saving
                  ? null
                  : () async {
                      await controller.save();
                      if (context.mounted) Navigator.of(context).pop(true);
                    },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _HeaderFields(initial: initial, controller: controller),
          _ElementToolbar(onAdd: controller.addElement),
          const Divider(height: 1),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectElement(null),
              child: Container(
                color: AppColors.surfaceAlt,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: _LabelCanvas(state: state, controller: controller),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: state.selectedElement == null
                ? const SizedBox(width: double.infinity)
                : _PropertiesPanel(
                    key: ValueKey(state.selectedIndex),
                    element: state.selectedElement!,
                    controller: controller,
                  ),
          ),
        ],
      ),
    );
  }
}

class _HeaderFields extends StatefulWidget {
  const _HeaderFields({required this.initial, required this.controller});

  final LabelModel initial;
  final LabelEditorController controller;

  @override
  State<_HeaderFields> createState() => _HeaderFieldsState();
}

class _HeaderFieldsState extends State<_HeaderFields> {
  late final TextEditingController _nome;
  late final TextEditingController _largura;
  late final TextEditingController _altura;

  @override
  void initState() {
    super.initState();
    _nome = TextEditingController(text: widget.initial.nome);
    _largura = TextEditingController(text: widget.initial.larguraMm.toStringAsFixed(0));
    _altura = TextEditingController(text: widget.initial.alturaMm.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _nome.dispose();
    _largura.dispose();
    _altura.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _nome,
              decoration: const InputDecoration(labelText: 'Nome do perfil'),
              onChanged: widget.controller.setLabelName,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: TextField(
              controller: _largura,
              decoration: const InputDecoration(labelText: 'Largura (mm)'),
              keyboardType: TextInputType.number,
              onChanged: (v) => widget.controller.setLabelSize(larguraMm: double.tryParse(v)),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: TextField(
              controller: _altura,
              decoration: const InputDecoration(labelText: 'Altura (mm)'),
              keyboardType: TextInputType.number,
              onChanged: (v) => widget.controller.setLabelSize(alturaMm: double.tryParse(v)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ElementToolbar extends StatelessWidget {
  const _ElementToolbar({required this.onAdd});

  final ValueChanged<LabelElementType> onAdd;

  static const _labels = {
    LabelElementType.produto: 'Produto',
    LabelElementType.codigo: 'Código',
    LabelElementType.plu: 'PLU',
    LabelElementType.peso: 'Peso',
    LabelElementType.precoKg: 'Preço/kg',
    LabelElementType.total: 'Total',
    LabelElementType.data: 'Data',
    LabelElementType.hora: 'Hora',
    LabelElementType.validade: 'Validade',
    LabelElementType.codigoBarras: 'Código de Barras',
    LabelElementType.qrCode: 'QR Code',
    LabelElementType.textoLivre: 'Texto Livre',
    LabelElementType.logotipo: 'Logotipo',
    LabelElementType.linha: 'Linha',
    LabelElementType.retangulo: 'Retângulo',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
        children: _labels.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
            child: ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: Text(entry.value),
              onPressed: () => onAdd(entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LabelCanvas extends StatelessWidget {
  const _LabelCanvas({required this.state, required this.controller});

  final LabelEditorState state;
  final LabelEditorController controller;

  @override
  Widget build(BuildContext context) {
    const ppm = LabelEditorScreen.pixelsPerMm;
    final width = state.label.larguraMm * ppm;
    final height = state.label.alturaMm * ppm;
    final sample = LabelPlaceholderResolver.sampleData();
    final elements = state.label.elementos;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.divider, width: 2),
      ),
      child: Stack(
        children: [
          for (var i = 0; i < elements.length; i++)
            Positioned(
              left: elements[i].x * ppm,
              top: elements[i].y * ppm,
              width: elements[i].largura * ppm,
              height: elements[i].altura * ppm,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.selectElement(i),
                onPanUpdate: (details) {
                  if (state.selectedIndex != i) controller.selectElement(i);
                  controller.moveSelected(details.delta.dx / ppm, details.delta.dy / ppm);
                },
                child: LabelElementView(
                  element: elements[i],
                  sampleData: sample,
                  selected: state.selectedIndex == i,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PropertiesPanel extends StatelessWidget {
  const _PropertiesPanel({super.key, required this.element, required this.controller});

  final LabelElementModel element;
  final LabelEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _labelFor(element.tipo),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Remover elemento',
                icon: const Icon(Icons.delete_outline, color: AppColors.statusError),
                onPressed: controller.removeSelected,
              ),
            ],
          ),
          Row(
            children: [
              if (element.tipo != LabelElementType.linha &&
                  element.tipo != LabelElementType.retangulo &&
                  element.tipo != LabelElementType.logotipo &&
                  element.tipo != LabelElementType.qrCode &&
                  element.tipo != LabelElementType.codigoBarras) ...[
                const Text('Tamanho da fonte'),
                Expanded(
                  child: Slider(
                    value: element.fonteTamanho.clamp(4, 24),
                    min: 4,
                    max: 24,
                    divisions: 20,
                    label: element.fonteTamanho.round().toString(),
                    onChanged: (v) => controller.updateSelectedStyle(fonteTamanho: v),
                  ),
                ),
                const Text('Negrito'),
                Switch(
                  value: element.negrito,
                  onChanged: (v) => controller.updateSelectedStyle(negrito: v),
                ),
              ],
            ],
          ),
          if (element.tipo != LabelElementType.linha &&
              element.tipo != LabelElementType.retangulo) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: SegmentedButton<LabelTextAlign>(
                segments: const [
                  ButtonSegment(value: LabelTextAlign.left, icon: Icon(Icons.format_align_left)),
                  ButtonSegment(
                      value: LabelTextAlign.center, icon: Icon(Icons.format_align_center)),
                  ButtonSegment(
                      value: LabelTextAlign.right, icon: Icon(Icons.format_align_right)),
                ],
                selected: {element.alinhamento},
                onSelectionChanged: (v) => controller.updateSelectedStyle(alinhamento: v.first),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<double>(
              segments: const [
                ButtonSegment(value: 0, label: Text('0°')),
                ButtonSegment(value: 90, label: Text('90°')),
                ButtonSegment(value: 180, label: Text('180°')),
                ButtonSegment(value: 270, label: Text('270°')),
              ],
              selected: {element.rotacao},
              onSelectionChanged: (v) => controller.updateSelectedStyle(rotacao: v.first),
            ),
          ),
          if (element.tipo == LabelElementType.textoLivre)
            TextField(
              decoration: const InputDecoration(labelText: 'Conteúdo do texto'),
              controller: TextEditingController(text: element.conteudoLivre ?? ''),
              onChanged: (v) => controller.updateSelectedStyle(conteudoLivre: v),
            ),
        ],
      ),
    );
  }

  String _labelFor(LabelElementType tipo) => switch (tipo) {
        LabelElementType.produto => 'Produto',
        LabelElementType.codigo => 'Código',
        LabelElementType.plu => 'PLU',
        LabelElementType.peso => 'Peso',
        LabelElementType.precoKg => 'Preço/kg',
        LabelElementType.total => 'Total',
        LabelElementType.data => 'Data',
        LabelElementType.hora => 'Hora',
        LabelElementType.validade => 'Validade',
        LabelElementType.codigoBarras => 'Código de Barras',
        LabelElementType.qrCode => 'QR Code',
        LabelElementType.textoLivre => 'Texto Livre',
        LabelElementType.logotipo => 'Logotipo',
        LabelElementType.linha => 'Linha',
        LabelElementType.retangulo => 'Retângulo',
      };
}
