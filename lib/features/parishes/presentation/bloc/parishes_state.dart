import 'package:plc/features/parishes/domain/entities/parish.dart';

abstract class ParishesState {}

class ParishesInitial extends ParishesState {}

class ParishesLoading extends ParishesState {}

class ParishesLoaded extends ParishesState {
  final List<Parish> parishes;

  ParishesLoaded({
    required this.parishes,
  });
}

class ParishesError extends ParishesState {
  final String message;

  ParishesError({required this.message});
}
