import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/domain/usecases/get_preacher_by_id.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_event.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_state.dart';

class MockGetPreacherById extends Mock implements GetPreacherById {}

void main() {
  late PreacherProfileBloc bloc;
  late MockGetPreacherById mockGetPreacherById;

  setUp(() {
    mockGetPreacherById = MockGetPreacherById();
    bloc = PreacherProfileBloc(getPreacherById: mockGetPreacherById);
  });

  const tId = 1;
  final tPreacher = Preacher(id: 1, fullName: 'Test Preacher 1', phone: '123', city: 'Test City 1', state: 'TS');

  blocTest<PreacherProfileBloc, PreacherProfileState>(
    'emits [PreacherProfileLoading, PreacherProfileLoaded] when LoadPreacherProfile is added.',
    build: () {
      when(mockGetPreacherById(tId)).thenAnswer((_) async => tPreacher);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPreacherProfile(id: tId)),
    expect: () => [
      PreacherProfileLoading(),
      PreacherProfileLoaded(preacher: tPreacher),
    ],
  );
}
