import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/cases_type_cubit/cases_type_cubit.dart';
import 'package:mobility_one/blocs/org_units_dropdown_list_cubit/org_units_dropdown_list_cubit.dart';
import 'package:mobility_one/blocs/org_units_dropdown_list_cubit/org_units_dropdown_list_state.dart';
import 'package:mobility_one/blocs/persons_cubit/persons_cubit.dart';
import 'package:mobility_one/models/case_type.dart';
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

enum CaseTypeDialogAction { create, update, delete }

class CaseTypeDialog extends StatefulWidget {
  final CaseTypeDialogAction action;
  final CaseType? caseTypeToBeUpdated;
  const CaseTypeDialog({required this.action, this.caseTypeToBeUpdated});

  @override
  _CaseTypeDialogState createState() => _CaseTypeDialogState();
}

class _CaseTypeDialogState extends State<CaseTypeDialog> {
  late TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.caseTypeToBeUpdated != null && widget.action == CaseTypeDialogAction.update) {
      nameController.text = widget.caseTypeToBeUpdated!.name;
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
            width: 850,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MyColors.backgroundCardColor,
              borderRadius: BorderRadius.all(
                Radius.circular(19.0693),
              ),
              border: Border.all(color: Color(0xFF3A3A4E), width: 1),
            ),
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
                            ),
                            Spacer(),
                            widget.action == CaseTypeDialogAction.update
                                ? IconButton(
                                    onPressed: () {
                                      var alertDialog = AlertDialog(
                                        title: Text(MyLocalization.of(context)!.deleteCaseType),
                                        content: Text(MyLocalization.of(context)!.deleteCaseTypeConfirmation),
                                        actions: [
                                          ConfirmButton(onPressed: () async {
                                            await context.read<CasesTypeCubit>().deleteCaseType(widget.caseTypeToBeUpdated!.id);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }),
                                          CancelButton(onPressed: () {
                                            Navigator.pop(context);
                                          })
                                        ],
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alertDialog;
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: MyColors.cardTextColor,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          MyTextFormField(
                            controller: nameController,
                            label: MyLocalization.of(context)!.name,
                          ),
                        ]),
                      ]),
                      const SizedBox(height: 60),
                      _buildBottomButtons(
                        context: context,
                        constraints: constraints,
                        canClickConfirm: true,
                        onCancel: () {
                          Util.dismissDialog(context);
                        },
                        onConfirm: () async {
                          switch (widget.action) {
                            case CaseTypeDialogAction.update:
                              Util.dismissDialog(context);
                              final updatedCaseType = widget.caseTypeToBeUpdated!.copyWith(name: nameController.value.text);
                              await context.read<CasesTypeCubit>().updateCaseType(updatedCaseType: updatedCaseType);
                              break;
                            case CaseTypeDialogAction.create:
                              Util.dismissDialog(context);
                              await context.read<CasesTypeCubit>().createCaseType(name: nameController.value.text);
                              break;
                            case CaseTypeDialogAction.delete:
                              //TODO call function to delete caseType
                              break;
                            default:
                          }
                        },
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
      case CaseTypeDialogAction.update:
        return MyLocalization.of(context)!.updateCaseType;
      case CaseTypeDialogAction.create:
        return MyLocalization.of(context)!.createCaseType;
      case CaseTypeDialogAction.delete:
        return MyLocalization.of(context)!.deleteCaseType;
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
