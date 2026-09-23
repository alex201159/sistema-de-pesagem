import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_logger.dart';
import '../../data/models/audit_log_model.dart';
import '../../data/models/import_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../services/import/import_preview.dart';
import '../../services/import/import_providers.dart';
import '../../services/import/import_service.dart';

/// Etapa em que a tela de importação manual se encontra
/// (ver escopo, item 5).
enum ImportScreenStatus {
  idle,
  analyzing,
  previewReady,
  importing,
  done,
  error,
}

class ImportScreenState {
  final ImportScreenStatus status;
  final ImportPreview? preview;
  final ImportModel? result;
  final String? errorMessage;

  const ImportScreenState({
    this.status = ImportScreenStatus.idle,
    this.preview,
    this.result,
    this.errorMessage,
  });

  ImportScreenState copyWith({
    ImportScreenStatus? status,
    ImportPreview? preview,
    ImportModel? result,
    String? errorMessage,
  }) {
    return ImportScreenState(
      status: status ?? this.status,
      preview: preview ?? this.preview,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }
}

/// Controla o fluxo de importação manual: seleção de arquivo -> análise
/// (preview) -> confirmação -> gravação (ver escopo, item 5).
class ImportController extends StateNotifier<ImportScreenState> {
  final ImportService _service;
  final Ref _ref;

  ImportController(this._service, this._ref) : super(const ImportScreenState());

  Future<void> pickAndAnalyzeFile() async {
    try {
      final result = await FilePicker.pickFiles(type: FileType.any);
      final path = result?.files.single.path;
      if (path == null) return;
      await analyzeFile(File(path));
    } catch (e, st) {
      // Sem isso, uma falha nativa do seletor de arquivo (ex.: permissão
      // de sandbox ausente no macOS) ficava silenciosa — a tela voltava
      // para "idle" sem nenhum aviso, como se nada tivesse acontecido.
      AppLogger.e('Falha ao selecionar arquivo para importação', e, st);
      state = ImportScreenState(
        status: ImportScreenStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> analyzeFile(File file) async {
    state = state.copyWith(status: ImportScreenStatus.analyzing);
    try {
      final preview = await _service.analyze(file);
      state = ImportScreenState(
        status: ImportScreenStatus.previewReady,
        preview: preview,
      );
    } catch (e, st) {
      AppLogger.e('Falha ao analisar arquivo de importação', e, st);
      state = ImportScreenState(
        status: ImportScreenStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> confirmImport() async {
    final preview = state.preview;
    if (preview == null) return;

    state = state.copyWith(status: ImportScreenStatus.importing);
    try {
      final result = await _service.execute(preview);
      state = ImportScreenState(
        status: ImportScreenStatus.done,
        result: result,
      );
      await _ref
          .read(auditRepositoryProvider)
          .insert(
            AuditLogModel(
              dataHora: DateTime.now(),
              tipo: AuditEventType.arquivoImportado,
              descricao:
                  '${result.arquivo}: ${result.produtosNovos} novos, '
                  '${result.produtosAtualizados} atualizados, ${result.produtosComErro} com erro',
            ),
          );
    } catch (e, st) {
      AppLogger.e('Falha ao confirmar importação', e, st);
      state = ImportScreenState(
        status: ImportScreenStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const ImportScreenState();
  }
}

final importControllerProvider =
    StateNotifierProvider.autoDispose<ImportController, ImportScreenState>((
      ref,
    ) {
      return ImportController(ref.watch(importServiceProvider), ref);
    });
