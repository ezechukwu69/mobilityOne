import 'package:flutter/material.dart';
import 'package:mobility_one/models/dropdown_option.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/date_picker_button.dart';
import 'package:mobility_one/ui/widgets/dropdown_menu.dart';
import 'package:mobility_one/ui/widgets/hour_picker_button.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/util/util.dart';

enum AssignmentDialogOperation { NEW, UPDATE }

class AssignmentDialog<T> extends StatefulWidget {
  T? item;
  DateTime startDate;
  DateTime endDate;
  Widget? choosedItem;
  String? dropDownLabel;
  List<DropDownOption>? dropDownOptions;
  dynamic preSelectedDropDownOption;
  final AssignmentDialogOperation assignmentDialogOperation;
  void Function(DropDownOption, DateTime, DateTime, T)? onComplete;
  void Function()? onDeleteAssignment;
  AssignmentDialog({required this.startDate, required this.endDate, required this.choosedItem, required this.dropDownLabel, required this.dropDownOptions, required this.onComplete, required this.item, this.preSelectedDropDownOption, required this.assignmentDialogOperation, this.onDeleteAssignment});

  @override
  _AssignmentDialogState createState() => _AssignmentDialogState();
}

class _AssignmentDialogState extends State<AssignmentDialog> {
  late DropDownOption _selectedOption;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.preSelectedDropDownOption != null ? widget.dropDownOptions!.firstWhere((element) => element.value == widget.preSelectedDropDownOption) : widget.dropDownOptions![0];
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
            decoration: BoxDecoration(color: MyColors.backgroundCardColor),
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                    child: Container(
                  width: 380,
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
                              _isUpdatingAssignment ? MyLocalization.of(context)!.editAssignment : MyLocalization.of(context)!.newAssignment,
                              style: MyTextStyles.dataTableTitle,
                            ),
                            Spacer(),
                            _isUpdatingAssignment
                                ? IconButton(
                                    onPressed: () {
                                      var alertDialog = AlertDialog(
                                        title: Text('Delete Assignment'),
                                        content: Text('If you click on confirm the assignment will be deleted from the system.'),
                                        actions: [
                                          ConfirmButton(onPressed: () {
                                            if (widget.onDeleteAssignment != null) {
                                              widget.onDeleteAssignment!();
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
                      widget.choosedItem ?? Container(),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.dropDownLabel ?? '',
                            style: TextStyle(color: MyColors.cardTextColor, fontSize: 16),
                          ),
                          Spacer(),
                          DropDownMenu(
                            dropDownMenuOptions: widget.dropDownOptions!,
                            value: _selectedOption.value,
                            onSelection: (option) {
                              setState(() {
                                _selectedOption = option;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
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
                          if (widget.onComplete != null) {
                            widget.onComplete!(_selectedOption, _startDate, _endDate, widget.item);
                          }
                          Util.dismissDialog(context);
                        },
                      )
                    ],
                  ),
                ));
              },
            )),
      ),
    );
  }

  bool get _isUpdatingAssignment {
    return widget.assignmentDialogOperation == AssignmentDialogOperation.UPDATE;
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
            title: _isUpdatingAssignment ? 'Update' : 'Create',
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
            title: _isUpdatingAssignment ? 'Update' : 'Create',
            onPressed: onConfirm,
            canClick: canClickConfirm,
          ),
        ),
      ],
    );
  }

  DateTime _changeDateTimeHour(DateTime date, TimeOfDay newHour) {
    return DateTime(date.year, date.month, date.day, newHour.hour, newHour.minute);
  }
}
