import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/import_model.dart';
import '../../services/import/import_preview.dart';
import 'import_controller.dart';
import 'import_history_screen.dart';

/// Tela de importação manual de produtos (ver escopo, item 5).
///
/// Fluxo: operador escolhe o arquivo -> app mostra um resumo
/// (novos/atualizados/com erro) -> operador confirma ou cancela.
class ImportScreen extends ConsumerWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importControllerProvider);
    final controller = ref.read(importControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Produtos'),
        actions: [
          IconButton(
            tooltip: 'Histórico de importações',
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ImportHistoryScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: _buildBody(context, state, controller),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ImportScreenState state, ImportController controller) {
    switch (state.status) {
      case ImportScreenStatus.idle:
        return _IdleView(onPick: controller.pickAndAnalyzeFile);
      case ImportScreenStatus.analyzing:
        return const Center(child: CircularProgressIndicator());
      case ImportScreenStatus.previewReady:
        return _PreviewView(
          preview: state.preview!,
          onCancel: controller.reset,
          onConfirm: controller.confirmImport,
        );
      case ImportScreenStatus.importing:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: AppDimensions.spaceMd),
              Text('Importando produtos...'),
            ],
          ),
        );
      case ImportScreenStatus.done:
        return _DoneView(result: state.result!, onNewImport: controller.reset);
      case ImportScreenStatus.error:
        return _ErrorView(message: state.errorMessage ?? 'Erro desconhecido.', onRetry: controller.reset);
    }
  }
}

class _IdleView extends StatelessWidget {
  final VoidCallback onPick;

  const _IdleView({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.file_open_outlined, size: 96, color: AppColors.primary),
          const SizedBox(height: AppDimensions.spaceLg),
          Text('Selecione o arquivo de produtos exportado pelo ERP.',
              style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
          const SizedBox(height: AppDimensions.spaceXl),
          SizedBox(
            width: 320,
            child: ElevatedButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.upload_file),
              label: const Text('IMPORTAR ARQUIVO'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewView extends StatelessWidget {
  final ImportPreview preview;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _PreviewView({required this.preview, required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Arquivo:', style: textTheme.bodySmall),
                Text(preview.arquivo, style: textTheme.headlineMedium),
                const SizedBox(height: AppDimensions.spaceLg),
                _CountRow(label: 'Produtos encontrados', value: preview.quantidadeLinhas),
                _CountRow(label: 'Novos', value: preview.novos, color: AppColors.statusOk),
                _CountRow(
                  label: 'Atualizados',
                  value: preview.atualizados,
                  color: AppColors.statusInfo,
                ),
                _CountRow(
                  label: 'Com erro',
                  value: preview.produtosComErro,
                  color: preview.temErros ? AppColors.statusError : null,
                ),
              ],
            ),
          ),
        ),
        if (preview.temErros) ...[
          const SizedBox(height: AppDimensions.spaceMd),
          Expanded(child: _ErrorList(errors: preview.erros)),
        ] else
          const Spacer(),
        const SizedBox(height: AppDimensions.spaceMd),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(onPressed: onCancel, child: const Text('CANCELAR')),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: ElevatedButton(onPressed: onConfirm, child: const Text('IMPORTAR')),
            ),
          ],
        ),
      ],
    );
  }
}

class _CountRow extends StatelessWidget {
  final String label;
  final int value;
  final Color? color;

  const _CountRow({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            '$value',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ErrorList extends StatelessWidget {
  final List<ImportLineError> errors;

  const _ErrorList({required this.errors});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceAlt,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        itemCount: errors.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (context, index) {
          final error = errors[index];
          return ListTile(
            dense: true,
            leading: const Icon(Icons.error_outline, color: AppColors.statusError),
            title: Text('Linha ${error.linha}'),
            subtitle: Text(error.motivo),
          );
        },
      ),
    );
  }
}

class _DoneView extends StatelessWidget {
  final ImportModel result;
  final VoidCallback onNewImport;

  const _DoneView({required this.result, required this.onNewImport});

  @override
  Widget build(BuildContext context) {
    final ok = result.status != ImportStatus.erro;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.error,
            size: 96,
            color: ok ? AppColors.statusOk : AppColors.statusError,
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text(result.status.label, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            '${result.produtosNovos} novos, ${result.produtosAtualizados} atualizados, '
            '${result.produtosComErro} com erro.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXl),
          SizedBox(
            width: 280,
            child: ElevatedButton(onPressed: onNewImport, child: const Text('NOVA IMPORTAÇÃO')),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 96, color: AppColors.statusError),
          const SizedBox(height: AppDimensions.spaceLg),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppDimensions.spaceXl),
          SizedBox(
            width: 280,
            child: ElevatedButton(onPressed: onRetry, child: const Text('TENTAR NOVAMENTE')),
          ),
        ],
      ),
    );
  }
}
