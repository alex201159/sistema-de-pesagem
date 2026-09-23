import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/label_element_model.dart';
import '../../data/models/label_model.dart';
import '../../data/repositories/label_repository.dart';
import '../../data/repositories/repository_providers.dart';

/// Tamanho/posição padrão de cada tipo de elemento ao ser adicionado
/// no editor (ver escopo, itens 22-24).
(double largura, double altura, double fonteTamanho) _defaultsFor(LabelElementType tipo) {
  return switch (tipo) {
    LabelElementType.codigoBarras => (50, 12, 8),
    LabelElementType.qrCode => (20, 20, 8),
    LabelElementType.logotipo => (20, 20, 8),
    LabelElementType.linha => (50, 1, 8),
    LabelElementType.retangulo => (30, 20, 8),
    LabelElementType.total => (56, 8, 12),
    _ => (40, 6, 8),
  };
}

class LabelEditorState {
  final LabelModel label;
  final int? selectedIndex;
  final bool saving;

  const LabelEditorState({required this.label, this.selectedIndex, this.saving = false});

  LabelElementModel? get selectedElement =>
      selectedIndex == null ? null : label.elementos[selectedIndex!];

  LabelEditorState copyWith({
    LabelModel? label,
    int? selectedIndex,
    bool clearSelection = false,
    bool? saving,
  }) {
    return LabelEditorState(
      label: label ?? this.label,
      selectedIndex: clearSelection ? null : (selectedIndex ?? this.selectedIndex),
      saving: saving ?? this.saving,
    );
  }
}

/// Controla o editor visual de etiquetas (ver escopo, itens 22-26):
/// adicionar/mover/redimensionar/remover elementos e persistir o
/// perfil via [LabelRepository].
class LabelEditorController extends StateNotifier<LabelEditorState> {
  LabelEditorController(this._repository, LabelModel initial)
      : super(LabelEditorState(label: initial));

  final LabelRepository _repository;

  void selectElement(int? index) {
    if (index == null) {
      state = state.copyWith(clearSelection: true);
    } else {
      state = state.copyWith(selectedIndex: index);
    }
  }

  void setLabelName(String nome) {
    state = state.copyWith(label: state.label.copyWith(nome: nome));
  }

  void setLabelSize({double? larguraMm, double? alturaMm}) {
    state = state.copyWith(
      label: state.label.copyWith(
        larguraMm: larguraMm?.clamp(10, 300).toDouble() ?? state.label.larguraMm,
        alturaMm: alturaMm?.clamp(10, 300).toDouble() ?? state.label.alturaMm,
      ),
    );
  }

  void addElement(LabelElementType tipo) {
    final (largura, altura, fonteTamanho) = _defaultsFor(tipo);
    final nextOrdem =
        state.label.elementos.fold<int>(0, (max, e) => e.ordem >= max ? e.ordem + 1 : max);
    final element = LabelElementModel(
      labelId: state.label.id ?? 0,
      tipo: tipo,
      x: 2,
      y: 2,
      largura: largura,
      altura: altura,
      fonteTamanho: fonteTamanho,
      ordem: nextOrdem,
      conteudoLivre: tipo == LabelElementType.textoLivre ? 'Texto' : null,
    );
    final elements = [...state.label.elementos, element];
    state = state.copyWith(
      label: state.label.copyWith(elementos: elements),
      selectedIndex: elements.length - 1,
    );
  }

  void moveSelected(double dxMm, double dyMm) {
    final index = state.selectedIndex;
    if (index == null) return;
    _updateElement(index, (e) {
      final maxX = (state.label.larguraMm - e.largura).clamp(0, state.label.larguraMm).toDouble();
      final maxY = (state.label.alturaMm - e.altura).clamp(0, state.label.alturaMm).toDouble();
      return e.copyWith(
        x: (e.x + dxMm).clamp(0, maxX).toDouble(),
        y: (e.y + dyMm).clamp(0, maxY).toDouble(),
      );
    });
  }

  void resizeSelected({double? largura, double? altura}) {
    final index = state.selectedIndex;
    if (index == null) return;
    _updateElement(
      index,
      (e) => e.copyWith(
        largura: largura?.clamp(2, state.label.larguraMm).toDouble() ?? e.largura,
        altura: altura?.clamp(2, state.label.alturaMm).toDouble() ?? e.altura,
      ),
    );
  }

  void updateSelectedStyle({
    double? fonteTamanho,
    bool? negrito,
    LabelTextAlign? alinhamento,
    double? rotacao,
    String? conteudoLivre,
  }) {
    final index = state.selectedIndex;
    if (index == null) return;
    _updateElement(
      index,
      (e) => e.copyWith(
        fonteTamanho: fonteTamanho ?? e.fonteTamanho,
        negrito: negrito ?? e.negrito,
        alinhamento: alinhamento ?? e.alinhamento,
        rotacao: rotacao ?? e.rotacao,
        conteudoLivre: conteudoLivre ?? e.conteudoLivre,
      ),
    );
  }

  void removeSelected() {
    final index = state.selectedIndex;
    if (index == null) return;
    final elements = [...state.label.elementos]..removeAt(index);
    state = state.copyWith(
      label: state.label.copyWith(elementos: elements),
      clearSelection: true,
    );
  }

  void _updateElement(int index, LabelElementModel Function(LabelElementModel) update) {
    final elements = [...state.label.elementos];
    elements[index] = update(elements[index]);
    state = state.copyWith(label: state.label.copyWith(elementos: elements));
  }

  /// Salva o perfil e o marca como padrão (usado na impressão) — sem
  /// isso, a etiqueta editada aqui não seria a que sai na impressora até
  /// o operador marcá-la manualmente como padrão na lista de perfis,
  /// uma armadilha de UX que já causou etiqueta errada sendo impressa.
  /// `LabelRepository.save` já desmarca qualquer outro perfil que
  /// estivesse marcado como padrão.
  Future<int> save() async {
    state = state.copyWith(saving: true);
    try {
      final now = DateTime.now();
      final id =
          await _repository.save(state.label.copyWith(dataAtualizacao: now, padrao: true));
      return id;
    } finally {
      state = state.copyWith(saving: false);
    }
  }
}

final labelEditorControllerProvider = StateNotifierProvider.autoDispose
    .family<LabelEditorController, LabelEditorState, LabelModel>((ref, initial) {
  return LabelEditorController(ref.watch(labelRepositoryProvider), initial);
});
