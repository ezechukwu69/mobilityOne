import 'package:flutter/material.dart';
import 'package:mobility_one/blocs/vehicles_cubit/vehicles_cubit.dart';
import 'package:mobility_one/models/general_status.dart';
import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/models/vehicle_type.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/filter_group_container.dart';
import 'package:mobility_one/util/filter_group.dart';
import 'package:mobility_one/util/helpers.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/util.dart';

void showVehiclesListSideSheet(
  BuildContext context, {
  required VehiclesCubit vehiclesListCubit,
  required List<Filter> selectedFilters,
}) {
  //
  final vehiclesListCubitState = vehiclesListCubit.state;

  List<VehicleType> _getVechicleTypes({required BuildContext context}) {
    if (vehiclesListCubitState is VehiclesLoaded) {
      return vehiclesListCubitState.vehicleTypes;
    }
    return [];
  }

  List<Pool> _getPools({required BuildContext context}) {
    if (vehiclesListCubitState is VehiclesLoaded) {
      return vehiclesListCubitState.pools;
    }
    return [];
  }

  List<GeneralStatus> _getGeneralStatuses({required BuildContext context}) {
    if (vehiclesListCubitState is VehiclesLoaded) {
      return vehiclesListCubitState.generalStatuses;
    }
    return [];
  }

  final vehicleTypes = _getVechicleTypes(context: context);
  final pools = _getPools(context: context);
  final generalStatuses = _getGeneralStatuses(context: context);

  bool _isFilterSelected(String itemId) {
    try {
      selectedFilters.firstWhere((filter) {
        return filter.value.toString() == itemId;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  var filterGroups = [
    //
    FilterGroup(
      groupName: 'Vehicle Type',
      filters: vehicleTypes.map((vehicleType) {
        return Filter(
          label: vehicleType.name,
          value: vehicleType.id,
          isSelected: _isFilterSelected(vehicleType.id.toString()),
          filterName: 'VehicleTypeId',
        );
      }).toList(),
    ),

    //
    FilterGroup(
      groupName: 'Pool',
      filters: pools.map((pool) {
        return Filter(
          label: pool.name,
          value: pool.id,
          isSelected: _isFilterSelected(pool.id.toString()),
          filterName: 'PoolId',
        );
      }).toList(),
    ),

    //
    FilterGroup(
      groupName: 'General Stats',
      filters: generalStatuses.map((status) {
        return Filter(
          label: status.name,
          value: status.id,
          isSelected: _isFilterSelected(status.id.toString()),
          filterName: 'GeneralStatusId',
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

            vehiclesListCubit.filterVehiclesList(requestFilters);
          },
          title: MyLocalization.of(context)!.filterLabel.toUpperCase(),
        ),
      )
    ],
  );
}
