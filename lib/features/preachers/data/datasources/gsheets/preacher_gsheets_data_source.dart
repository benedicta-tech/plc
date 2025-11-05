import 'package:plc/core/data/datasources/gsheets_data_source.dart';

/// Google Sheets data source for preacher data
/// This data source fetches preacher information from Google Sheets
class PreacherGSheetsDataSource {
  final GSheetsDataSource _gsheetsDataSource;

  PreacherGSheetsDataSource(
      {required GSheetsDataSource gsheetsDataSource,
      required Object gsheetsService})
      : _gsheetsDataSource = gsheetsDataSource;

  /// Get all preachers from Google Sheets
  Future<List<Map<String, dynamic>>> getPreachers() async {
    try {
      // Find a worksheet that contains member data
      final worksheets =
          await _gsheetsDataSource.getAvailableWorksheets('main');
      for (final worksheetName in worksheets) {
        if (worksheetName.toLowerCase().contains('membros')) {
          final preachers = await _gsheetsDataSource.get('main', worksheetName);
          // Convert string map to dynamic map and normalize data
          return preachers.map((preacher) {
            final normalizedPreacher = <String, dynamic>{};

            // Map common field names
            preacher.forEach((key, value) {
              final lowerKey = key.toLowerCase();

              // Map various possible column names to standard fields
              if (lowerKey.contains('nome') || lowerKey.contains('name')) {
                normalizedPreacher['name'] = value;
              } else if (lowerKey.contains('telefone') ||
                  lowerKey.contains('phone') ||
                  lowerKey.contains('tel')) {
                normalizedPreacher['phone'] = value;
              } else if (lowerKey.contains('cidade') ||
                  lowerKey.contains('city')) {
                normalizedPreacher['city'] = value;
              } else if (lowerKey.contains('email')) {
                normalizedPreacher['email'] = value;
              } else if (lowerKey.contains('função') ||
                  lowerKey.contains('funcao') ||
                  lowerKey.contains('role')) {
                normalizedPreacher['role'] = value;
              } else if (lowerKey.contains('paroquia') ||
                  lowerKey.contains('parish')) {
                normalizedPreacher['parish'] = value;
              } else if (lowerKey.contains('status')) {
                normalizedPreacher['status'] = value;
              } else {
                // Keep original field name if no mapping found
                normalizedPreacher[key] = value;
              }
            });

            // Ensure required fields exist
            normalizedPreacher['id'] ??=
                normalizedPreacher['name']?.hashCode ?? 0;
            normalizedPreacher['name'] ??= 'Nome não informado';

            return normalizedPreacher;
          }).toList();
        }
      }

      throw StateError('No members worksheet found in main sheet');
    } catch (e) {
      throw Exception('Failed to fetch preachers from Google Sheets: $e');
    }
  }

  /// Get preachers from a specific parish
  Future<List<Map<String, dynamic>>> getPreachersByParish(
      String parishName) async {
    try {
      final worksheets =
          await _gsheetsDataSource.getAvailableWorksheets('main');

      for (final worksheetName in worksheets) {
        if (worksheetName.toLowerCase().contains('membros') &&
            worksheetName.toLowerCase().contains(parishName.toLowerCase())) {
          final preachers = await _gsheetsDataSource.get('main', worksheetName);

          // Apply the same normalization as getPreachers
          return preachers.map((preacher) {
            final normalizedPreacher = <String, dynamic>{};

            preacher.forEach((key, value) {
              final lowerKey = key.toLowerCase();

              if (lowerKey.contains('nome') || lowerKey.contains('name')) {
                normalizedPreacher['name'] = value;
              } else if (lowerKey.contains('telefone') ||
                  lowerKey.contains('phone') ||
                  lowerKey.contains('tel')) {
                normalizedPreacher['phone'] = value;
              } else if (lowerKey.contains('cidade') ||
                  lowerKey.contains('city')) {
                normalizedPreacher['city'] = value;
              } else if (lowerKey.contains('email')) {
                normalizedPreacher['email'] = value;
              } else if (lowerKey.contains('função') ||
                  lowerKey.contains('funcao') ||
                  lowerKey.contains('role')) {
                normalizedPreacher['role'] = value;
              } else if (lowerKey.contains('paroquia') ||
                  lowerKey.contains('parish')) {
                normalizedPreacher['parish'] = value;
              } else if (lowerKey.contains('status')) {
                normalizedPreacher['status'] = value;
              } else {
                normalizedPreacher[key] = value;
              }
            });

            normalizedPreacher['id'] ??=
                normalizedPreacher['name']?.hashCode ?? 0;
            normalizedPreacher['name'] ??= 'Nome não informado';
            normalizedPreacher['parish'] = parishName; // Ensure parish is set

            return normalizedPreacher;
          }).toList();
        }
      }

      return [];
    } catch (e) {
      throw Exception(
          'Failed to fetch preachers from parish "$parishName": $e');
    }
  }

