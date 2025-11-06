abstract class EntityModel<T> {
  Map<String, dynamic> toJson();

  T toEntity();

  String get id;
}
