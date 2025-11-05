import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/features/parishes/domain/usercases/get_parishes.dart';
import 'package:plc/features/parishes/presentation/bloc/parishes_event.dart';
import 'package:plc/features/parishes/presentation/bloc/parishes_state.dart';

class ParishesBloc extends Bloc<ParishesEvent, ParishesState> {
  final GetParishes getParishes;

  ParishesBloc({required this.getParishes}) : super(ParishesInitial()) {
    on<LoadParishes>((event, emit) async {
      emit(ParishesLoading());
      try {
        final parishes = await getParishes();
        emit(ParishesLoaded(parishes: parishes));
      } catch (e) {
        emit(ParishesError(message: e.toString()));
      }
    });
  }
}
