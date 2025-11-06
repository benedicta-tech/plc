import 'package:plc/core/features/data/models/entity_model.dart';
import 'package:plc/core/storage/gsheets_storage_service.dart';

abstract class GenericRemoteDataSource<M extends EntityModel> {
  Future<List<M>> getAll();
  Future<M> getById(String id);
}

class GenericGSheetsDataSource<M extends EntityModel>
    implements GenericRemoteDataSource<M> {
  final GSheetsStorageService gsheetsService;
  final String sheetType;
  final String worksheetName;
  final M Function(Map<String, dynamic>) fromJson;
  final List<M> Function(List<M>)? filterList;
  final List<M> Function(List<M>)? sortList;

  GenericGSheetsDataSource({
    required this.gsheetsService,
    required this.sheetType,
    required this.worksheetName,
    required this.fromJson,
    this.filterList,
    this.sortList,
  });

  @override
  Future<List<M>> getAll() async {
    try {
      final data = await gsheetsService.get(sheetType, worksheetName);

      var items = data.map((row) {
        final jsonMap = Map<String, dynamic>.from(row);
        return fromJson(jsonMap);
      }).toList();

      if (filterList != null) {
        items = filterList!(items);
      }

      if (sortList != null) {
        items = sortList!(items);
      }

      return items;
    } catch (e) {
      throw Exception('Failed to load data from Google Sheets: $e');
    }
  }

  @override
  Future<M> getById(String id) async {
    try {
      final items = await getAll();
      return items.firstWhere(
        (item) => item.id == id,
        orElse: () => throw Exception('Item with id $id not found'),
      );
    } catch (e) {
      throw Exception('Failed to get item by id: $e');
    }
  }
}
