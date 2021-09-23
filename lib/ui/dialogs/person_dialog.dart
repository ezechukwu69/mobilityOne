import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/org_units_dropdown_list_cubit/org_units_dropdown_list_cubit.dart';
import 'package:mobility_one/blocs/org_units_dropdown_list_cubit/org_units_dropdown_list_state.dart';
import 'package:mobility_one/blocs/persons_cubit/persons_cubit.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/models/person.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/my_text_form_field.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/util/util.dart';

import 'my_dropdown_form_field.dart';

enum PersonAction { create, update, delete }

class PersonDialog extends StatefulWidget {
  final PersonAction action;
  final Person? personToBeUpdated;
  const PersonDialog({required this.action, this.personToBeUpdated});

  @override
  _PersonDialogState createState() => _PersonDialogState();
}

class _PersonDialogState extends State<PersonDialog> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late OrgUnitsDropdownListCubit orgUnitsDropdownListCubit;
  late OrgUnit? orgUnitDropdownValue;
  @override
  void initState() {
    super.initState();
    orgUnitsDropdownListCubit = OrgUnitsDropdownListCubit();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    if (widget.personToBeUpdated != null &&
        widget.action == PersonAction.update) {
      firstNameController.text = widget.personToBeUpdated!.firstName ?? '';
      lastNameController.text = widget.personToBeUpdated!.lastName ?? '';
      emailController.text = widget.personToBeUpdated!.email ?? '';
      orgUnitDropdownValue = widget.personToBeUpdated!.orgUnit;
    } else {

      orgUnitDropdownValue = _getOrgUnitsFromPersonsCubit(context: context).first;
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    orgUnitsDropdownListCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        orgUnitsDropdownListCubit.updateIsExpanded(isExpanded: false);
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 850,
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
                      Column(children: [
                        Row(children: [
                          MyTextFormField(
                            controller: firstNameController,
                            label: MyLocalization.of(context)!.firstName,
                          ),
                          MyTextFormField(
                            controller: lastNameController,
                            label: MyLocalization.of(context)!.lastName,
                          ),
                        ]),
                        Row(children: [
                          MyTextFormField(
                            controller: emailController,
                            label: MyLocalization.of(context)!.email,
                          ),
                          MyDropDownFormField<OrgUnit>(
                            items:
                                _getOrgUnitsFromPersonsCubit(context: context),
                            label: 'Org. Unit',
                            value: orgUnitDropdownValue!,
                            onValueChanged: (value) {
                              orgUnitDropdownValue = value;
                            },
                          )
                        ]),
                      ]),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: BlocBuilder<OrgUnitsDropdownListCubit,
                            OrgUnitsDropdownListState>(
                          bloc: orgUnitsDropdownListCubit,
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
                                  case PersonAction.update:
                                    final didComplete = await context
                                        .read<PersonsCubit>()
                                        .updatePerson(
                                          personToBeUpdated:
                                              widget.personToBeUpdated!,
                                          orgUnit: orgUnitDropdownValue!,
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          email: emailController.text,
                                        );
                                    if (didComplete) {
                                      return Util.dismissDialog(context);
                                    }

                                    break;
                                  case PersonAction.create:
                                    final didComplete = await context
                                        .read<PersonsCubit>()
                                        .createPerson(
                                          orgUnit: orgUnitDropdownValue!,
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          email: emailController.text,
                                        );
                                    if (didComplete) {
                                      return Util.dismissDialog(context);
                                    }
                                    break;
                                  case PersonAction.delete:
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

  List<OrgUnit> _getOrgUnitsFromPersonsCubit({required BuildContext context}) {
    final personsCubitState = context.read<PersonsCubit>().state;
    if (personsCubitState is PersonsLoaded) {
      return personsCubitState.orgUnits
          .map((e) => OrgUnit(id: e.id, name: e.name, tenantId: e.tenantId))
          .toList();
    }
    return [];
  }

  String _dialogTitle({required BuildContext context}) {
    switch (widget.action) {
      case PersonAction.update:
        return MyLocalization.of(context)!.updatePerson;
      case PersonAction.create:
        return MyLocalization.of(context)!.createPerson;
      case PersonAction.delete:
        return MyLocalization.of(context)!.deletePerson;
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
