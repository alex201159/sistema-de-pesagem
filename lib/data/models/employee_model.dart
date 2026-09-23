/// Modelo de domínio de um funcionário/atendente comissionado.
///
/// Vinculado a vendas registradas por comanda (ver `SalesMode.comanda`
/// e `WeighingRepository.insertWithEmployees`) — uma mesma venda pode
/// ter mais de um funcionário vinculado.
class EmployeeModel {
  final int? id;
  final String nome;
  final double percentualComissao;
  final bool ativo;
  final DateTime dataCriacao;

  const EmployeeModel({
    this.id,
    required this.nome,
    this.percentualComissao = 0,
    this.ativo = true,
    required this.dataCriacao,
  });

  EmployeeModel copyWith({
    int? id,
    String? nome,
    double? percentualComissao,
    bool? ativo,
    DateTime? dataCriacao,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      percentualComissao: percentualComissao ?? this.percentualComissao,
      ativo: ativo ?? this.ativo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  @override
  String toString() => 'EmployeeModel(nome: $nome, comissao: $percentualComissao%)';
}
