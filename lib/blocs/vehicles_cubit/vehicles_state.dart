part of 'vehicles_cubit.dart';

abstract class VehiclesState extends Equatable {
  const VehiclesState();

  @override
  List<Object?> get props => [];
}

class VehiclesInitial extends VehiclesState {}

class VehiclesSelected extends VehiclesState {
  final Vehicle vehicle;
  VehiclesSelected({required this.vehicle});
}

class VehiclesLoading extends VehiclesState {}

class VehiclesLoaded extends VehiclesState {
  final List<Vehicle> vehicles;
  final List<VehicleType> vehicleTypes;
  final List<Pool> pools;
  final List<Availability> availabilities;
  final List<GeneralStatus> generalStatuses;

  VehiclesLoaded(
      {required this.vehicles,
      required this.vehicleTypes,
      required this.pools,
      required this.availabilities,
      required this.generalStatuses});

  @override
  List<Object?> get props => [vehicles, vehicleTypes, pools, availabilities, generalStatuses];
}

class VehiclesError extends VehiclesState {
  final dynamic error;
  final StackTrace stackTrace;

  VehiclesError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
