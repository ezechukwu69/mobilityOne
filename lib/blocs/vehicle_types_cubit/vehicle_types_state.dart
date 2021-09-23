part of 'vehicle_types_cubit.dart';

abstract class VehicleTypesState extends Equatable {
  const VehicleTypesState();

  @override
  List<Object?> get props => [];
}

class VehicleTypesInitial extends VehicleTypesState {}

class VehicleTypesSelected extends VehicleTypesState {
  final VehicleType vehicletype;
  VehicleTypesSelected({required this.vehicletype});
}

class VehicleTypesLoading extends VehicleTypesState {}

class VehicleTypesLoaded extends VehicleTypesState {
  final List<VehicleType> vehicletypes;
  VehicleTypesLoaded({required this.vehicletypes});

  @override
  List<Object?> get props => [vehicletypes];
}

class VehicleTypesError extends VehicleTypesState {
  final dynamic error;
  final StackTrace stackTrace;

  VehicleTypesError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
