import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class MyLabeledCheckbox extends StatelessWidget {
  const MyLabeledCheckbox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: EdgeInsets.zero,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label, style: MyTextStyles.dataTableText)),
            Checkbox(
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              fillColor: MaterialStateColor.resolveWith((state) => MyColors.mobilityOneBlackColor),
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
