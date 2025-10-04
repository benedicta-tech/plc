enum PreacherRole {
  preacher,
  manager;

  @override
  String toString() {
    switch (this) {
      case PreacherRole.preacher:
        return 'Pregador';
      case PreacherRole.manager:
        return 'Coordenador';
    }
  }
}

class Preacher {
  final String id;
  final String name;
  final String phone;
  final String city;
  final List<PreacherRole> roles;
  final List<String> themes;

  Preacher({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.roles,
    required this.themes,
  });
}
