part of 'roles_cubit.dart';

abstract class RolesState extends Equatable {
  const RolesState();

  @override
  List<Object?> get props => [];
}

class RolesInitial extends RolesState {}

class RolesLoading extends RolesState {}

class RolesLoaded extends RolesState {
  final List<Role> roles;

  RolesLoaded({required this.roles});

  @override
  List<Object?> get props => [roles];
}

class RolesError extends RolesState {
  final dynamic error;
  final StackTrace stackTrace;

  RolesError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
