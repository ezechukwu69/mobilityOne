import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobility_one/util/my_colors.dart';

class DatePickerButton extends StatelessWidget {

  final DateTime initialDate;
  final Function(DateTime? date) onDatePick;

  const DatePickerButton({required this.initialDate, required this.onDatePick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: MyColors.mobilityOneBlackColor
      ),
      onPressed: () async {
        var date =  await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
        onDatePick(date);
      },
      child: Text(
        DateFormat('MMM d').format(initialDate),
      ),
    );
  }
}
