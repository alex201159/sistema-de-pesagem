import 'package:flutter/material.dart';

/// Paleta de cores do aplicativo.
///
/// As cores de status seguem a semântica definida no escopo (item 41):
/// verde = conectado/correto, amarelo = atenção/instável,
/// vermelho = erro/desconectado, azul = ação/informação.
/// A cor nunca é o único indicador — sempre acompanhada de ícone/texto.
class AppColors {
  AppColors._();

  // Identidade
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF43A047);
  static const Color primaryDark = Color(0xFF0D3B10);
  static const Color accent = Color(0xFF2962FF);

  // Superfícies
  static const Color background = Color(0xFFF4F6F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFEFF3F1);

  // Texto
  static const Color textPrimary = Color(0xFF1A1D1B);
  static const Color textSecondary = Color(0xFF5B6B62);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status semântico
  static const Color statusOk = Color(0xFF2E7D32);
  static const Color statusWarning = Color(0xFFF9A825);
  static const Color statusError = Color(0xFFC62828);
  static const Color statusInfo = Color(0xFF1565C0);

  // Destaques operacionais (peso/total na tela principal)
  static const Color weightHighlight = Color(0xFF0D3B10);
  static const Color totalHighlight = Color(0xFF1B5E20);

  /// Fundo escurecido da tela de pesagem — dá mais destaque aos cards
  /// claros (peso, produto, totais) por cima, em vez do cinza claro
  /// padrão usado no resto do app. Escuro o suficiente pra contrastar,
  /// sem chegar perto do preto (o que deixa botões desabilitados do
  /// Material 3, que usam cinza translúcido sobre o fundo, invisíveis).
  static const Color weighingBackground = Color(0xFF24352C);
  static const Color weighingSectionLabel = Color(0xFFC3D2CA);

  /// Painéis sobre [weighingBackground] (teclado, preço/kg, produto
  /// ainda não escolhido) — um tom acima do fundo, sem virar card claro.
  static const Color weighingPanel = Color(0xFF2F443A);
  static const Color weighingPanelBorder = Color(0xFF3C5448);

  /// Visor do peso, no estilo do display de uma balança: fundo quase
  /// preto com dígitos verdes brilhantes.
  static const Color weighingDisplay = Color(0xFF111B16);
  static const Color weighingDisplayText = Color(0xFF9BF5AE);

  /// Variantes claras das cores de status, legíveis sobre fundo escuro
  /// (as de cima são pensadas para fundo claro).
  static const Color statusOkOnDark = Color(0xFF6FDB82);
  static const Color statusWarningOnDark = Color(0xFFFFCE54);
  static const Color statusErrorOnDark = Color(0xFFFF7A7A);
  static const Color statusInfoOnDark = Color(0xFF74B9FF);

  /// Botão principal da tela de pesagem (imprimir/registrar).
  static const Color weighingAction = Color(0xFF3FA34D);

  static const Color divider = Color(0xFFDDE3E0);
}
