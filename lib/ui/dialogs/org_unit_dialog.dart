import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobility_one/blocs/hierarchy_cubit/hierarchy_cubit.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/my_text_form_field.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/util/util.dart';

class OrgUnitDialog extends StatefulWidget {
  final Tenant tenant;
  final OrgUnit? parentOrgUnit;

  const OrgUnitDialog({required this.tenant, this.parentOrgUnit});

  @override
  _OrgUnitDialogState createState() => _OrgUnitDialogState();
}

class _OrgUnitDialogState extends State<OrgUnitDialog> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
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
              decoration: BoxDecoration(color: MyColors.dataTableBackgroundColor),
              padding: EdgeInsets.all(20),
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
                                MyLocalization.of(context)!.createOrgUnit,
                                style: MyTextStyles.dataTableTitle,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        Container(
                          width: 380,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.parentOrgUnit != null) Text(MyLocalization.of(context)!.parentOrgUnit, style: MyTextStyles.dataTableHeading),
                              if (widget.parentOrgUnit != null)
                                Text(
                                  widget.parentOrgUnit!.name!,
                                  style: MyTextStyles.dataTableText,
                                ),
                              if (widget.parentOrgUnit != null)
                                SizedBox(
                                  height: 20,
                                ),
                              Text(
                                MyLocalization.of(context)!.tenant,
                                style: MyTextStyles.dataTableHeading,
                              ),
                              Text(
                                widget.tenant.name!,
                                style: MyTextStyles.dataTableText,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        MyTextFormField(
                          autofocus: true,
                          controller: nameController,
                          label: MyLocalization.of(context)!.orgName,
                        ),
                        const SizedBox(height: 60),
                        _buildBottomButtons(
                            constraints: constraints,
                            context: context,
                            onConfirm: () async {
                              if (nameController.text.isEmpty) {
                                await Util.showErrorDialog(context, description: MyLocalization.of(context)!.emptyOrganizationNameErrorDescription, title: MyLocalization.of(context)!.emptyOrganizationNameError, removePreviousDialog: false);
                              } else {
                                Util.dismissDialog(context);
                                await context.read<HierarchyCubit>().createOrgUnit(name: nameController.text, tenantId: widget.tenant.id, parentOrgUnitId: widget.parentOrgUnit?.id);
                              }
                            },
                            onCancel: () {
                              Util.dismissDialog(context);
                            },
                            canClickConfirm: true)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));
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
