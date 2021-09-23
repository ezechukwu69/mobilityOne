import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobility_one/models/mileage_report.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/date_picker_button.dart';
import 'package:mobility_one/ui/widgets/hour_picker_button.dart';
import 'package:mobility_one/ui/widgets/my_text_form_field.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_fields_validations.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/util/util.dart';

enum MileageReportOperation { NEW, UPDATE }

class MileageReportDialog extends StatefulWidget {
  final MileageReportOperation mileageReportOperation;
  final Vehicle vehicle;
  final MileageReport? selectedMileageReport;
  final Function? onDeleteMileageReport;
  final Function? onConfirm;
  const MileageReportDialog({required this.mileageReportOperation, required this.vehicle, this.onDeleteMileageReport, this.onConfirm, this.selectedMileageReport});

  @override
  _MileageReportDialogState createState() => _MileageReportDialogState();
}

class _MileageReportDialogState extends State<MileageReportDialog> {
  final _formKey = GlobalKey<FormState>();

  DateTime time = DateTime.now();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _measuringUnitController = TextEditingController();

  @override
  void initState() {
    if (widget.selectedMileageReport != null && widget.mileageReportOperation == MileageReportOperation.UPDATE) {
      _commentController.text = widget.selectedMileageReport!.comment;
      _valueController.text = widget.selectedMileageReport!.value.toString();
      time = widget.selectedMileageReport!.time;
      _measuringUnitController.text = widget.selectedMileageReport!.measuringUnit.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                _isUpdatingCase ? MyLocalization.of(context)!.editMileageReport : MyLocalization.of(context)!.newMileageReport,
                                style: MyTextStyles.dataTableTitle,
                              ),
                              Spacer(),
                              _isUpdatingCase
                                  ? IconButton(
                                onPressed: () {
                                  var alertDialog = AlertDialog(
                                    title: Text(MyLocalization.of(context)!.deleteMileageReport),
                                    content: Text(MyLocalization.of(context)!.deleteMileageReportConfirmation),
                                    actions: [
                                      ConfirmButton(onPressed: () {
                                        if (widget.onDeleteMileageReport != null) {
                                          widget.onDeleteMileageReport!();
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
                          height: 20,
                        ),
                        Text(
                          'Date:',
                          style: TextStyle(color: MyColors.cardTextColor, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DatePickerButton(
                                initialDate: time,
                                onDatePick: (newDate) {
                                  if (newDate != null) {
                                    setState(() {
                                      time = newDate;
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
                                initialTime: TimeOfDay.fromDateTime(time),
                                onTimePick: (_time) {
                                  if (_time != null) {
                                    setState(() {
                                      time = _changeDateTimeHour(time, _time);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        MyTextFormField(
                          controller: _commentController,
                          label: MyLocalization.of(context)!.comment,
                          autofocus: true,
                          fieldValidator: MyFieldValidations.validateRequiredField,
                        ),
                        MyTextFormField(controller: _valueController, label: MyLocalization.of(context)!.mileage, inputType: TextInputType.number, fieldValidator: MyFieldValidations.validateIsNumber),
                        MyTextFormField(
                          controller: _measuringUnitController,
                          label: MyLocalization.of(context)!.mileageUnit,
                          fieldValidator: MyFieldValidations.validateRequiredField,
                        ),
                        SizedBox(
                          height: 10,
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
                                widget.onConfirm!(comment: _commentController.value.text, vehicleId: widget.vehicle.id, date: time, mileage: double.parse(_valueController.value.text), measuringUnit: _measuringUnitController.value.text);
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
    );
  }

  bool get _isUpdatingCase {
    return widget.mileageReportOperation == MileageReportOperation.UPDATE;
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
