import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/vehicle_types_cubit/vehicle_types_cubit.dart';
import 'package:mobility_one/models/vehicle_type.dart';
import 'package:mobility_one/repositories/vehicle_types_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/ui/dialogs/vehicle_type_dialog.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/util.dart';
import 'package:pluto_grid/pluto_grid.dart';

class VehicleTypesScreen extends StatelessWidget {
  const VehicleTypesScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehicleTypesCubit>(
      create: (context) => VehicleTypesCubit(
        vehicletypesRepository: context.read<VehicleTypesRepository>(),
        tenantsRepository: context.read<TenantsRepository>()
      )..getDataFromApi(),
      child: VehicleTypesDataTable(),
    );
  }
}

class VehicleTypePlutoGridRow extends PlutoRow {
  VehicleTypePlutoGridRow({required this.vehicletype, required this.cells})
      : super(cells: cells);
  VehicleType vehicletype;
  @override
  Map<String, PlutoCell> cells;
}

class VehicleTypesDataTable extends StatelessWidget {
  VehicleTypesDataTable();
  final List<PlutoColumn> columns = [
    PlutoColumn(
        type: PlutoColumnType.text(), title: 'Vehicle Type Name', field: 'name')
  ];
  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleTypesCubit, VehicleTypesState>(
      builder: (context, state) {
        if (state is VehicleTypesLoaded) {
          final rows = _convertListOfVehicleTypeToListOfDataRow(
              data: [...state.vehicletypes], context: context);
          return Theme(
              data: ThemeData.dark(),
              child: Center(
                  child: Column(children: [
                Row(children: [
                  ConfirmButton(
                    title: 'New type',
                    onPressed: () async {
                      log('Started creating vehicletype');
                      await Util.showMyDialog(
                        barrierDismissible: false,
                        barrierColorTransparent: false,
                        context: context,
                        child: BlocProvider.value(
                          value: context.read<VehicleTypesCubit>(),
                          child: VehicleTypeDialog(
                            vehicletypeToBeUpdated: null,
                            action: VehicleTypeAction.create,
                          ),
                        ),
                      );
                    },
                    canClick: true,
                  ),
                  CancelButton(
                    title: 'Delete type',
                    onPressed: () async {
                      log('Started deleting vehicletype');
                      await context.read<VehicleTypesCubit>().deleteVehicleType();
                    },
                  )
                ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 267,
                  child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: MyColors.backgroundCardColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(19.0693),
                          ),
                          border:
                              Border.all(color: Color(0xFF3A3A4E), width: 1)),
                      child: PlutoGrid(
                          configuration: PlutoGridConfiguration(
                              gridBackgroundColor: MyColors.backgroundCardColor,
                              enableColumnBorder: false,
                              gridBorderColor: MyColors.backgroundCardColor,
                             activatedColor: MyColors.backgroundColor,
                              cellTextStyle:
                                  TextStyle(color: MyColors.cardTextColor),
                              columnTextStyle:
                                  TextStyle(color: MyColors.cardTextColor)),
                          mode: PlutoGridMode.select,
                    columns: columns,
                    rows: rows,
                    onSelected: (PlutoGridOnSelectedEvent e) async {
                      log('Started selecting vehicletype');
                      await context.read<VehicleTypesCubit>().selectVehicleType(vehicletype: (e.row as VehicleTypePlutoGridRow).vehicletype);
                    },
                    onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent e) async {
                      log('Started creating vehicletype');
                      await Util.showMyDialog(
                        barrierDismissible: false,
                        barrierColorTransparent: false,
                        context: context,
                        child: BlocProvider.value(
                          value: context.read<VehicleTypesCubit>(),
                          child: VehicleTypeDialog(
                            vehicletypeToBeUpdated:
                                (e.row as VehicleTypePlutoGridRow).vehicletype,
                            action: VehicleTypeAction.update,
                          ),
                        ),
                      );
                    })
                  ),
                )
              ])));
        } else if (state is VehicleTypesLoading) {
          return Center(child: MyCircularProgressIndicator());
        } else if (state is VehicleTypesError) {
          return Text(
            'Error',
            style: TextStyle(color: Colors.white),
          );
        }
        return const SizedBox();
      },
    );
  }

  List<VehicleTypePlutoGridRow> _convertListOfVehicleTypeToListOfDataRow(
          {required List<VehicleType> data, required BuildContext context}) =>
      data
          .map((_vehicletype) => VehicleTypePlutoGridRow(vehicletype: _vehicletype, cells: {
                'name': PlutoCell(value: _vehicletype.name)
              }))
          .toList();
}
