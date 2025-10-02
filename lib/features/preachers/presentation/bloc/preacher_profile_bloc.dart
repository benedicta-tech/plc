import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/features/preachers/domain/usecases/get_preacher_by_id.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_event.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_state.dart';

class PreacherProfileBloc extends Bloc<PreacherProfileEvent, PreacherProfileState> {
  final GetPreacherById getPreacherById;

  PreacherProfileBloc({required this.getPreacherById}) : super(PreacherProfileInitial()) {
    on<LoadPreacherProfile>((event, emit) async {
      emit(PreacherProfileLoading());
      try {
        final preacher = await getPreacherById(event.id);
        emit(PreacherProfileLoaded(preacher: preacher));
      } catch (e) {
        emit(PreacherProfileError(message: e.toString()));
      }
    });
  }
}
