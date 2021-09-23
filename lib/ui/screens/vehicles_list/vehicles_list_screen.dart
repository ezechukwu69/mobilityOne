import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/vehicles_cubit/vehicles_cubit.dart';
import 'package:mobility_one/repositories/availabilities_repository.dart';
import 'package:mobility_one/repositories/general_statuses_repository.dart';
import 'package:mobility_one/repositories/pools_repository.dart';
import 'package:mobility_one/repositories/vehicle_types_repository.dart';
import 'package:mobility_one/repositories/vehicles_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/ui/screens/vehicles_list/widgets/vehicles_list_data_table.dart';
import 'package:mobility_one/ui/screens/vehicles_list/widgets/vehicles_list_table_actions.dart';
import 'package:mobility_one/ui/widgets/m_one_container.dart';
import 'package:mobility_one/ui/widgets/m_one_error_widget.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/util/filter_group.dart';

class VehiclesListScreen extends StatelessWidget {
  const VehiclesListScreen();

  @override
  Widget build(BuildContext context) {
    //
    List<Filter> selectedFilters = [];

    return BlocProvider<VehiclesCubit>(
        create: (context) => VehiclesCubit(
              vehiclesRepository: context.read<VehiclesRepository>(),
              tenantsRepository: context.read<TenantsRepository>(),
              generalStatusesRepository:
                  context.read<GeneralStatusesRepository>(),
              vehicleTypeRepository: context.read<VehicleTypesRepository>(),
              availabilitiesRepository:
                  context.read<AvailabilitiesRepository>(),
              poolsRepository: context.read<PoolsRepository>(),
            )..getDataFromApi(),
        child: BlocBuilder<VehiclesCubit, VehiclesState>(
          builder: (context, state) {
            if (state is VehiclesLoaded) {
              return MOneContainer(
                children: [
                  VehiclesListTableActions(selectedFilters: selectedFilters),
                  Divider(),
                  Flexible(
                    child: VehiclesListDataTable(vehicles: [...state.vehicles]),
                  )
                ],
              );
            } else if (state is VehiclesLoading) {
              return Center(child: MyCircularProgressIndicator());
            } else if (state is VehiclesError) {
              return MOneErrorWidget();
            }
            return const SizedBox();
          },
        ));
  }
}
