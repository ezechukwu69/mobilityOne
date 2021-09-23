import 'package:bloc/bloc.dart';
import 'package:mobility_one/models/availability.dart';
import 'package:mobility_one/models/vehicle.dart';

import 'availabilities_dropdown_list_state.dart';

class AvailabilitiesDropdownListCubit
    extends Cubit<AvailabilitiesDropdownListState> {
  AvailabilitiesDropdownListCubit()
      : super(
          AvailabilitiesDropdownListState(
            isExpanded: false,
            selectedAvailability: null,
            availableAvailabilities: [],
          ),
        );

  void getInitialData(
      {required Vehicle? vehicleToBeUpdated,
      required List<Availability> availableAvailabilities}) {
    Availability? selectedAvailability;
    if (vehicleToBeUpdated != null) {
      selectedAvailability = availableAvailabilities.firstWhere(
          (_availability) =>
              _availability.id == vehicleToBeUpdated.availabilityId);
    }

    emit(state.copyWith(
        availableAvailabilities: availableAvailabilities,
        selectedAvailability: selectedAvailability));
  }

  void updateIsExpanded({required bool isExpanded}) =>
      emit(state.copyWith(isExpanded: isExpanded));

  void updateSelectedAvailability(
          {required Availability selectedAvailability}) =>
      emit(state.copyWith(
          selectedAvailability: selectedAvailability, isExpanded: false));
}
