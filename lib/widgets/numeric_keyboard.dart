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

  /// Teto absoluto de tamanho de tecla — mesmo numa janela de desktop
  /// enorme, uma tecla maior que isso deixaria de parecer um botão.
  static const _absoluteMaxKeySize = 150.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula o maior tamanho de tecla que cabe no espaço
        // disponível (3 colunas x 4 linhas, com o mesmo espaçamento
        // usado entre teclas) — cresce para preencher a coluna/área
        // disponível (ver escopo, adaptação para telas maiores de
        // desktop) em vez de ficar travado no tamanho pensado para
        // tablet. [keySize] só é usado como não há nenhuma dimensão
        // limitada para calcular a partir dela.
        // Cada tecla tem `Padding` de 8px na direção correspondente
        // (horizontal nas colunas, vertical nas linhas) — inclusive nas
        // pontas (não é só o espaço "entre" teclas) — por isso o total
        // consumido é `spacing * quantidade`, não `spacing * (quantidade - 1)`.
        const spacing = 8.0;
        final candidates = <double>[_absoluteMaxKeySize];
        if (constraints.hasBoundedWidth) {
          candidates.add((constraints.maxWidth - spacing * 3) / 3);
        }
        if (constraints.hasBoundedHeight) {
          candidates.add((constraints.maxHeight - spacing * 4) / 4);
        }
        if (!constraints.hasBoundedWidth && !constraints.hasBoundedHeight) {
          candidates.add(keySize);
        }
        final size = candidates.reduce(math.min).clamp(40.0, _absoluteMaxKeySize);

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _layout
              .map((row) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row.map((key) => _buildKey(context, key, size)).toList(),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildKey(BuildContext context, String key, double size) {
    final isClear = key == 'C';
    final isConfirm = key == 'OK';

    Color background = AppColors.surfaceAlt;
    Color foreground = AppColors.textPrimary;
    if (isClear) {
      background = AppColors.statusError.withValues(alpha: 0.12);
      foreground = AppColors.statusError;
    } else if (isConfirm) {
      background = AppColors.primary;
      foreground = AppColors.textOnPrimary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
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
            width: size,
            height: size,
            child: Center(
              child: Text(
                key,
                style: TextStyle(
                  fontSize: (size * 0.32).clamp(16.0, 30.0),
                  fontWeight: FontWeight.bold,
                  color: foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
