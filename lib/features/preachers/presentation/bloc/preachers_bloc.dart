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
        emit(PreachersLoaded(preachers: preachers, inSearch: false));
      } catch (e) {
        emit(PreachersError(message: e.toString()));
      }
    });

    on<SearchPreachers>((event, emit) async {
      final currentState = state;

      if (currentState is PreachersLoaded) {
        final preachers = await getPreachers();

        var filteredPreachers = preachers;

        if (event.query.isNotEmpty) {
          filteredPreachers =
              filteredPreachers
                  .where(
                    (preacher) => preacher.name.toLowerCase().contains(
                      event.query.toLowerCase(),
                    ),
                  )
                  .toList();
        }

        if (currentState.selectedThemes.isNotEmpty) {
          filteredPreachers =
              filteredPreachers
                  .where(
                    (preacher) => currentState.selectedThemes.any(
                      (theme) => preacher.themes.contains(theme),
                    ),
                  )
                  .toList();
        }

        emit(
          PreachersLoaded(
            preachers: filteredPreachers,
            inSearch:
                event.query.isNotEmpty ||
                currentState.selectedThemes.isNotEmpty,
            currentQueryText: event.query,
            selectedThemes: currentState.selectedThemes,
          ),
        );
      }
    });

    on<FilterPreachersByThemes>((event, emit) async {
      final currentState = state;

      if (currentState is PreachersLoaded) {
        final preachers = await getPreachers();

        var filteredPreachers = preachers;

        if (currentState.currentQueryText?.isNotEmpty == true) {
          filteredPreachers =
              filteredPreachers
                  .where(
                    (preacher) => preacher.name.toLowerCase().contains(
                      currentState.currentQueryText!.toLowerCase(),
                    ),
                  )
                  .toList();
        }

        if (event.selectedThemes.isNotEmpty) {
          filteredPreachers =
              filteredPreachers
                  .where(
                    (preacher) => event.selectedThemes.any(
                      (theme) => preacher.themes.contains(theme),
                    ),
                  )
                  .toList();
        }

        emit(
          PreachersLoaded(
            preachers: filteredPreachers,
            inSearch:
                (currentState.currentQueryText?.isNotEmpty ?? false) ||
                event.selectedThemes.isNotEmpty,
            currentQueryText: currentState.currentQueryText,
            selectedThemes: event.selectedThemes,
          ),
        );
      }
    });
  }
}
