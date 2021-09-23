import 'package:flutter/material.dart';
import 'package:mobility_one/blocs/persons_cubit/persons_cubit.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/filter_group_container.dart';
import 'package:mobility_one/util/filter_group.dart';
import 'package:mobility_one/util/helpers.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/util.dart';

void showSideSheet(
  BuildContext context, {
  required PersonsCubit personsCubit,
  required List<Filter> selectedFilters,
}) {
  //
  final personsCubitState = personsCubit.state;

  List<OrgUnit> _getOrgUnitsFromPersonsCubit({required BuildContext context}) {
    if (personsCubitState is PersonsLoaded) {
      return personsCubitState.orgUnits;
    }
    return [];
  }

  final _orgUnits = _getOrgUnitsFromPersonsCubit(context: context);

  bool _isFilterSelected(String orgUnitId) {
    try {
      selectedFilters.firstWhere((filter) {
        return filter.value == orgUnitId;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  var filterGroups = [
    FilterGroup(
      groupName: 'Org. Unit',
      filters: _orgUnits.map((orgUnit) {
        return Filter(
          label: orgUnit.name!,
          value: orgUnit.id,
          isSelected: _isFilterSelected(orgUnit.id!),
          filterName: 'OrgUnitId',
        );
      }).toList(),
    ),
  ];

  Util.rightSideBarDialog(
    context,
    children: [
      ...filterGroups.map((filterGroup) {
        return FilterGroupContainer(
          filterGroup: filterGroup,
          selectedFilters: selectedFilters,
        );
      }).toList(),

      //
      Center(
        child: ConfirmButton(
          onPressed: () {
            Navigator.of(context).pop();

            final requestFilters = generateFiltersString(selectedFilters);

            personsCubit.filterPersonsByOrgUnits(requestFilters);
          },
          title: MyLocalization.of(context)!.filterLabel.toUpperCase(),
        ),
      )
    ],
  );
}
