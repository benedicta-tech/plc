abstract class PreachersEvent {}

class LoadPreachers extends PreachersEvent {}

class SearchPreachers extends PreachersEvent {
  final String query;

  SearchPreachers({required this.query});
}

class FilterPreachersByThemes extends PreachersEvent {
  final List<String> selectedThemes;

  FilterPreachersByThemes({required this.selectedThemes});
}
