import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/cases_type_cubit/cases_type_cubit.dart';
import 'package:mobility_one/blocs/cases_type_cubit/cases_type_state.dart';
import 'package:mobility_one/blocs/persons_cubit/persons_cubit.dart';
import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/models/dropdown_option.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/repositories/accounts_repository.dart';
import 'package:mobility_one/repositories/cases_type_repository.dart';
import 'package:mobility_one/repositories/org_units_repository.dart';
import 'package:mobility_one/repositories/persons_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/date_picker_button.dart';
import 'package:mobility_one/ui/widgets/dropdown_menu.dart';
import 'package:mobility_one/ui/widgets/hour_picker_button.dart';
import 'package:mobility_one/ui/widgets/my_text_form_field.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_fields_validations.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_simple_circular_progress_indicator.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/util/util.dart';

enum CaseDialogOperation { NEW, UPDATE }

class CaseDialog extends StatefulWidget {
  final CaseDialogOperation caseDialogOperation;
  final Vehicle vehicle;
  final Case? selectedCase;
  final Function? onDeleteCase;
  final Function? onConfirm;
  const CaseDialog({required this.caseDialogOperation, required this.vehicle, this.onDeleteCase, this.onConfirm, this.selectedCase});

  @override
  _CaseDialogState createState() => _CaseDialogState();
}

