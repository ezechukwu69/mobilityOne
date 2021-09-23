import 'package:bloc/bloc.dart';
import 'package:mobility_one/models/general_status.dart';
import 'package:mobility_one/models/vehicle.dart';

import 'general_statuses_dropdown_list_state.dart';

class GeneralStatusesDropdownListCubit extends Cubit<GeneralStatusesDropdownListState> {
  GeneralStatusesDropdownListCubit()
      : super(
          GeneralStatusesDropdownListState(
            isExpanded: false,
            selectedGeneralStatus: null,
            availableGeneralStatuses: [],
          ),
        );

  void getInitialData(
      {required Vehicle? vehicleToBeUpdated, required List<GeneralStatus> availableGeneralStatuss}) {
    GeneralStatus? selectedGeneralStatus;
    if (vehicleToBeUpdated != null) {
      selectedGeneralStatus =
          availableGeneralStatuss.firstWhere((_generalStatus) => _generalStatus.id == vehicleToBeUpdated.generalStatusId);
    }

    emit(state.copyWith(availableGeneralStatuses: availableGeneralStatuss, selectedGeneralStatus: selectedGeneralStatus));
  }

  void updateIsExpanded({required bool isExpanded}) => emit(state.copyWith(isExpanded: isExpanded));

  void updateSelectedGeneralStatus({required GeneralStatus selectedGeneralStatus}) =>
      emit(state.copyWith(selectedGeneralStatus: selectedGeneralStatus, isExpanded: false));
}
