import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/domain/repositories/preacher_repository.dart';
import 'package:plc/features/preachers/domain/usecases/get_preachers.dart';

import 'get_preachers_test.mocks.dart';

@GenerateMocks([PreacherRepository])
void main() {
  late GetPreachers usecase;
  late MockPreacherRepository mockPreacherRepository;

  setUp(() {
    mockPreacherRepository = MockPreacherRepository();
    usecase = GetPreachers(mockPreacherRepository);
  });

  final tPreachers = [
    Preacher(id: 1, fullName: 'Test Preacher 1', phone: '123', city: 'Test City 1', state: 'TS'),
    Preacher(id: 2, fullName: 'Test Preacher 2', phone: '456', city: 'Test City 2', state: 'TS'),
  ];

  test('should get preachers from the repository', () async {
    // arrange
    when(mockPreacherRepository.getPreachers()).thenAnswer((_) async => tPreachers);
    // act
    final result = await usecase();
    // assert
    expect(result, tPreachers);
    verify(mockPreacherRepository.getPreachers());
    verifyNoMoreInteractions(mockPreacherRepository);
  });
}
