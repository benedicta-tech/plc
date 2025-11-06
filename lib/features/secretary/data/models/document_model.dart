import 'package:plc/core/features/core_features.dart';
import 'package:plc/features/secretary/domain/entities/document.dart';

class DocumentModel extends EntityModel<Document> {
  @override
  final String id;
  final String title;
  final String description;
  final String category;
  final String url;

  DocumentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.url,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['Identificação'] as String? ?? '',
      title: json['Nome'] as String? ?? '',
      description: json['Descrição'] as String? ?? '',
      category: json['Categoria'] as String? ?? '',
      url: json['URL'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Identificação': id,
      'Nome': title,
      'Descrição': description,
      'Categoria': category,
      'URL': url,
    };
  }

  @override
  Document toEntity() {
    return Document(
      id: id,
      title: title,
      description: description,
      category: category,
      url: url,
    );
  }
}
