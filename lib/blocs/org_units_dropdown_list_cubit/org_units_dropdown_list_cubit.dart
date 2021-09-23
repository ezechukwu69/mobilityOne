import 'package:bloc/bloc.dart';
import 'package:mobility_one/blocs/org_units_dropdown_list_cubit/org_units_dropdown_list_state.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/models/person.dart';

class OrgUnitsDropdownListCubit extends Cubit<OrgUnitsDropdownListState> {
  OrgUnitsDropdownListCubit()
      : super(
          OrgUnitsDropdownListState(
            isExpanded: false,
            selectedOrgUnit: null,
            availableOrgUnits: [],
          ),
        );

  void getInitialData(
      {required Person? personToBeUpdated, required List<OrgUnit> availableOrgUnits}) {
    OrgUnit? selectedOrgUnit;
    if (personToBeUpdated != null) {
      selectedOrgUnit =
          availableOrgUnits.firstWhere((_orgUnit) => _orgUnit.id == personToBeUpdated.orgUnitId);
    }

    emit(state.copyWith(availableOrgUnits: availableOrgUnits, selectedOrgUnit: selectedOrgUnit));
  }

  void updateIsExpanded({required bool isExpanded}) => emit(state.copyWith(isExpanded: isExpanded));

  void updateSelectedOrgUnit({required OrgUnit selectedOrgUnit}) =>
      emit(state.copyWith(selectedOrgUnit: selectedOrgUnit, isExpanded: false));
}
