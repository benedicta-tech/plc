import 'package:plc/core/storage/gsheets_storage_service.dart';
import 'package:plc/features/parishes/data/models/parish_model.dart';

abstract class ParishDataSource {
  Future<List<ParishModel>> getParishes();
}

class ParishRemoteDataSource implements ParishDataSource {
  final GSheetsStorageService gsheetsService;

  ParishRemoteDataSource({required this.gsheetsService});

  @override
  Future<List<ParishModel>> getParishes() async {
    final data = await gsheetsService.get('main', 'Paroquias');

    return data.where((row) {
      return row['Perseverança'] != null && row['Nome'] != null;
    }).map<ParishModel>((row) {
      var id = '${row['Nome']!}-${row['Local']!}';
      id = id.replaceAll(' ', "-").toLowerCase();

      return ParishModel(
        id: id,
        name: row['Nome'] ?? '',
        location: row['Local'] ?? '',
        perseverance: row['Perseverança'] ?? '',
        imageUrl: row['Imagem'] ?? '',
      );
    }).toList();
  }
}
