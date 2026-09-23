import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';

/// Teclado numérico virtual para totem (ver escopo, item 15).
///
/// Não depende do teclado padrão do Android — botões grandes, fáceis
/// de tocar mesmo com o dedo, adequados para uso em pé em um balcão.
class NumericKeyboard extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onClear;
  final VoidCallback onConfirm;

  /// Tamanho máximo de cada tecla. O teclado sempre tenta esticar para
  /// ocupar a largura/altura disponíveis no espaço em que foi colocado
  /// (ver escopo, adaptação para telas maiores de desktop); este valor
  /// só entra como teto para não deixar as teclas enormes quando o
  /// espaço disponível é muito maior que o necessário.
  final double keySize;

  const NumericKeyboard({
    super.key,
    required this.onDigit,
    required this.onClear,
    required this.onConfirm,
    this.keySize = AppDimensions.numericKeyboardKeySize,
  });

  static const _layout = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['C', '0', 'OK'],
  ];

  /// Tetos de tamanho de tecla — mesmo numa janela de desktop enorme,
  /// uma tecla maior que isso deixaria de parecer um botão.
  static const _maxKeyWidth = 300.0;
  static const _maxKeyHeight = 190.0;
  static const _spacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // As teclas esticam para preencher a largura/altura disponíveis
        // (ver escopo, adaptação para telas maiores de desktop), sem
        // precisar ser quadradas — largura e altura são calculadas
        // separadamente. [keySize] só entra na direção sem limite (ex.:
        // dentro de uma rolagem vertical).
        final width = constraints.hasBoundedWidth
            ? (constraints.maxWidth - _spacing * 2) / 3
            : keySize;
        final height = constraints.hasBoundedHeight
            ? (constraints.maxHeight - _spacing * 3) / 4
            : keySize;
        final keyWidth = width.clamp(48.0, _maxKeyWidth);
        final keyHeight = height.clamp(48.0, _maxKeyHeight);

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var r = 0; r < _layout.length; r++) ...[
              if (r > 0) const SizedBox(height: _spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var c = 0; c < _layout[r].length; c++) ...[
                    if (c > 0) const SizedBox(width: _spacing),
                    _buildKey(context, _layout[r][c], keyWidth, keyHeight),
                  ],
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildKey(
    BuildContext context,
    String key,
    double width,
    double height,
  ) {
    final isClear = key == 'C';
    final isConfirm = key == 'OK';

    Color background = AppColors.surface;
    Color foreground = AppColors.textPrimary;
    if (isClear) {
      // Cor sólida: translúcida, sumia sobre o fundo escuro da pesagem.
      background = const Color(0xFFFBE4E4);
      foreground = AppColors.statusError;
    } else if (isConfirm) {
      background = AppColors.primaryLight;
      foreground = AppColors.textOnPrimary;
    }

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        onTap: () {
          if (isClear) {
            onClear();
          } else if (isConfirm) {
            onConfirm();
          } else {
            onDigit(key);
          }
        },
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Text(
              key,
              style: TextStyle(
                fontSize: (math.min(width, height) * 0.36).clamp(18.0, 40.0),
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
