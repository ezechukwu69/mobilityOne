import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/vehicles_cubit/vehicles_cubit.dart';
import 'package:mobility_one/models/availability.dart';
import 'package:mobility_one/models/general_status.dart';
import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/models/vehicle_type.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/delete_button.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/ui/widgets/my_text_form_field.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/util/util.dart';

import 'my_dropdown_form_field.dart';

enum VehicleAction { create, update, delete }

class VehicleDialog extends StatefulWidget {
  final VehicleAction action;
  final Vehicle? vehicleToBeUpdated;
  const VehicleDialog({required this.action, this.vehicleToBeUpdated});

  @override
  _VehicleDialogState createState() => _VehicleDialogState();
}

class _VehicleDialogState extends State<VehicleDialog> {
  late TextEditingController displayNameController;
  late TextEditingController licencePlatesController;
  late TextEditingController vinController;
  late TextEditingController modelController;
  late TextEditingController typeController;
  late Pool? poolDropdownValue;
  late VehicleType? vehicleTypeDropdownValue;
  late GeneralStatus? generalStatusDropdownValue;
  late Availability? availabilitiesDropdownValue;

  @override
  void initState() {
    super.initState();
    displayNameController = TextEditingController();
    licencePlatesController = TextEditingController();
    vinController = TextEditingController();
    modelController = TextEditingController();
    typeController = TextEditingController();
    if (widget.vehicleToBeUpdated != null &&
        widget.action == VehicleAction.update) {
      displayNameController.text = widget.vehicleToBeUpdated!.displayName ?? '';
      licencePlatesController.text =
          widget.vehicleToBeUpdated!.licencePlate ?? '';
      vinController.text = widget.vehicleToBeUpdated!.vin ?? '';
      modelController.text = widget.vehicleToBeUpdated!.model ?? '';
      typeController.text = widget.vehicleToBeUpdated!.type ?? '';
      poolDropdownValue = widget.vehicleToBeUpdated!.pool;
      vehicleTypeDropdownValue = widget.vehicleToBeUpdated!.vehicleType;
      generalStatusDropdownValue = widget.vehicleToBeUpdated!.generalStatus;
      availabilitiesDropdownValue =
          widget.vehicleToBeUpdated!.availabilityObject;
    } else {
      poolDropdownValue = _getPoolsFromVehiclesCubit(context: context).first;
      vehicleTypeDropdownValue =
          _getVehicleTypesFromVehiclesCubit(context: context).first;
      generalStatusDropdownValue =
          _getGeneralStatusesFromVehiclesCubit(context: context).first;
      availabilitiesDropdownValue =
          _getAvailabilitiesFromVehiclesCubit(context: context).first;
    }
  }

