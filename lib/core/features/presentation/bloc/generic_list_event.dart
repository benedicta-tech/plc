abstract class GenericListEvent {}

class LoadItems extends GenericListEvent {}

class SearchItems extends GenericListEvent {
  final String query;

  SearchItems({required this.query});
}

class FilterItems<F> extends GenericListEvent {
  final F filterCriteria;

  FilterItems({required this.filterCriteria});
}