  /// Search for preachers by name or other criteria
  Future<List<Map<String, dynamic>>> searchPreachers(String searchTerm) async {
    try {
      final results =
          await _gsheetsDataSource.searchAcrossWorksheets('main', searchTerm);

      // Filter results to only include member worksheets and normalize data
      final preacherResults = <Map<String, dynamic>>[];

      for (final result in results) {
        final worksheetName = result['worksheet'] as String;

        // Only include worksheets that contain member data
        if (worksheetName.toLowerCase().contains('membros') ||
            worksheetName.toLowerCase().contains('members')) {
          final data = result['data'] as Map<String, String>;
          final normalizedPreacher = <String, dynamic>{};

          // Apply normalization
          data.forEach((key, value) {
            final lowerKey = key.toLowerCase();

            if (lowerKey.contains('nome') || lowerKey.contains('name')) {
              normalizedPreacher['name'] = value;
            } else if (lowerKey.contains('telefone') ||
                lowerKey.contains('phone') ||
                lowerKey.contains('tel')) {
              normalizedPreacher['phone'] = value;
            } else if (lowerKey.contains('cidade') ||
                lowerKey.contains('city')) {
              normalizedPreacher['city'] = value;
            } else if (lowerKey.contains('email')) {
              normalizedPreacher['email'] = value;
            } else if (lowerKey.contains('função') ||
                lowerKey.contains('funcao') ||
                lowerKey.contains('role')) {
              normalizedPreacher['role'] = value;
            } else if (lowerKey.contains('paroquia') ||
                lowerKey.contains('parish')) {
              normalizedPreacher['parish'] = value;
            } else if (lowerKey.contains('status')) {
              normalizedPreacher['status'] = value;
            } else {
              normalizedPreacher[key] = value;
            }
          });

          normalizedPreacher['id'] ??=
              normalizedPreacher['name']?.hashCode ?? 0;
          normalizedPreacher['name'] ??= 'Nome não informado';
          normalizedPreacher['worksheet'] =
              worksheetName; // Keep track of source worksheet

          preacherResults.add(normalizedPreacher);
        }
      }

      return preacherResults;
    } catch (e) {
      throw Exception('Failed to search preachers: $e');
    }
  }

  /// Get available parishes from the sheets configuration
  Future<List<String>> getAvailableParishes() async {
    try {
      final parishes = await _gsheetsDataSource.get('main', 'Paroquias');
      return parishes
          .map((parish) => parish['nome'] ?? parish['name'] ?? '')
          .where((name) => name.isNotEmpty)
          .cast<String>()
          .toList();
    } catch (e) {
      // Fallback: extract parish names from worksheet names
      try {
        final worksheets =
            await _gsheetsDataSource.getAvailableWorksheets('main');
        final parishNames = <String>[];

        for (final worksheet in worksheets) {
          if (worksheet.toLowerCase().contains('membros')) {
            // Extract parish name from worksheet name
            // Example: "Membros - Nossa Senhora da Penha - Pocrane - MG"
            final parts = worksheet.split(' - ');
            if (parts.length > 1) {
              parishNames.add(parts[1]);
            }
          }
        }

        return parishNames;
      } catch (e2) {
        throw Exception('Failed to get available parishes: $e');
      }
    }
  }
}