  @override
  void dispose() {
    displayNameController.dispose();
    licencePlatesController.dispose();
    vinController.dispose();
    modelController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var vehiclesCubit = context.watch<VehiclesCubit>();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
                width: MediaQuery.of(context).size.width * .6,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MyColors.backgroundCardColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(19.0693),
                  ),
                  border: Border.all(color: Color(0xFF3A3A4E), width: 1),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    //
                    if (vehiclesCubit.state is VehiclesLoading) {
                      return MyCircularProgressIndicator();
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _dialogTitle(context: context),
                                style: MyTextStyles.dataTableTitle,
                              )
                            ],
                          ),
                        ),

                        //
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MyTextFormField(
                                      expanded: true,
                                      controller: displayNameController,
                                      label: 'Display name',
                                    ),
                                    MyDropDownFormField<Pool>(
                                      wrapWithExpanded: true,
                                      items: _getPoolsFromVehiclesCubit(
                                          context: context),
                                      label: 'Pool',
                                      value: poolDropdownValue!,
                                      onValueChanged: (value) {
                                        poolDropdownValue = value;
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    MyTextFormField(
                                      expanded: true,
                                      controller: licencePlatesController,
                                      label: 'Licence plate',
                                    ),
                                    MyTextFormField(
                                      expanded: true,
                                      controller: vinController,
                                      label: 'VIN',
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  MyTextFormField(
                                    expanded: true,
                                    controller: modelController,
                                    label: 'Model',
                                  ),
                                  MyTextFormField(
                                    expanded: true,
                                    controller: typeController,
                                    label: 'Type',
                                  )
                                ]),
                                Row(children: [
                                  MyDropDownFormField<VehicleType>(
                                    wrapWithExpanded: true,
                                    items: _getVehicleTypesFromVehiclesCubit(
                                        context: context),
                                    label: 'Vehicle Type',
                                    value: vehicleTypeDropdownValue!,
                                    onValueChanged: (value) {
                                      vehicleTypeDropdownValue = value;
                                    },
                                  ),
                                  MyDropDownFormField<GeneralStatus>(
                                    wrapWithExpanded: true,
                                    items: _getGeneralStatusesFromVehiclesCubit(
                                        context: context),
                                    label: 'General Status',
                                    value: generalStatusDropdownValue!,
                                    onValueChanged: (value) {
                                      generalStatusDropdownValue = value;
                                    },
                                  )
                                ]),
                                Row(
                                  children: [
                                    MyDropDownFormField<Availability>(
                                      wrapWithExpanded: true,
                                      items:
                                          _getAvailabilitiesFromVehiclesCubit(
                                              context: context),
                                      label: 'Availability',
                                      value: availabilitiesDropdownValue!,
                                      onValueChanged: (value) {
                                        availabilitiesDropdownValue = value;
                                      },
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                                const SizedBox(height: 60),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: _buildBottomButtons(
                                        context: context,
                                        constraints: constraints,
                                        dialogAction: widget.action,
                                        canClickConfirm: true,
                                        onCancel: () {
                                          Util.dismissDialog(context);
                                        },
                                        onConfirm: () async {
                                          switch (widget.action) {
                                            case VehicleAction.update:
                                              final didComplete = await context
                                                  .read<VehiclesCubit>()
                                                  .updateVehicle(
                                                    vehicleToBeUpdated: widget
                                                        .vehicleToBeUpdated!,
                                                    pool: poolDropdownValue!,
                                                    availability:
                                                        availabilitiesDropdownValue!,
                                                    generalStatus:
                                                        generalStatusDropdownValue!,
                                                    vehicleType:
                                                        vehicleTypeDropdownValue!,
                                                    displayName:
                                                        displayNameController
                                                            .text,
                                                    vin: vinController.text,
                                                    licencePlate:
                                                        licencePlatesController
                                                            .text,
                                                    model: modelController.text,
                                                    type: typeController.text,
                                                  );
                                              if (didComplete) {
                                                return Util.dismissDialog(
                                                    context);
                                              }

                                              break;
                                            case VehicleAction.create:
                                              final didComplete = await context
                                                  .read<VehiclesCubit>()
                                                  .createVehicle(
                                                    pool: poolDropdownValue!,
                                                    availability:
                                                        availabilitiesDropdownValue!,
                                                    generalStatus:
                                                        generalStatusDropdownValue!,
                                                    vehicleType:
                                                        vehicleTypeDropdownValue!,
                                                    displayName:
                                                        displayNameController
                                                            .text,
                                                    vin: vinController.text,
                                                    licencePlate:
                                                        licencePlatesController
                                                            .text,
                                                    model: modelController.text,
                                                    type: typeController.text,
                                                  );
                                              if (didComplete) {
                                                return Util.dismissDialog(
                                                    context);
                                              }
                                              break;

                                            default:
                                          }
                                        },
                                        onDelete: () async {
                                          await Util.showConfirmDialog2(context,
                                              message:
                                                  'Delete ${widget.vehicleToBeUpdated!.displayName}?',
                                              onConfirm: () async {
                                            await context
                                                .read<VehiclesCubit>()
                                                .deleteVehicle(
                                                  vehicleId: widget
                                                      .vehicleToBeUpdated!.id,
                                                );

                                            return Util.dismissDialog(context);
                                          });
                                        }))
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )),
          )),
    );
  }

  List<Pool> _getPoolsFromVehiclesCubit({required BuildContext context}) {
    final vehiclesCubitState = context.read<VehiclesCubit>().state;

    if (vehiclesCubitState is VehiclesLoaded) {
      return vehiclesCubitState.pools;
    }
    return [];
  }

  List<GeneralStatus> _getGeneralStatusesFromVehiclesCubit(
      {required BuildContext context}) {
    final vehiclesCubitState = context.read<VehiclesCubit>().state;
    if (vehiclesCubitState is VehiclesLoaded) {
      return vehiclesCubitState.generalStatuses;
    }
    return [];
  }

  List<VehicleType> _getVehicleTypesFromVehiclesCubit(
      {required BuildContext context}) {
    final vehiclesCubitState = context.read<VehiclesCubit>().state;
    if (vehiclesCubitState is VehiclesLoaded) {
      return vehiclesCubitState.vehicleTypes;
    }
    return [];
  }

  List<Availability> _getAvailabilitiesFromVehiclesCubit(
      {required BuildContext context}) {
    final vehiclesCubitState = context.read<VehiclesCubit>().state;
    if (vehiclesCubitState is VehiclesLoaded) {
      return vehiclesCubitState.availabilities;
    }
    return [];
  }

  String _dialogTitle({required BuildContext context}) {
    switch (widget.action) {
      case VehicleAction.update:
        return MyLocalization.of(context)!.updateVehicle;
      case VehicleAction.create:
        return MyLocalization.of(context)!.createVehicle;
      case VehicleAction.delete:
        return MyLocalization.of(context)!.deleteVehicle;
      default:
        return '';
    }
  }

  Widget _buildBottomButtons({
    required BoxConstraints constraints,
    required BuildContext context,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required VoidCallback onDelete,
    required bool canClickConfirm,
    required VehicleAction dialogAction,
  }) {
    if (constraints.maxWidth <= 483) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CancelButton(onPressed: onCancel),
          const SizedBox(height: 10),
          ConfirmButton(
            onPressed: onConfirm,
            canClick: canClickConfirm,
          ),
          if (dialogAction == VehicleAction.update) ...[
            const SizedBox(height: 10),
            DeleteButton(onPressed: onDelete),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (dialogAction == VehicleAction.update) ...[
          DeleteButton(onPressed: onDelete),
          const SizedBox(width: 10),
        ],
        CancelButton(onPressed: onCancel),
        const SizedBox(width: 10),
        ConfirmButton(
          onPressed: onConfirm,
          canClick: canClickConfirm,
        ),
      ],
    );
  }
}
