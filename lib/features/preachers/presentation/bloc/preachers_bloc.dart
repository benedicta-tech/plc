import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/features/preachers/domain/usecases/get_preachers.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_event.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_state.dart';

class PreachersBloc extends Bloc<PreachersEvent, PreachersState> {
  final GetPreachers getPreachers;

  PreachersBloc({required this.getPreachers}) : super(PreachersInitial()) {
    on<LoadPreachers>((event, emit) async {
      emit(PreachersLoading());
      try {
        final preachers = await getPreachers();
        emit(PreachersLoaded(preachers: preachers));
      } catch (e) {
        emit(PreachersError(message: e.toString()));
      }
    });
  }
}
