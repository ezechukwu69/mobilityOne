import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';

class HourPickerButton extends StatelessWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay? timeOfDay) onTimePick;
  const HourPickerButton({required this.initialTime, required this.onTimePick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: MyColors.mobilityOneBlackColor
      ),
      onPressed: () async {
        var selectedTime = await showTimePicker(context: context, initialTime: initialTime);
        onTimePick(selectedTime);
      },
      child: Text(
        initialTime.format(context)
      ),
    );
  }
}
