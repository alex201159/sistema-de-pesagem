import 'dart:math' as math;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/label_element_model.dart';
import '../../../services/printer/label_placeholder_resolver.dart';
import '../../../services/printer/printer_service.dart';

/// Renderiza o conteúdo de um único [LabelElementModel] — texto
/// resolvido, código de barras/QR, linha, retângulo etc. O chamador é
/// responsável por posicionar esta caixa no canvas (via `Positioned`
/// com `width`/`height` já convertidos para pixels), permitindo que o
/// editor visual (`label_editor_screen.dart`, com gesto de arraste por
/// cima) e a pré-visualização (`label_preview_screen.dart`, somente
/// leitura) reaproveitem exatamente o mesmo desenho (ver escopo, item
/// 25 — preview fiel ao que sai na impressora).
class LabelElementView extends StatelessWidget {
  const LabelElementView({
    super.key,
    required this.element,
    required this.sampleData,
    this.selected = false,
  });

  final LabelElementModel element;
  final LabelPrintData sampleData;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: element.rotacao * math.pi / 180,
      child: Container(
        decoration: selected
            ? BoxDecoration(border: Border.all(color: AppColors.accent, width: 2))
            : null,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    switch (element.tipo) {
      case LabelElementType.linha:
        return Container(color: AppColors.textPrimary);

      case LabelElementType.retangulo:
        return Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.textPrimary, width: 1.5)),
        );

      case LabelElementType.logotipo:
        return Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.divider)),
          child: const Center(
            child: Icon(Icons.image_outlined, color: AppColors.textSecondary),
          ),
        );

      case LabelElementType.codigoBarras:
        if (sampleData.codigoBarras.isEmpty) return const SizedBox.shrink();
        return BarcodeWidget(
          barcode: Barcode.code128(),
          data: sampleData.codigoBarras,
          drawText: false,
          color: AppColors.textPrimary,
        );

      case LabelElementType.qrCode:
        if (sampleData.codigoBarras.isEmpty) return const SizedBox.shrink();
        return BarcodeWidget(
          barcode: Barcode.qrCode(),
          data: sampleData.codigoBarras,
          color: AppColors.textPrimary,
        );

      default:
        final text = LabelPlaceholderResolver.resolve(element, sampleData);
        if (text.isEmpty) return const SizedBox.shrink();
        return Align(
          alignment: _alignmentFor(element.alinhamento),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: _textAlignFor(element.alinhamento),
              style: TextStyle(
                fontSize: element.fonteTamanho,
                fontWeight: element.negrito ? FontWeight.bold : FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
    }
  }

  Alignment _alignmentFor(LabelTextAlign align) => switch (align) {
        LabelTextAlign.left => Alignment.centerLeft,
        LabelTextAlign.center => Alignment.center,
        LabelTextAlign.right => Alignment.centerRight,
      };

  TextAlign _textAlignFor(LabelTextAlign align) => switch (align) {
        LabelTextAlign.left => TextAlign.left,
        LabelTextAlign.center => TextAlign.center,
        LabelTextAlign.right => TextAlign.right,
      };
}
