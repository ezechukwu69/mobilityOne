import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/vehicles_cubit/vehicles_cubit.dart';
import 'package:mobility_one/services/excel_service.dart';
import 'package:mobility_one/ui/dialogs/vehicle_dialog.dart';
import 'package:mobility_one/ui/screens/vehicles_list/widgets/show_vehicles_list_side_sheet.dart';
import 'package:mobility_one/ui/widgets/bulk_import_dialog.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/util/filter_group.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/util/util.dart';

class VehiclesListTableActions extends StatelessWidget {
  //
  VehiclesListTableActions({
    Key? key,
    required this.selectedFilters,
  }) : super(key: key);

  List<Filter> selectedFilters;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ConfirmButton(
        title: 'New vehicle',
        onPressed: () async {
          await Util.showMyDialog(
            barrierDismissible: false,
            barrierColorTransparent: false,
            context: context,
            child: BlocProvider.value(
              value: context.read<VehiclesCubit>(),
              child: VehicleDialog(
                vehicleToBeUpdated: null,
                action: VehicleAction.create,
              ),
            ),
          );
        },
        canClick: true,
      ),
      SizedBox(width: 10),
      TextButton(
        onPressed: () {
          Util.showMyDialog(
            context: context,
            child: BlocProvider.value(
              value: context.read<VehiclesCubit>(),
              child: BlocBuilder<VehiclesCubit, VehiclesState>(
                builder: (context, state) {
                  return BulkImportDialog(
                    title: 'Import Vehicles',
                    importScreen: ImportScreen.Vehicles,
                    colHeadersList: vehiclesListHeaderFormat,
                    onUpload: (records) async {
                      await context
                          .read<VehiclesCubit>()
                          .importVehicle(records);
                    },
                    isLoading: state is! VehiclesLoaded,
                  );
                },
              ),
            ),
          );
        },
        child: Text(
          'Import vehicles',
          style: MyTextStyles.pStyle,
        ),
      ),
      Spacer(),
      IconButton(
        onPressed: () {
          showVehiclesListSideSheet(
            context,
            vehiclesListCubit: context.read<VehiclesCubit>(),
            selectedFilters: selectedFilters,
          );
        },
        icon: Icon(
          Icons.filter_list,
          color: MyColors.cardTextColor,
        ),
      ),
    ]);
  }
}
