class Parish {
  final String id;
  final String name;
  final String location;
  final String perseverance;
  final String? imageUrl;

  Parish({
    required this.id,
    required this.name,
    required this.location,
    required this.perseverance,
    this.imageUrl,
  });

  String get fullName => '$location - $name';
}
