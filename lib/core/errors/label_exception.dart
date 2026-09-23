import 'app_exception.dart';

/// Erro ao importar um modelo de etiqueta pronto (`.sfm`) para o editor
/// visual (ver [lib/services/labels/sfm_label_parser.dart]).
class LabelParseException extends AppException {
  const LabelParseException(super.message, {super.cause, super.stackTrace});
}
