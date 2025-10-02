import 'package:plc/features/preachers/domain/entities/preacher.dart';

abstract class PreachersState {}

class PreachersInitial extends PreachersState {}

class PreachersLoading extends PreachersState {}

class PreachersLoaded extends PreachersState {
  final List<Preacher> preachers;

  PreachersLoaded({required this.preachers});
}

class PreachersError extends PreachersState {
  final String message;

  PreachersError({required this.message});
}
