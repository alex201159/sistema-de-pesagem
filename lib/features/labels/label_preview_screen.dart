import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/label_model.dart';
import '../../services/printer/label_placeholder_resolver.dart';
import 'label_editor_screen.dart';
import 'widgets/label_element_view.dart';

/// Pré-visualização fiel de uma etiqueta antes de imprimir (ver
/// escopo, item 25), usando dados de exemplo e a mesma renderização
/// visual do editor — o que aparece aqui é o que sai na impressora.
class LabelPreviewScreen extends StatelessWidget {
  const LabelPreviewScreen({super.key, required this.label});

  final LabelModel label;

  @override
  Widget build(BuildContext context) {
    const ppm = LabelEditorScreen.pixelsPerMm;
    final sample = LabelPlaceholderResolver.sampleData();

    return Scaffold(
      appBar: AppBar(title: Text('Pré-visualização — ${label.nome}')),
      body: Center(
        child: Container(
          width: label.larguraMm * ppm,
          height: label.alturaMm * ppm,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.divider, width: 2),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Stack(
            children: [
              for (final element in label.elementos)
                Positioned(
                  left: element.x * ppm,
                  top: element.y * ppm,
                  width: element.largura * ppm,
                  height: element.altura * ppm,
                  child: LabelElementView(element: element, sampleData: sample),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
