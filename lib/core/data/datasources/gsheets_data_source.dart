import 'package:plc/core/storage/gsheets_storage_service.dart';

abstract class GSheetsDataSource {
  Future<List<Map<String, String>>> get(String sheetType, String worksheetName);
  Future<List<Map<String, dynamic>>> searchAcrossWorksheets(String sheetType, String searchTerm);
  Future<List<String>> getAvailableWorksheets(String sheetType);
}

class GSheetsDataSourceImpl implements GSheetsDataSource {
  final GSheetsStorageService gsheetsService;

  GSheetsDataSourceImpl({required this.gsheetsService});

  @override
  Future<List<Map<String, String>>> get(String sheetType, String worksheetName) {
    return gsheetsService.get(sheetType, worksheetName);
  }

  @override
  Future<List<Map<String, dynamic>>> searchAcrossWorksheets(String sheetType, String searchTerm) {
    return gsheetsService.searchAcrossWorksheets(sheetType, searchTerm);
  }

  @override
  Future<List<String>> getAvailableWorksheets(String sheetType) {
    return gsheetsService.getAvailableWorksheets(sheetType);
  }
}