import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repository_providers.dart';
import 'file_parser.dart';
import 'import_service.dart';
import 'import_validator.dart';
import 'itens_mgv_parser.dart';

/// Parser de arquivo ativo. Hoje um único formato (`ITENSMGV`); para
/// suportar outro ERP no futuro, basta trocar esta implementação ou
/// evoluir para uma lista de parsers com seleção automática via
/// `canParse` (ver escopo, item 54).
final productFileParserProvider = Provider<ProductFileParser>((ref) => ItensMgvParser());

final importValidatorProvider = Provider<ImportValidator>((ref) => ImportValidator());

final importServiceProvider = Provider<ImportService>((ref) {
  return ImportService(
    parser: ref.watch(productFileParserProvider),
    validator: ref.watch(importValidatorProvider),
    productRepository: ref.watch(productRepositoryProvider),
    historyRepository: ref.watch(historyRepositoryProvider),
  );
});