class _CaseDialogState extends State<CaseDialog> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedCaseTypeId;
  String? _selectedPersonId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  DateTime _expectedEndDate = DateTime.now();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _mileageUnitController = TextEditingController();

  @override
  void initState() {
    if (widget.selectedCase != null && widget.caseDialogOperation == CaseDialogOperation.UPDATE) {
      _nameController.text = widget.selectedCase!.name ?? '';
      _commentController.text = widget.selectedCase!.comment ?? '';
      _descriptionController.text = widget.selectedCase!.detailedDescription ?? '';
      _mileageController.text = widget.selectedCase!.mileage.toString();
      _mileageUnitController.text = widget.selectedCase!.mileageUnit.toString();
      _startDate = widget.selectedCase!.startTime;
      _endDate = widget.selectedCase!.endTime;
      _expectedEndDate = widget.selectedCase!.expectedEndTime;
      _selectedCaseTypeId = widget.selectedCase!.caseTypeId;
      _selectedPersonId = widget.selectedCase!.assigneeId;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonsCubit>(
          create: (context) => PersonsCubit(
            personsRepository: context.read<PersonsRepository>(),
            tenantsRepository: context.read<TenantsRepository>(),
            orgUnitsRepository: context.read<OrgUnitsRepository>(),
            accountsRepository: context.read<AccountsRepository>(),
          )..getDataFromApi(),
        ),
        BlocProvider(
          create: (context) => CasesTypeCubit(
            tenantsRepository: context.read<TenantsRepository>(),
            casesTypeRepository: context.read<CasesTypeRepository>(),
          )..getDataFromApi(),
        )
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(color: MyColors.backgroundCardColor),
            padding: EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Container(
                    width: 380,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isUpdatingCase ? MyLocalization.of(context)!.editCase : MyLocalization.of(context)!.newCase,
                                  style: MyTextStyles.dataTableTitle,
                                ),
                                Spacer(),
                                _isUpdatingCase
                                    ? IconButton(
                                        onPressed: () {
                                          var alertDialog = AlertDialog(
                                            title: Text(MyLocalization.of(context)!.deleteCase),
                                            content: Text(MyLocalization.of(context)!.deleteCaseConfirmation),
                                            actions: [
                                              ConfirmButton(onPressed: () {
                                                if (widget.onDeleteCase != null) {
                                                  widget.onDeleteCase!();
                                                  Navigator.pop(context);
                                                }
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
                                    : Container(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   width: 50,
                                    //   height: 50,
                                    //   decoration: BoxDecoration(
                                    //       image: DecorationImage(image: NetworkImage(vehicle.), fit: BoxFit.cover),
                                    //       borderRadius: BorderRadius.all(
                                    //         Radius.circular(50),
                                    //       )),
                                    // ),
                                    // SizedBox(
                                    //   width: 8,
                                    // ),
                                    Text(
                                      widget.vehicle.displayName!,
                                      style: TextStyle(color: MyColors.cardTextColor, fontSize: 14),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Text(
                                MyLocalization.of(context)!.caseType,
                                style: TextStyle(color: MyColors.cardTextColor, fontSize: 16),
                              ),
                              Spacer(),
                              BlocBuilder<CasesTypeCubit, CasesTypeState>(
                                builder: (context, state) {
                                  if (state is CasesTypeLoaded) {
                                    _selectedCaseTypeId ??= state.casesType.first.id;
                                    return DropDownMenu(
                                      dropDownMenuOptions: state.casesType.map((e) => DropDownOption(label: e.name, value: e.id)).toList(),
                                      value: _selectedCaseTypeId,
                                      onSelection: (option) {
                                        setState(() {
                                          _selectedCaseTypeId = option.value;
                                        });
                                      },
                                    );
                                  } else {
                                    return MySimpleCircularProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Text(
                                MyLocalization.of(context)!.assigneeTo,
                                style: TextStyle(color: MyColors.cardTextColor, fontSize: 16),
                              ),
                              Spacer(),
                              BlocBuilder<PersonsCubit, PersonsState>(
                                builder: (context, state) {
                                  if (state is PersonsLoaded) {
                                    _selectedPersonId ??= state.persons.first.id;
                                    return DropDownMenu(
                                      dropDownMenuOptions: state.persons.map((e) => DropDownOption(label: e.firstName!, value: e.id)).toList(),
                                      value: _selectedPersonId,
                                      onSelection: (option) {
                                        setState(() {
                                          _selectedPersonId = option.value;
                                        });
                                      },
                                    );
                                  } else {
                                    return MySimpleCircularProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MyTextFormField(
                            controller: _nameController,
                            label: MyLocalization.of(context)!.name,
                            autofocus: true,
                            fieldValidator: MyFieldValidations.validateRequiredField,
                          ),
                          MyTextFormField(controller: _commentController, label: MyLocalization.of(context)!.comment, fieldValidator: MyFieldValidations.validateRequiredField),
                          MyTextFormField(
                            controller: _descriptionController,
                            label: MyLocalization.of(context)!.description,
                            fieldValidator: MyFieldValidations.validateRequiredField,
                          ),
                          MyTextFormField(controller: _mileageController, label: MyLocalization.of(context)!.mileage, inputType: TextInputType.number, fieldValidator: MyFieldValidations.validateIsNumber),
                          MyTextFormField(
                            controller: _mileageUnitController,
                            label: MyLocalization.of(context)!.mileageUnit,
                            fieldValidator: MyFieldValidations.validateRequiredField,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'From:',
                            style: TextStyle(color: MyColors.cardTextColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: DatePickerButton(
                                  initialDate: _startDate,
                                  onDatePick: (newDate) {
                                    if (newDate != null) {
                                      setState(() {
                                        _startDate = newDate;
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: HourPickerButton(
                                  initialTime: TimeOfDay.fromDateTime(_startDate),
                                  onTimePick: (time) {
                                    if (time != null) {
                                      setState(() {
                                        _startDate = _changeDateTimeHour(_startDate, time);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'To:',
                            style: TextStyle(color: MyColors.cardTextColor, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: DatePickerButton(
                                  initialDate: _endDate,
                                  onDatePick: (newDate) {
                                    setState(() {
                                      if (newDate != null) {
                                        setState(() {
                                          _endDate = newDate;
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: HourPickerButton(
                                  initialTime: TimeOfDay.fromDateTime(_endDate),
                                  onTimePick: (time) {
                                    if (time != null) {
                                      setState(() {
                                        _endDate = _changeDateTimeHour(_endDate, time);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Expected end:',
                            style: TextStyle(color: MyColors.cardTextColor, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: DatePickerButton(
                                  initialDate: _expectedEndDate,
                                  onDatePick: (newDate) {
                                    setState(() {
                                      if (newDate != null) {
                                        setState(() {
                                          _expectedEndDate = newDate;
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: HourPickerButton(
                                  initialTime: TimeOfDay.fromDateTime(_expectedEndDate),
                                  onTimePick: (time) {
                                    if (time != null) {
                                      setState(() {
                                        _expectedEndDate = _changeDateTimeHour(_expectedEndDate, time);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          _buildBottomButtons(
                            context: context,
                            constraints: constraints,
                            canClickConfirm: true,
                            onCancel: () {
                              Util.dismissDialog(context);
                            },
                            onConfirm: () async {
                              if (_formKey.currentState!.validate()) {
                                if (widget.onConfirm != null) {
                                  widget.onConfirm!(name: _nameController.value.text, vehicleId: widget.vehicle.id, description: _descriptionController.value.text, endDate: _endDate, assigneeId: _selectedPersonId, caseTypeId: _selectedCaseTypeId!, comment: _commentController.value.text, expectedEndDate: _expectedEndDate, startDate: _startDate, mileage: double.parse(_mileageController.value.text), mileageUnit: _mileageUnitController.value.text);
                                }
                                Util.dismissDialog(context);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool get _isUpdatingCase {
    return widget.caseDialogOperation == CaseDialogOperation.UPDATE;
  }

  //TODO: move this code to a shared place to be reusable
  DateTime _changeDateTimeHour(DateTime date, TimeOfDay newHour) {
    return DateTime(date.year, date.month, date.day, newHour.hour, newHour.minute);
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
          SizedBox(height: 10),
          ConfirmButton(
            title: _isUpdatingCase ? MyLocalization.of(context)!.update : MyLocalization.of(context)!.create,
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
        Expanded(child: CancelButton(onPressed: onCancel)),
        const SizedBox(width: 10),
        Expanded(
          child: ConfirmButton(
            title: _isUpdatingCase ? MyLocalization.of(context)!.update : MyLocalization.of(context)!.create,
            onPressed: onConfirm,
            canClick: canClickConfirm,
          ),
        ),
      ],
    );
  }
}
