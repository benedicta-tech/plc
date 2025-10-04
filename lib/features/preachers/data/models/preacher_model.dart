import 'package:plc/features/preachers/domain/entities/preacher.dart';

class PreacherModel {
  final String id;
  final String name;
  final String phone;
  final String city;
  final List<String> roles;
  final List<String> themes;

  PreacherModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.roles,
    required this.themes,
  });

  /// Create PreacherModel from JSON
  factory PreacherModel.fromJson(Map<String, dynamic> json) {
    return PreacherModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String,
      roles: List<String>.from(json['roles'] as List),
      themes: List<String>.from(json['themes'] as List),
    );
  }

  /// Convert PreacherModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'city': city,
      'roles': roles,
      'themes': themes,
    };
  }

  /// Convert to domain entity
  Preacher toEntity() {
    return Preacher(
      id: id,
      name: name,
      phone: phone,
      city: city,
      roles: roles,
      themes: themes,
    );
  }

  /// Create from domain entity
  factory PreacherModel.fromEntity(Preacher preacher) {
    return PreacherModel(
      id: preacher.id,
      name: preacher.name,
      phone: preacher.phone,
      city: preacher.city,
      roles: preacher.roles,
      themes: preacher.themes,
    );
  }
}
