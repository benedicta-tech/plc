import 'package:plc/core/features/data/models/entity_model.dart';
import 'package:plc/features/about/domain/entities/about_screen_section.dart';

class AboutScreenSectionModel extends EntityModel<AboutScreenSection> {
  @override
  final String id;
  final String title;
  final String content;
  final String icon;
  final int order;

  AboutScreenSectionModel({
    required this.id,
    required this.title,
    required this.content,
    required this.icon,
    required this.order,
  });

  factory AboutScreenSectionModel.fromJson(Map<String, dynamic> json) {
    return AboutScreenSectionModel(
      id: json['Identificação'] as String? ?? '',
      title: json['Titulo'] as String? ?? '',
      content: json['Conteudo'] as String? ?? '',
      icon: json['Icone'] as String? ?? '',
      order: int.tryParse(json['Ordem'].toString()) ?? 999,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Identificação': id,
      'Titulo': title,
      'Conteudo': content,
      'Icone': icon,
      'Ordem': order,
    };
  }

  @override
  AboutScreenSection toEntity() {
    return AboutScreenSection(
      id: id,
      title: title,
      content: content,
      icon: icon,
      order: order,
    );
  }
}
