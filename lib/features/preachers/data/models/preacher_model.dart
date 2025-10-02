import 'package:plc/features/preachers/domain/entities/preacher.dart';

class PreacherModel {
  final int id;
  final String fullName;
  final String phone;
  final String city;
  final String state;

  PreacherModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.state,
  });

  /// Create PreacherModel from JSON
  factory PreacherModel.fromJson(Map<String, dynamic> json) {
    return PreacherModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
    );
  }

  /// Convert PreacherModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'city': city,
      'state': state,
    };
  }

  /// Convert to domain entity
  Preacher toEntity() {
    return Preacher(
      id: id,
      fullName: fullName,
      phone: phone,
      city: city,
      state: state,
    );
  }

  /// Create from domain entity
  factory PreacherModel.fromEntity(Preacher preacher) {
    return PreacherModel(
      id: preacher.id,
      fullName: preacher.fullName,
      phone: preacher.phone,
      city: preacher.city,
      state: preacher.state,
    );
  }
}
