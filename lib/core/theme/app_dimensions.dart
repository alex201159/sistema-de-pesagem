/// Dimensões e espaçamentos padronizados.
///
/// Pensado para uso em totem/tablet: elementos grandes, poucos por
/// tela, alto contraste (ver escopo item 40).
class AppDimensions {
  AppDimensions._();

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 14;
  static const double radiusLg = 20;

  /// Altura mínima recomendada para botões tocáveis em totem
  /// (bem acima do mínimo de acessibilidade de 48dp).
  static const double touchTargetHeight = 72;

  static const double buttonHeightLarge = 88;
  static const double buttonHeightPrimary = 96;

  static const double numericKeyboardKeySize = 84;

  // Tipografia operacional (tela de pesagem)
  static const double fontWeightDisplay = 72;
  static const double fontTotalDisplay = 56;
  static const double fontProductName = 32;
  static const double fontPriceLabel = 24;
  static const double fontBody = 18;
  static const double fontCaption = 14;

  static const double elevationCard = 2;
  static const double elevationDialog = 8;
}
