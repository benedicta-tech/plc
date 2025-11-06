import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/core/features/domain/usecases/get_all_usecase.dart';
import 'package:plc/core/features/presentation/bloc/generic_list_event.dart';
import 'package:plc/core/features/presentation/bloc/generic_list_state.dart';

class GenericListBloc<T, F>
    extends Bloc<GenericListEvent, GenericListState<T>> {
  final GetAllUseCase<T> getAllUseCase;
  final bool Function(T item, String query)? searchPredicate;
  final bool Function(T item, F criteria)? filterPredicate;

  GenericListBloc({
    required this.getAllUseCase,
    this.searchPredicate,
    this.filterPredicate,
  }) : super(ListInitial<T>()) {
    on<LoadItems>(_onLoadItems);
    on<SearchItems>(_onSearchItems);
    on<FilterItems<F>>(_onFilterItems);
  }

  Future<void> _onLoadItems(
    LoadItems event,
    Emitter<GenericListState<T>> emit,
  ) async {
    emit(ListLoading<T>());
    try {
      final items = await getAllUseCase();
      emit(ListLoaded<T, F>(items: items, inSearch: false));
    } catch (e) {
      emit(ListError<T>(message: e.toString()));
    }
  }

  Future<void> _onSearchItems(
    SearchItems event,
    Emitter<GenericListState<T>> emit,
  ) async {
    final currentState = state;

    if (currentState is ListLoaded<T, F>) {
      try {
        final allItems = await getAllUseCase();
        var filteredItems = allItems;

        if (event.query.isNotEmpty && searchPredicate != null) {
          filteredItems = filteredItems
              .where((item) => searchPredicate!(item, event.query))
              .toList();
        }

        if (currentState.filterCriteria != null && filterPredicate != null) {
          filteredItems = filteredItems
              .where((item) =>
                  filterPredicate!(item, currentState.filterCriteria as F))
              .toList();
        }

        emit(
          ListLoaded<T, F>(
            items: filteredItems,
            inSearch:
                event.query.isNotEmpty || currentState.filterCriteria != null,
            currentQueryText: event.query,
            filterCriteria: currentState.filterCriteria,
          ),
        );
      } catch (e) {
        emit(ListError<T>(message: e.toString()));
      }
    }
  }

  Future<void> _onFilterItems(
    FilterItems<F> event,
    Emitter<GenericListState<T>> emit,
  ) async {
    final currentState = state;

    if (currentState is ListLoaded<T, F>) {
      try {
        final allItems = await getAllUseCase();
        var filteredItems = allItems;

        if (currentState.currentQueryText?.isNotEmpty == true &&
            searchPredicate != null) {
          filteredItems = filteredItems
              .where((item) =>
                  searchPredicate!(item, currentState.currentQueryText!))
              .toList();
        }

        if (filterPredicate != null) {
          filteredItems = filteredItems
              .where((item) => filterPredicate!(item, event.filterCriteria))
              .toList();
        }

        emit(
          ListLoaded<T, F>(
            items: filteredItems,
            inSearch: (currentState.currentQueryText?.isNotEmpty ?? false) ||
                event.filterCriteria != null,
            currentQueryText: currentState.currentQueryText,
            filterCriteria: event.filterCriteria,
          ),
        );
      } catch (e) {
        emit(ListError<T>(message: e.toString()));
      }
    }
  }
}
