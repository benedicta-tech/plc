import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_state.dart';
import 'package:plc/features/preachers/presentation/pages/preachers_list_page.dart';

class MockPreachersBloc extends Mock implements PreachersBloc {}

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

  testWidgets('should display a list of preachers', (
    WidgetTester tester,
  ) async {
    when(
      mockPreachersBloc.state,
    ).thenReturn(PreachersLoaded(preachers: tPreachers));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PreachersBloc>.value(
          value: mockPreachersBloc,
          child: const PreachersListPage(),
        ),
      ),
    );

    expect(find.text('Test Preacher 1'), findsOneWidget);
  });
}
