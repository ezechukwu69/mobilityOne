import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/vehicle_types_cubit/vehicle_types_cubit.dart';
import 'package:mobility_one/models/vehicle_type.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/my_text_form_field.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/util/util.dart';

enum VehicleTypeAction { create, update, delete }

class VehicleTypeDialog extends StatefulWidget {
  final VehicleTypeAction action;
  final VehicleType? vehicletypeToBeUpdated;
  const VehicleTypeDialog({required this.action, this.vehicletypeToBeUpdated});

  @override
  _VehicleTypeDialogState createState() => _VehicleTypeDialogState();
}

class _VehicleTypeDialogState extends State<VehicleTypeDialog> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    if (widget.vehicletypeToBeUpdated != null && widget.action == VehicleTypeAction.update) {
      nameController.text = widget.vehicletypeToBeUpdated!.name;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: MyColors.backgroundCardColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(19.0693),
                ),
                border: Border.all(color: Color(0xFF3A3A4E), width: 1)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
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
                      const SizedBox(height: 60),
                      MyTextFormField(
                        controller: nameController,
                        label: 'Name',
                      ),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: BlocBuilder<VehicleTypesCubit, VehicleTypesState>(
                          builder: (context, state) {
                            return _buildBottomButtons(
                              context: context,
                              constraints: constraints,
                              canClickConfirm: true,
                              onCancel: () {
                                Util.dismissDialog(context);
                              },
                              onConfirm: () async {
                                switch (widget.action) {
                                  case VehicleTypeAction.update:
                                    final didComplete = await context
                                        .read<VehicleTypesCubit>()
                                        .updateVehicleType(
                                          vehicletypeToBeUpdated:
                                              widget.vehicletypeToBeUpdated!,
                                          name: nameController.text,
                                        );
                                    if (didComplete) {
                                      return Util.dismissDialog(context);
                                    }

                                    break;
                                  case VehicleTypeAction.create:
                                    final didComplete = await context
                                        .read<VehicleTypesCubit>()
                                        .createVehicleType(
                                          name: nameController.text,
                                        );
                                    if (didComplete) {
                                      return Util.dismissDialog(context);
                                    }
                                    break;
                                  case VehicleTypeAction.delete:
                                    //TODO
                                    break;
                                  default:
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _dialogTitle({required BuildContext context}) {
    switch (widget.action) {
      case VehicleTypeAction.update:
        return 'Edit VehicleType';
      case VehicleTypeAction.create:
        return 'Create VehicleType';
      case VehicleTypeAction.delete:
        return 'Delete VehicleType';
      default:
        return '';
    }
  }

  Widget _buildBottomButtons({
    required BoxConstraints constraints,
    required BuildContext context,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required bool canClickConfirm,
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
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
