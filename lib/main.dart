import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/core/di/injection_container.dart' as di;
import 'package:plc/features/home/presentation/pages/home_page.dart';
import 'package:plc/features/parishes/presentation/bloc/parishes_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_bloc.dart';
import 'package:plc/theme/text.dart';
import 'package:plc/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Roboto", "Lora");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ParishesBloc>(create: (_) => di.sl<ParishesBloc>()),
        BlocProvider<PreachersBloc>(create: (_) => di.sl<PreachersBloc>()),
        BlocProvider<PreacherProfileBloc>(
          create: (_) => di.sl<PreacherProfileBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'PLC - Peregrinação de Leigos Cristãos',
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        home: const HomePage(),
      ),
    );
  }
}
