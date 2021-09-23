import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/vehicle_type.dart';



class VehicleTypesDropdownListState extends Equatable {
  final bool isExpanded;
  final VehicleType? selectedVehicleType;
  final List<VehicleType> availableVehicleTypes;

  VehicleTypesDropdownListState(
      {required this.isExpanded, required this.selectedVehicleType, required this.availableVehicleTypes});

  VehicleTypesDropdownListState copyWith({
    bool? isExpanded,
    VehicleType? selectedVehicleType,
    List<VehicleType>? availableVehicleTypes,
  }) {
    return VehicleTypesDropdownListState(
        isExpanded: isExpanded ?? this.isExpanded,
        selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
        availableVehicleTypes: availableVehicleTypes ?? this.availableVehicleTypes);
  }

  @override
  List<Object?> get props => [isExpanded, selectedVehicleType, availableVehicleTypes];
}
