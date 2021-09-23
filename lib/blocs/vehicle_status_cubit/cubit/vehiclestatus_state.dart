part of 'vehiclestatus_cubit.dart';

abstract class VehicleStatusState extends Equatable {
  const VehicleStatusState();

  @override
  List<Object> get props => [];
}

class VehiclestatusInitial extends VehicleStatusState {}

class VehicleStatusLoading extends VehicleStatusState {}

class VehicleStatusFetched extends VehicleStatusState {
  final List<Draggable_custom_card> needsAttentionList;
  final List<Draggable_custom_card> driverUnassignedList;
  final List<Draggable_custom_card> inMaintanceList;
  final List<Draggable_custom_card> recentlyHandledList;
  final List<Draggable_custom_card> allVehiclesList;
  final List<VehicleType> vehicletypes;
  final List<Pool> pools;
  final List<VehicleStat> vehicleStats;

  VehicleStatusFetched(this.needsAttentionList, this.driverUnassignedList, this.inMaintanceList, this.recentlyHandledList, this.allVehiclesList, this.vehicletypes, this.pools, this.vehicleStats);
 @override
  List<Object> get props => [vehicletypes,pools,vehicleStats];
}

class VehicleStatusError extends VehicleStatusState {
  final dynamic error;
  final StackTrace stackTrace;

  VehicleStatusError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
