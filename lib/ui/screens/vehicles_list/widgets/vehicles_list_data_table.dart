import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/vehicles_cubit/vehicles_cubit.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/ui/dialogs/vehicle_dialog.dart';
import 'package:mobility_one/ui/widgets/m_one_data_table.dart';
import 'package:mobility_one/util/util.dart';

class VehiclesListDataTable extends StatefulWidget {
  final List<Vehicle> vehicles;

  const VehiclesListDataTable({
    Key? key,
    required this.vehicles,
  }) : super(key: key);

  @override
  _VehiclesListDataTableState createState() => _VehiclesListDataTableState();
}

class _VehiclesListDataTableState extends State<VehiclesListDataTable> {
  //
  final List<String> columns = const [
    'Display Name',
    'Licence Plate',
    'VIN',
    'Type',
    'Model',
    'Pool',
    'Vehicle Type',
    'General Status',
    'Availiability',
  ];

  @override
  Widget build(BuildContext context) {
    return MOneDataTable(
      columns: columns,
      rows: _getRows(),
      onSort: onSort,
    );
  }

  List<DataRow> _getRows() {
    return widget.vehicles.map((vehicle) {
      final cells = _getRowCells(vehicle: vehicle);

      return DataRow(cells: cells);
    }).toList();
  }

  List<DataCell> _getRowCells({required Vehicle vehicle}) {
    // ignore: omit_local_variable_types
    List cellValues = [
      vehicle.displayName,
      vehicle.licencePlate,
      vehicle.vin,
      vehicle.type,
      vehicle.model,
      vehicle.poolName,
      vehicle.vehicleTypeName,
      vehicle.generalStatusName,
      vehicle.availability,
    ];

    return cellValues.map((value) {
      return DataCell(
        Text('$value'),
        onTap: () async {
          await Util.showMyDialog(
            barrierDismissible: false,
            barrierColorTransparent: false,
            context: context,
            child: BlocProvider.value(
              value: context.read<VehiclesCubit>(),
              child: VehicleDialog(
                vehicleToBeUpdated: vehicle,
                action: VehicleAction.update,
              ),
            ),
          );
        },
      );
    }).toList();
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.vehicles.sort((vehicle1, vehicle2) => compareString(
          ascending, vehicle1.displayName!, vehicle2.displayName!));
    } else if (columnIndex == 1) {
      widget.vehicles.sort((vehicle1, vehicle2) => compareString(
          ascending, vehicle1.licencePlate!, vehicle2.licencePlate!));
    } else if (columnIndex == 2) {
      widget.vehicles.sort((vehicle1, vehicle2) =>
          compareString(ascending, vehicle1.vin!, vehicle2.vin!));
    } else if (columnIndex == 3) {
      widget.vehicles.sort((vehicle1, vehicle2) =>
          compareString(ascending, vehicle1.type!, vehicle2.type!));
    } else if (columnIndex == 4) {
      widget.vehicles.sort((vehicle1, vehicle2) =>
          compareString(ascending, vehicle1.model!, vehicle2.model!));
    } else if (columnIndex == 5) {
      widget.vehicles.sort((vehicle1, vehicle2) =>
          compareString(ascending, vehicle1.poolName!, vehicle2.poolName!));
    } else if (columnIndex == 6) {
      widget.vehicles.sort((vehicle1, vehicle2) => compareString(
          ascending, vehicle1.vehicleTypeName!, vehicle2.vehicleTypeName!));
    } else if (columnIndex == 7) {
      widget.vehicles.sort((vehicle1, vehicle2) => compareString(
          ascending, vehicle1.generalStatusName!, vehicle2.generalStatusName!));
    } else if (columnIndex == 8) {
      widget.vehicles.sort((vehicle1, vehicle2) => compareString(
          ascending, vehicle1.availability!, vehicle2.availability!));
    }

    setState(() {});
  }
}
