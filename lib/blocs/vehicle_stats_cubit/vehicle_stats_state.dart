part of 'vehicle_stats_cubit.dart';

abstract class VehicleStatsState extends Equatable {
  const VehicleStatsState();

  @override
  List<Object?> get props => [];
}

class VehicleStatsInitial extends VehicleStatsState {}

class VehicleStatsLoading extends VehicleStatsState {}

class VehicleStatsLoaded extends VehicleStatsState {
  final List<VehicleStat> vehicleStats;
  VehicleStatsLoaded({required this.vehicleStats});

  @override
  List<Object?> get props => [vehicleStats];
}

class VehicleStatsError extends VehicleStatsState {
  final dynamic error;
  final StackTrace stackTrace;

  VehicleStatsError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
