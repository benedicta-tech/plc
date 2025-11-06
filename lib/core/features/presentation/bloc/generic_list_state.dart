abstract class GenericListState<T> {}

class ListInitial<T> extends GenericListState<T> {}

class ListLoading<T> extends GenericListState<T> {}

class ListLoaded<T, F> extends GenericListState<T> {
  final List<T> items;
  final bool inSearch;
  final String? currentQueryText;
  final F? filterCriteria;

  ListLoaded({
    required this.items,
    this.inSearch = false,
    this.currentQueryText,
    this.filterCriteria,
  });
}

class ListError<T> extends GenericListState<T> {
  final String message;

  ListError({required this.message});
}
