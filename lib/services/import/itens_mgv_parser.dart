import '../../core/utils/file_utils.dart';
import '../../data/models/import_model.dart';
import 'file_parser.dart';

/// Parser do arquivo `ITENSMGV.txt`, exportado pelo ERP do cliente
/// (Toledo do Brasil MGV6 — layout oficial documentado em
/// help.toledobrasil.com/mgv6, arquivo de cadastro de itens).
///
/// Layout de largura fixa, ASCII, sem cabeçalho/rodapé, uma linha por
/// produto:
///
/// ```text
/// posição   tamanho  campo
/// 1-2       2        departamento/seção do ERP (ex.: "00", "01")
/// 3         1        tipo de venda: '0' peso, '1' unidade, '2' EAN-13
///                     por peso, '3' peso glaciado, '4' peso drenado,
///                     '5' EAN-13 por unidade (só '0' e '1' aparecem na
///                     amostra real analisada)
/// 4-9       6        código/PLU do produto (numérico, com zeros à esquerda)
/// 10-15     6        preço em centavos (2 casas decimais implícitas)
/// 16-18     3        validade em dias (000/998/999 = sem validade fixa,
///                     ver [_decodeValidadeDias]; sempre "000" na amostra
///                     analisada, mas o campo é real — ver documentação
///                     oficial do Toledo MGV6)
/// 19..N     variável descrição (duas linhas de 25 chars no layout
///                    oficial — D1+D2 —, tratadas aqui como um único
///                    campo de 50 chars, padded com espaços à direita)
/// últimos 92 chars   demais campos do layout oficial (fornecedor, lote,
///                    EAN do fornecedor, validade/data de embalagem
///                    etc.) — não usados por este app, tratados como
///                    bloco opaco.
/// ```
///
/// IMPORTANTE: o comprimento total da linha NÃO é constante (257/262
/// linhas da amostra têm 160 caracteres, 5 têm 161 por uma
/// inconsistência do próprio exportador — uma descrição com um espaço
/// extra). Por isso o parser ancora os campos fixos a partir do
/// INÍCIO (prefixo de 18 chars) e do FIM da linha (bloco de 92 chars),
/// deixando a descrição com tamanho variável no meio. Isso torna o
/// parser tolerante a essa variação real de produção sem precisar
/// "consertar" o arquivo do cliente.
///
/// O arquivo não contém código de barras — o código de barras é
/// montado pelo app (ver `services/barcode/`), nunca importado.
class ItensMgvParser implements ProductFileParser {
  static const int prefixLength = 18;
  static const int tailLength = 92;
  static const int minLineLength = prefixLength + tailLength;

  /// Posição, dentro do prefixo de 18 caracteres, do byte "tipo de
  /// venda" (ver documentação da classe e do layout oficial MGV6).
  static const int saleTypeIndex = 2;

  static const String _saleTypeUnidade = '1';
  static const String _saleTypeEan13Unidade = '5';

  static final RegExp _prefixPattern = RegExp(r'^\d{18}$');

  /// Converte o campo VVV (3 dígitos, posições 16-18 do prefixo) em
  /// dias de validade — `null` quando o layout oficial define um
  /// significado especial sem dias fixos: `000` (sem validade),
  /// `998` (sem impressão de nenhuma data) e `999` (validade digitada
  /// na balança no momento da venda, não conhecida na importação).
  /// Valores fora da faixa documentada (`001` a `990`) também viram
  /// `null`, por segurança.
  static int? _decodeValidadeDias(String vvv) {
    final dias = int.parse(vvv);
    if (dias < 1 || dias > 990) return null;
    return dias;
  }

  @override
  String get formatName => 'ITENSMGV';

  @override
  bool canParse(String fileName, List<int> bytes) {
    final upperName = fileName.toUpperCase();
    if (upperName.contains('ITENSMGV')) return true;

    final text = FileUtils.decodeText(bytes);
    final firstDataLine = text
        .split(RegExp(r'\r?\n'))
        .firstWhere((line) => line.trim().isNotEmpty, orElse: () => '');
    return _looksLikeValidLine(firstDataLine);
  }

  bool _looksLikeValidLine(String line) {
    if (line.length < minLineLength) return false;
    return _prefixPattern.hasMatch(line.substring(0, prefixLength));
  }

  @override
  FileParseResult parse(String fileName, List<int> bytes) {
    final text = FileUtils.decodeText(bytes);
    final lines = text.split(RegExp(r'\r?\n'));

    final rows = <ParsedProductRow>[];
    final errors = <ImportLineError>[];
    final seenCodes = <String>{};

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = i + 1;

      if (line.trim().isEmpty) continue;

      if (line.length < minLineLength) {
        errors.add(ImportLineError(
          linha: lineNumber,
          motivo:
              'Linha com ${line.length} caracteres, menor que o mínimo esperado ($minLineLength).',
          conteudo: line,
        ));
        continue;
      }

      final prefix = line.substring(0, prefixLength);
      if (!_prefixPattern.hasMatch(prefix)) {
        errors.add(ImportLineError(
          linha: lineNumber,
          motivo: 'Prefixo (18 primeiros caracteres) não é numérico: "$prefix".',
          conteudo: line,
        ));
        continue;
      }

      final departamento = prefix.substring(0, 2);
      final saleType = prefix[saleTypeIndex];
      final codigoRaw = prefix.substring(3, 9);
      final precoRaw = prefix.substring(9, 15);
      final validadeDias = _decodeValidadeDias(prefix.substring(15, 18));

      final codigo = int.parse(codigoRaw).toString();
      if (codigo == '0') {
        errors.add(ImportLineError(
          linha: lineNumber,
          motivo: 'Código do produto é zero.',
          conteudo: line,
        ));
        continue;
      }

      final precoCentavos = int.parse(precoRaw);
      final preco = precoCentavos / 100.0;
      if (preco <= 0) {
        errors.add(ImportLineError(
          linha: lineNumber,
          motivo: 'Preço inválido (zero ou negativo): "$precoRaw".',
          conteudo: line,
        ));
        continue;
      }

      final descricao = line.substring(prefixLength, line.length - tailLength).trim();
      if (descricao.isEmpty) {
        errors.add(ImportLineError(
          linha: lineNumber,
          motivo: 'Descrição vazia.',
          conteudo: line,
        ));
        continue;
      }

      if (!seenCodes.add(codigo)) {
        errors.add(ImportLineError(
          linha: lineNumber,
          motivo: 'Código "$codigo" duplicado no arquivo (mantida a primeira ocorrência).',
          conteudo: line,
        ));
        continue;
      }

      final porUnidade = saleType == _saleTypeUnidade || saleType == _saleTypeEan13Unidade;

      rows.add(ParsedProductRow(
        lineNumber: lineNumber,
        rawLine: line,
        departamento: departamento,
        codigo: codigo,
        preco: preco,
        descricao: descricao,
        porUnidade: porUnidade,
        validadeDias: validadeDias,
      ));
    }

    return FileParseResult(rows: rows, errors: errors);
  }
}
