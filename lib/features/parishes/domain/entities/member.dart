const _foundingSuffix = ' fundação';

/// Uma pessoa da paróquia com um papel. A mesma pessoa aparece em mais de uma
/// linha quando acumula papéis, por exemplo coordenador e pregador.
class Member {
  static const priestRole = 'Pároco';
  static const preacherRole = 'Palestrante';

  final String name;
  final String role;
  final String branch;
  final String? encounter;

  /// Pregações que a pessoa faz, dos 18 temas do cronograma diocesano.
  final List<String> lectures;

  Member({
    required this.name,
    required this.role,
    required this.branch,
    this.encounter,
    this.lectures = const [],
  });

  /// Funções de fundação carregam o sufixo na própria tag da planilha,
  /// como 'Coordenador fundação'. Sem sufixo é o papel vigente.
  bool get isFounding => role.endsWith(_foundingSuffix);

  String get roleLabel => isFounding
      ? role.substring(0, role.length - _foundingSuffix.length)
      : role;

  bool get isPriest => roleLabel == priestRole;

  /// Pregador é quem tem palestra na coluna Palestras. A função Palestrante
  /// ainda conta, para quem foi cadastrado antes da coluna existir.
  bool get isPreacher => lectures.isNotEmpty || roleLabel == preacherRole;

  bool get isCoordination =>
      !isPriest && roleLabel != preacherRole;
}
