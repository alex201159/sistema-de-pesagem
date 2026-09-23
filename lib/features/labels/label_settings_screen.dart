import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_dimensions.dart';
import '../../data/models/label_model.dart';
import '../../data/repositories/repository_providers.dart';
import 'label_editor_screen.dart';
import 'label_preview_screen.dart';
import 'ready_labels_catalog_screen.dart';

final _labelsListProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(labelRepositoryProvider).getAll();
});

/// Perfis de etiqueta (ver escopo, item 26): criar, editar, definir
/// como padrão e excluir layouts (ex.: "60x40 PADRÃO", "60x40 AÇOUGUE").
class LabelSettingsScreen extends ConsumerWidget {
  const LabelSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelsAsync = ref.watch(_labelsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Etiquetas'),
        actions: [
          IconButton(
            tooltip: 'Importar modelo pronto',
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => _importReadyLabel(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('NOVO PERFIL'),
        onPressed: () => _openEditor(context, ref, _blankLabel()),
      ),
      body: labelsAsync.when(
        data: (labels) {
          if (labels.isEmpty) {
            return const Center(child: Text('Nenhum perfil de etiqueta cadastrado ainda.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            itemCount: labels.length,
            itemBuilder: (context, index) {
              final label = labels[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                child: ListTile(
                  title: Text(label.nome),
                  subtitle: Text(
                    '${label.larguraMm.toStringAsFixed(0)}x${label.alturaMm.toStringAsFixed(0)}mm'
                    '${label.padrao ? ' · PADRÃO' : ''}',
                  ),
                  onTap: () => _openEditor(context, ref, label),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) => _handleAction(context, ref, label, action),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'preview', child: Text('Pré-visualizar')),
                      const PopupMenuItem(value: 'default', child: Text('Definir como padrão')),
                      const PopupMenuItem(value: 'delete', child: Text('Excluir')),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar etiquetas: $e')),
      ),
    );
  }

  LabelModel _blankLabel() {
    final now = DateTime.now();
    return LabelModel(
      nome: 'Nova etiqueta',
      larguraMm: 60,
      alturaMm: 40,
      dataCriacao: now,
      dataAtualizacao: now,
    );
  }

  Future<void> _openEditor(BuildContext context, WidgetRef ref, LabelModel label) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => LabelEditorScreen(initial: label)),
    );
    if (saved == true) ref.invalidate(_labelsListProvider);
  }

  Future<void> _importReadyLabel(BuildContext context, WidgetRef ref) async {
    final imported = await Navigator.of(context).push<LabelModel>(
      MaterialPageRoute(builder: (_) => const ReadyLabelsCatalogScreen()),
    );
    if (imported != null && context.mounted) {
      await _openEditor(context, ref, imported);
    }
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    LabelModel label,
    String action,
  ) async {
    final repo = ref.read(labelRepositoryProvider);
    switch (action) {
      case 'preview':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LabelPreviewScreen(label: label)),
        );
      case 'default':
        await repo.save(label.copyWith(padrao: true));
        ref.invalidate(_labelsListProvider);
      case 'delete':
        await repo.delete(label.id!);
        ref.invalidate(_labelsListProvider);
    }
  }
}
