import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/Team.dart';

abstract class TeamsState extends Equatable {
  const TeamsState();

  @override
  List<Object?> get props => [];
}

class TeamsInitial extends TeamsState {}

class TeamsLoading extends TeamsState {}

class TeamsLoaded extends TeamsState {
  final List<Team> teams;
  TeamsLoaded({required this.teams});

  @override
  List<Object?> get props => [teams];
}

class TeamsUpdated extends TeamsState {
  final List<Team> teams;
  TeamsUpdated({required this.teams});

  @override
  List<Object?> get props => [teams];
}

class TeamsError extends TeamsState {
  final dynamic error;
  final StackTrace stackTrace;

  TeamsError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
