import 'package:bloc/bloc.dart';
import 'package:mobility_one/blocs/vehicle_types_dropdown_list_cubit/vehicle_types_dropdown_list_state.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/models/vehicle_type.dart';

class VehicleTypesDropdownListCubit
    extends Cubit<VehicleTypesDropdownListState> {
  VehicleTypesDropdownListCubit()
      : super(
          VehicleTypesDropdownListState(
            isExpanded: false,
            selectedVehicleType: null,
            availableVehicleTypes: [],
          ),
        );

  void getInitialData(
      {required Vehicle? vehicleToBeUpdated,
      required List<VehicleType> availableVehicleTypes}) {
    VehicleType? selectedVehicleType;
    if (vehicleToBeUpdated != null) {
      selectedVehicleType = availableVehicleTypes.firstWhere((_vehicleType) =>
          _vehicleType.id == vehicleToBeUpdated.vehicleTypeId);
    }

    emit(state.copyWith(
        availableVehicleTypes: availableVehicleTypes,
        selectedVehicleType: selectedVehicleType));
  }

  void updateIsExpanded({required bool isExpanded}) =>
      emit(state.copyWith(isExpanded: isExpanded));

  void updateSelectedVehicleType({required VehicleType selectedVehicleType}) =>
      emit(state.copyWith(
          selectedVehicleType: selectedVehicleType, isExpanded: false));
}
