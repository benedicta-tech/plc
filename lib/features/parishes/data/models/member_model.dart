import 'package:plc/core/features/data/models/entity_model.dart';
import 'package:plc/features/parishes/domain/entities/member.dart';

class MemberModel extends EntityModel<Member> {
  static const defaultBranch = 'Masculino';

  final String name;
  final String role;
  final String branch;
  final String? encounter;

  MemberModel({
    required this.name,
    required this.role,
    required this.branch,
    this.encounter,
  });

  /// Nome sozinho não identifica a linha: quem é coordenador e pregador
  /// aparece duas vezes na mesma aba.
  @override
  String get id => '$name|$role';

  bool get isFounding => toEntity().isFounding;

  bool get isPriest => toEntity().isPriest;

  bool get isPreacher => toEntity().isPreacher;

  bool get isCoordination => toEntity().isCoordination;

  String get roleLabel => toEntity().roleLabel;

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    String texto(String coluna) => (json[coluna] as String?)?.trim() ?? '';
    final ramo = texto('Ramo');
    final encontro = texto('Encontro');

    return MemberModel(
      name: texto('Nome'),
      role: texto('Função'),
      branch: ramo.isNotEmpty ? ramo : defaultBranch,
      encounter: encontro.isNotEmpty ? encontro : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'Nome': name,
        'Função': role,
        'Ramo': branch,
        'Encontro': encounter,
      };

  @override
  Member toEntity() => Member(
        name: name,
        role: role,
        branch: branch,
        encounter: encounter,
      );
}
