import 'package:plc/core/features/core_features.dart';
import 'package:plc/features/daily_reading/domain/entities/daily_reading.dart';

class DailyReadingModel extends EntityModel<DailyReading> {
  @override
  final String id;
  final DateTime date;
  final String title;
  final String color;
  final String details;
  final String readings;
  final String body;

  DailyReadingModel({
    required this.id,
    required this.date,
    required this.title,
    required this.color,
    required this.details,
    required this.readings,
    required this.body,
  });

  factory DailyReadingModel.fromJson(Map<String, dynamic> json) {
    final date = json['Data'] as String? ?? '';
    final identificacao = json['Identificacao'] as String? ?? '';

    return DailyReadingModel(
      id: identificacao.isNotEmpty ? identificacao : date,
      date: DateTime.parse(date),
      title: json['Tempo litugico'] as String? ?? '',
      color: json['Cor'] as String? ?? '',
      details: json['Detalhe'] as String? ?? '',
      readings: json['Leituras'] as String? ?? '',
      body: json['Corpo'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Data': date.toIso8601String(),
      'Identificacao': id,
      'Tempo litugico': title,
      'Cor': color,
      'Detalhe': details,
      'Leituras': readings,
      'Corpo': body,
    };
  }

  @override
  DailyReading toEntity() {
    return DailyReading(
      date: date,
      title: title,
      color: color,
      details: details,
      readings: readings,
      body: body,
    );
  }
}
