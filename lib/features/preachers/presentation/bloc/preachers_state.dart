import 'package:plc/features/preachers/domain/entities/preacher.dart';

abstract class PreachersState {}

class PreachersInitial extends PreachersState {}

class PreachersLoading extends PreachersState {}

class PreachersLoaded extends PreachersState {
  final List<Preacher> preachers;
  final bool inSearch;
  final String? currentQueryText;
  final List<String> selectedThemes;

  PreachersLoaded({
    required this.preachers,
    this.inSearch = false,
    this.currentQueryText,
    this.selectedThemes = const [],
  });
}

class PreachersError extends PreachersState {
  final String message;

  PreachersError({required this.message});
}
