import 'dart:async';
import 'package:gsheets/gsheets.dart';
import 'package:dio/dio.dart';
import 'package:plc/core/config/env.dart';

/// Google Sheets storage service for accessing app data from Google Sheets
/// This service handles all Google Sheets integration for the PLC app
class GSheetsStorageService {
  static String get _serviceAccount => Env.googleServiceAccount;

  static const String _mainSheetFinderUrl =
      "https://plc-app.leigo.fm/sheets.json";

  late final GSheets _gsheets;
  late final Dio _dio;

  Map<String, dynamic>? _sheetsConfig;

  final Map<String, Spreadsheet> _spreadsheetCache = {};

  GSheetsStorageService() {
    _gsheets = GSheets(_serviceAccount);
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      followRedirects: true,
      maxRedirects: 5,
      headers: {
        'User-Agent': 'PLC-Flutter-App/1.0',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
      },
      validateStatus: (status) => status != null && status < 400,
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  // TODO: Implement local caching of the sheets configuration and data
  Future<void> initialize() async {
    try {
      final response = await _dio.get(
        _mainSheetFinderUrl,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        _sheetsConfig = response.data;
        // TODO: save to local cache
      } else {
        // TODO: get from local cache if available
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'HTTP ${response.statusCode}: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Failed to initialize GSheetsStorageService: $e');
    }
  }

  /// Get the sheets configuration
  Map<String, dynamic> get sheetsConfig {
    if (_sheetsConfig == null) {
      throw StateError(
          'GSheetsStorageService not initialized. Call initialize() first.');
    }
    return _sheetsConfig!;
  }

  Future<Spreadsheet> _getSpreadsheet(String sheetType) async {
    final config = sheetsConfig['sheets'][sheetType];
    if (config == null) {
      throw ArgumentError('Sheet type "$sheetType" not found in configuration');
    }

    final spreadsheetId = config['id'] as String;

    if (_spreadsheetCache.containsKey(spreadsheetId)) {
      return _spreadsheetCache[spreadsheetId]!;
    }

    final spreadsheet = await _gsheets.spreadsheet(spreadsheetId);
    _spreadsheetCache[spreadsheetId] = spreadsheet;

    return spreadsheet;
  }

  Future<Worksheet?> _getWorksheet(
      String sheetType, String worksheetName) async {
    final spreadsheet = await _getSpreadsheet(sheetType);
    return spreadsheet.worksheetByTitle(worksheetName);
  }

  /// Get all available worksheets for a specific sheet type
  Future<List<String>> getAvailableWorksheets(String sheetType) async {
    final config = sheetsConfig['sheets'][sheetType];
    if (config == null) {
      throw ArgumentError('Sheet type "$sheetType" not found in configuration');
    }

    return List<String>.from(config['worksheets'] ?? []);
  }

  Future<List<List<String>>> readWorksheetData(
      String sheetType, String worksheetName) async {
    final worksheet = await _getWorksheet(sheetType, worksheetName);
    if (worksheet == null) {
      throw ArgumentError(
          'Worksheet "$worksheetName" not found in "$sheetType" sheet');
    }

    final values = await worksheet.values.allRows();
    return values
        .map((row) => row.map((cell) => cell.toString()).toList())
        .toList();
  }

  /// Read data from a specific range in a worksheet
  Future<List<List<String>>> readWorksheetRange(
      String sheetType, String worksheetName, String range) async {
    final worksheet = await _getWorksheet(sheetType, worksheetName);
    if (worksheet == null) {
      throw ArgumentError(
          'Worksheet "$worksheetName" not found in "$sheetType" sheet');
    }

    final values = await worksheet.values.allRows(fromRow: 1);
    return values
        .map((row) => row.map((cell) => cell.toString()).toList())
        .toList();
  }

  Future<List<Map<String, String>>> get(
      String sheetType, String worksheetName) async {
    final rows = await readWorksheetData(sheetType, worksheetName);

    if (rows.isEmpty) {
      return [];
    }

    final headers = rows.first;
    final dataRows = rows.skip(1);

    return dataRows.map((row) {
      final Map<String, String> rowMap = {};
      for (int i = 0; i < headers.length && i < row.length; i++) {
        rowMap[headers[i]] = row[i];
      }
      return rowMap;
    }).toList();
  }

  /// Search for data across all worksheets of a specific sheet type
  Future<List<Map<String, dynamic>>> searchAcrossWorksheets(
      String sheetType, String searchTerm) async {
    final worksheets = await getAvailableWorksheets(sheetType);
    final results = <Map<String, dynamic>>[];

    for (final worksheetName in worksheets) {
      try {
        final data = await get(sheetType, worksheetName);

        for (final row in data) {
          final hasMatch = row.values.any((value) =>
              value.toLowerCase().contains(searchTerm.toLowerCase()));

          if (hasMatch) {
            results.add({
              'worksheet': worksheetName,
              'data': row,
            });
          }
        }
      } catch (e) {
        // Continue with other worksheets if one fails
        continue;
      }
    }

    return results;
  }

  /// Clear cached spreadsheets (useful for testing or forced refresh)
  void clearCache() {
    _spreadsheetCache.clear();
    _sheetsConfig = null;
  }

  /// Validate if all required sheets are accessible
  Future<Map<String, bool>> validateSheetsAccess() async {
    final validation = <String, bool>{};

    for (final sheetType in ['main', 'notifications', 'secretary']) {
      try {
        await _getSpreadsheet(sheetType);
        validation[sheetType] = true;
      } catch (e) {
        validation[sheetType] = false;
      }
    }

    return validation;
  }

  /// Get service health status
  Future<Map<String, dynamic>> getHealthStatus() async {
    try {
      // Test configuration fetch
      if (_sheetsConfig == null) {
        await initialize();
      }

      // Test sheets access
      final validation = await validateSheetsAccess();

      return {
        'status': 'healthy',
        'configLoaded': _sheetsConfig != null,
        'configSource': 'remote',
        'sheetsAccess': validation,
        'cachedSpreadsheets': _spreadsheetCache.length,
      };
    } catch (e) {
      return {
        'status': 'unhealthy',
        'error': e.toString(),
        'configLoaded': _sheetsConfig != null,
        'configSource': _sheetsConfig != null ? 'remote' : 'none',
        'cachedSpreadsheets': _spreadsheetCache.length,
      };
    }
  }

  /// Test basic connectivity to the endpoint
  Future<bool> testConnectivity() async {
    try {
      final response = await _dio.get(
        _mainSheetFinderUrl,
        options: Options(
          headers: {'Cache-Control': 'no-cache'},
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
