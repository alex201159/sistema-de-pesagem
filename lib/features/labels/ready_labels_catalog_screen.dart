import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;

import '../../core/errors/label_exception.dart';
import '../../core/theme/app_dimensions.dart';
import '../../services/labels/sfm_label_parser.dart';

const _assetsPrefix = 'assets/etiquetas_prontas/';

/// Catálogo dos modelos de etiqueta prontos empacotados com o app (pacote
/// "PACK ETIQUETAS MAX", ver `assets/etiquetas_prontas/`). O operador
/// escolhe um modelo, ele é convertido via [SfmLabelParser] e devolvido
/// para quem abriu esta tela (ver `label_settings_screen.dart`), que o
/// leva direto para o editor visual (Etapa 6) para ajustes finais.
class ReadyLabelsCatalogScreen extends StatefulWidget {
  const ReadyLabelsCatalogScreen({super.key});

  @override
  State<ReadyLabelsCatalogScreen> createState() => _ReadyLabelsCatalogScreenState();
}

class _ReadyLabelsCatalogScreenState extends State<ReadyLabelsCatalogScreen> {
  late final Future<Map<String, List<String>>> _groupsFuture = _loadGroups();

  Future<Map<String, List<String>>> _loadGroups() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest.listAssets().where((p) => p.startsWith(_assetsPrefix)).toList()
      ..sort();

    final groups = <String, List<String>>{};
    for (final path in paths) {
      final rest = path.substring(_assetsPrefix.length);
      final slash = rest.indexOf('/');
      if (slash == -1) continue;
      final pasta = rest.substring(0, slash);
      groups.putIfAbsent(pasta, () => []).add(path);
    }
    return groups;
  }

  Future<void> _import(String assetPath) async {
    try {
      final xml = await rootBundle.loadString(assetPath);
      final nome = assetPath.substring(assetPath.lastIndexOf('/') + 1).replaceAll('.sfm', '');
      final label = SfmLabelParser.parse(xml, nomeSugerido: nome);
      if (mounted) Navigator.of(context).pop(label);
    } on LabelParseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível importar este modelo: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modelos prontos')),
      body: FutureBuilder<Map<String, List<String>>>(
        future: _groupsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final groups = snapshot.data ?? const {};
          if (groups.isEmpty) {
            return const Center(child: Text('Nenhum modelo pronto disponível.'));
          }
          final pastas = groups.keys.toList()..sort();
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            children: [
              for (final pasta in pastas)
                Card(
                  margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                  child: ExpansionTile(
                    title: Text(pasta),
                    subtitle: Text('${groups[pasta]!.length} modelos'),
                    children: [
                      for (final path in groups[pasta]!)
                        ListTile(
                          title: Text(
                            path.substring(path.lastIndexOf('/') + 1).replaceAll('.sfm', ''),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _import(path),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
