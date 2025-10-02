import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_state.dart';
import 'package:plc/features/preachers/presentation/pages/preacher_profile_page.dart';

class MockPreacherProfileBloc extends Mock implements PreacherProfileBloc {}

void main() {
  late MockPreacherProfileBloc mockPreacherProfileBloc;

  setUp(() {
    mockPreacherProfileBloc = MockPreacherProfileBloc();
  });

  final tPreacher = Preacher(id: 1, fullName: 'Test Preacher 1', phone: '123', city: 'Test City 1', state: 'TS');

  testWidgets('should display preacher profile', (WidgetTester tester) async {
    when(mockPreacherProfileBloc.state).thenReturn(PreacherProfileLoaded(preacher: tPreacher));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PreacherProfileBloc>.value(
          value: mockPreacherProfileBloc,
          child: const PreacherProfilePage(preacherId: 1),
        ),
      ),
    );

    expect(find.text('Name: Test Preacher 1'), findsOneWidget);
    expect(find.text('Phone: 123'), findsOneWidget);
    expect(find.text('City: Test City 1'), findsOneWidget);
    expect(find.text('State: TS'), findsOneWidget);
  });
}
