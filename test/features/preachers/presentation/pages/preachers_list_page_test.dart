import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_state.dart';
import 'package:plc/features/preachers/presentation/pages/preachers_list_page.dart';

import 'preachers_list_page_test.mocks.dart';

@GenerateMocks([PreachersBloc])
void main() {
  late MockPreachersBloc mockPreachersBloc;

  setUp(() {
    mockPreachersBloc = MockPreachersBloc();
  });

  final tPreachers = [
    Preacher(
      id: 1,
      fullName: 'Test Preacher 1',
      phone: '123',
      city: 'Test City 1',
      state: 'TS',
    ),
  ];

  testWidgets('should display a list of preachers', (WidgetTester tester) async {
    when(mockPreachersBloc.state).thenReturn(PreachersLoaded(preachers: tPreachers));
    when(mockPreachersBloc.stream).thenAnswer((_) => Stream.fromIterable([
      PreachersLoaded(preachers: tPreachers),
    ]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PreachersBloc>.value(
          value: mockPreachersBloc,
          child: const PreachersListPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Test Preacher 1'), findsOneWidget);
    expect(find.text('Nossa Comunidade'), findsOneWidget);
  });

  testWidgets('should display loading indicator when loading', (WidgetTester tester) async {
    when(mockPreachersBloc.state).thenReturn(PreachersLoading());
    when(mockPreachersBloc.stream).thenAnswer((_) => Stream.fromIterable([
      PreachersLoading(),
    ]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PreachersBloc>.value(
          value: mockPreachersBloc,
          child: const PreachersListPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
