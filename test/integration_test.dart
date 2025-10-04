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

    test('Storage service starts empty', () async {
      final storageService = di.sl<LocalStorageService>();
      final preachers = await storageService.getPreachers();

      expect(preachers, isEmpty);
    });

    test('Storage service can save and retrieve preachers', () async {
      final storageService = di.sl<LocalStorageService>();

      final testPreachers = [
        {
          'id': 'test-preacher-1',
          'name': 'Test Preacher',
          'phone': '123-456-7890',
          'city': 'Test City',
          'roles': ['Preacher'],
          'themes': ['Fé', 'Oração']
        }
      ];

      await storageService.savePreachers(testPreachers);
      final preachers = await storageService.getPreachers();

      expect(preachers, isNotEmpty);
      expect(preachers.length, equals(1));
      expect(preachers.first['name'], equals('Test Preacher'));
    });

    test('Storage service handles non-existent preacher', () async {
      final storageService = di.sl<LocalStorageService>();
      final preacher = await storageService.getPreacherById(999);

      expect(preacher, isNull);
    });
  });
}
