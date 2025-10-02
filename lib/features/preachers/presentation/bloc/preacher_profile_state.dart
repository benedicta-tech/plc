import 'package:plc/features/preachers/domain/entities/preacher.dart';

abstract class PreacherProfileState {}

class PreacherProfileInitial extends PreacherProfileState {}

class PreacherProfileLoading extends PreacherProfileState {}

class PreacherProfileLoaded extends PreacherProfileState {
  final Preacher preacher;

  PreacherProfileLoaded({required this.preacher});
}

class PreacherProfileError extends PreacherProfileState {
  final String message;

  PreacherProfileError({required this.message});
}
