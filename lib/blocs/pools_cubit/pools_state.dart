part of 'pools_cubit.dart';

abstract class PoolsState extends Equatable {
  const PoolsState();

  @override
  List<Object?> get props => [];
}

class PoolsInitial extends PoolsState {}

class PoolsSelected extends PoolsState {
  final Pool pool;
  PoolsSelected({required this.pool});
}

class PoolsLoading extends PoolsState {}

class PoolsLoaded extends PoolsState {
  final List<Pool> pools;
  PoolsLoaded({required this.pools});

  @override
  List<Object?> get props => [pools];
}

class PoolsError extends PoolsState {
  final dynamic error;
  final StackTrace stackTrace;

  PoolsError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
