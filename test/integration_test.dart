import 'package:flutter_test/flutter_test.dart';
import 'package:plc/core/di/injection_container.dart' as di;
import 'package:plc/core/storage/local_storage_service.dart';

void main() {
  setUpAll(() async {
    await di.init();
  });

  group('PLC App Integration Tests', () {
    test('Dependency injection initializes successfully', () async {
      // Test that DI setup works
      expect(di.sl.isRegistered<LocalStorageService>(), isTrue);
    });

    test('Storage service loads sample data', () async {
      final storageService = di.sl<LocalStorageService>();
      final preachers = await storageService.getPreachers();

      expect(preachers, isNotEmpty);
      expect(preachers.length, equals(8));
      expect(preachers.first['name'], equals('João Silva Santos'));
    });

    test('Storage service can retrieve preacher by ID', () async {
      final storageService = di.sl<LocalStorageService>();
      final preacher = await storageService.getPreacherById(1);

      expect(preacher, isNotNull);
      expect(preacher!['id'], equals(1));
      expect(preacher['name'], equals('João Silva Santos'));
    });

    test('Storage service handles non-existent preacher', () async {
      final storageService = di.sl<LocalStorageService>();
      final preacher = await storageService.getPreacherById(999);

      expect(preacher, isNull);
    });
  });
}
