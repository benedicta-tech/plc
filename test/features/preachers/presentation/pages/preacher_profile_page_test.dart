import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_state.dart';
import 'package:plc/features/preachers/presentation/pages/preacher_profile_page.dart';

import 'preacher_profile_page_test.mocks.dart';

@GenerateMocks([PreacherProfileBloc])
void main() {
  late MockPreacherProfileBloc mockPreacherProfileBloc;

  setUp(() {
    mockPreacherProfileBloc = MockPreacherProfileBloc();
  });

  final tPreacher = Preacher(
    id: '1',
    name: 'Test Preacher 1',
    phone: '123',
    city: 'Test City 1',
    roles: [],
    themes: [],
  );

  testWidgets('should display preacher profile', (WidgetTester tester) async {
    when(
      mockPreacherProfileBloc.state,
    ).thenReturn(PreacherProfileLoaded(preacher: tPreacher));
    when(mockPreacherProfileBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([PreacherProfileLoaded(preacher: tPreacher)]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PreacherProfileBloc>.value(
          value: mockPreacherProfileBloc,
          child: const PreacherProfilePage(preacherId: '1'),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Test Preacher 1'), findsOneWidget);
    expect(find.text('123'), findsOneWidget);
    expect(find.text('Test City 1'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('should display loading indicator when loading', (
    WidgetTester tester,
  ) async {
    when(mockPreacherProfileBloc.state).thenReturn(PreacherProfileLoading());
    when(
      mockPreacherProfileBloc.stream,
    ).thenAnswer((_) => Stream.fromIterable([PreacherProfileLoading()]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PreacherProfileBloc>.value(
          value: mockPreacherProfileBloc,
          child: const PreacherProfilePage(preacherId: '1'),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
