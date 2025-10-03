import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/domain/repositories/preacher_repository.dart';
import 'package:plc/features/preachers/domain/usecases/get_preacher_by_id.dart';

import 'get_preacher_by_id_test.mocks.dart';

@GenerateMocks([PreacherRepository])
void main() {
  late GetPreacherById usecase;
  late MockPreacherRepository mockPreacherRepository;

  setUp(() {
    mockPreacherRepository = MockPreacherRepository();
    usecase = GetPreacherById(mockPreacherRepository);
  });

  const tId = 1;
  final tPreacher = Preacher(id: 1, fullName: 'Test Preacher 1', phone: '123', city: 'Test City 1', state: 'TS');

  test('should get preacher by id from the repository', () async {
    // arrange
    when(mockPreacherRepository.getPreacherById(tId)).thenAnswer((_) async => tPreacher);
    // act
    final result = await usecase(tId);
    // assert
    expect(result, tPreacher);
    verify(mockPreacherRepository.getPreacherById(tId));
    verifyNoMoreInteractions(mockPreacherRepository);
  });
}
