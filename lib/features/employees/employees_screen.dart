import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_dimensions.dart';
import '../../data/models/employee_model.dart';
import '../../data/repositories/repository_providers.dart';

/// Cadastro de funcionários/atendentes comissionados, vinculados às
/// vendas por comanda na tela de pesagem (ver `WeighingScreen`, modo
/// de venda "Comanda").
class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(_allEmployeesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Funcionários')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        tooltip: 'Novo funcionário',
        child: const Icon(Icons.add),
      ),
      body: employeesAsync.when(
        data: (employees) {
          if (employees.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spaceLg),
                child: Text(
                  'Nenhum funcionário cadastrado.\nToque em "+" para cadastrar um atendente comissionado.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            itemCount: employees.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spaceSm),
            itemBuilder: (context, index) {
              final employee = employees[index];
              return _EmployeeCard(
                employee: employee,
                onTap: () => _openForm(context, employee: employee),
                onToggleAtivo: (ativo) =>
                    ref.read(employeeRepositoryProvider).setAtivo(employee.id!, ativo),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar funcionários: $error')),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {EmployeeModel? employee}) {
    return showDialog<void>(
      context: context,
      builder: (_) => _EmployeeFormDialog(employee: employee),
    );
  }
}

final _allEmployeesProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(employeeRepositoryProvider).watchAll();
});

class _EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggleAtivo;

  const _EmployeeCard({required this.employee, required this.onTap, required this.onToggleAtivo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(child: Icon(Icons.badge_outlined)),
        title: Text(employee.nome),
        subtitle: Text('Comissão: ${employee.percentualComissao.toStringAsFixed(2)}%'),
        trailing: Switch(
          value: employee.ativo,
          onChanged: onToggleAtivo,
        ),
      ),
    );
  }
}

class _EmployeeFormDialog extends ConsumerStatefulWidget {
  final EmployeeModel? employee;

  const _EmployeeFormDialog({this.employee});

  @override
  ConsumerState<_EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends ConsumerState<_EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _comissaoController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.employee?.nome ?? '');
    _comissaoController = TextEditingController(
      text: widget.employee == null || widget.employee!.percentualComissao == 0
          ? ''
          : widget.employee!.percentualComissao.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _comissaoController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final percentual =
          double.tryParse(_comissaoController.text.trim().replaceAll(',', '.')) ?? 0;
      final model = (widget.employee ?? EmployeeModel(nome: '', dataCriacao: DateTime.now()))
          .copyWith(nome: _nomeController.text.trim(), percentualComissao: percentual);
      await ref.read(employeeRepositoryProvider).upsert(model);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.employee == null ? 'Novo Funcionário' : 'Editar Funcionário'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            TextFormField(
              controller: _comissaoController,
              decoration: const InputDecoration(
                labelText: 'Comissão',
                suffixText: '%',
                helperText: 'Percentual pago ao funcionário sobre suas vendas',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('CANCELAR'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('SALVAR'),
        ),
      ],
    );
  }
}
