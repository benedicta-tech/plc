import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/domain/usecases/get_preachers.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_event.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_state.dart';

class MockGetPreachers extends Mock implements GetPreachers {}

void main() {
  late PreachersBloc bloc;
  late MockGetPreachers mockGetPreachers;

  setUp(() {
    mockGetPreachers = MockGetPreachers();
    bloc = PreachersBloc(getPreachers: mockGetPreachers);
  });

  final tPreachers = [
    Preacher(id: 1, fullName: 'Test Preacher 1', phone: '123', city: 'Test City 1', state: 'TS'),
  ];

  blocTest<PreachersBloc, PreachersState>(
    'emits [PreachersLoading, PreachersLoaded] when LoadPreachers is added.',
    build: () {
      when(mockGetPreachers()).thenAnswer((_) async => tPreachers);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPreachers()),
    expect: () => [
      PreachersLoading(),
      PreachersLoaded(preachers: tPreachers),
    ],
  );
}
