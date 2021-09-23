import 'package:equatable/equatable.dart';

import 'package:mobility_one/models/org_unit.dart';

class OrgUnitsDropdownListState extends Equatable {
  final bool isExpanded;
  final OrgUnit? selectedOrgUnit;
  final List<OrgUnit> availableOrgUnits;

  OrgUnitsDropdownListState(
      {required this.isExpanded, required this.selectedOrgUnit, required this.availableOrgUnits});

  OrgUnitsDropdownListState copyWith({
    bool? isExpanded,
    OrgUnit? selectedOrgUnit,
    List<OrgUnit>? availableOrgUnits,
  }) {
    return OrgUnitsDropdownListState(
        isExpanded: isExpanded ?? this.isExpanded,
        selectedOrgUnit: selectedOrgUnit ?? this.selectedOrgUnit,
        availableOrgUnits: availableOrgUnits ?? this.availableOrgUnits);
  }

  @override
  List<Object?> get props => [isExpanded, selectedOrgUnit, availableOrgUnits];
}
