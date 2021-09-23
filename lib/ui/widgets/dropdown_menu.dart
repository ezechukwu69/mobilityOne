import 'package:flutter/material.dart';
import 'package:mobility_one/models/dropdown_option.dart';
import 'package:mobility_one/util/my_colors.dart';

class DropDownMenu extends StatefulWidget {
  final List<DropDownOption> dropDownMenuOptions;
  final Function onSelection;
  final dynamic value;

  DropDownMenu({required this.dropDownMenuOptions, required this.onSelection, this.value});

  @override
  _DropDownMenuState createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  dynamic dropDownMenuValue;
  @override
  void initState() {
    super.initState();
    dropDownMenuValue = widget.dropDownMenuOptions.isNotEmpty
        ? widget.value ?? widget.dropDownMenuOptions[0].value
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          width: 143,
          decoration: BoxDecoration(color: Color(0xFF15151F), borderRadius: BorderRadius.circular(12)),
        ),
        Theme(
          data: Theme.of(context).copyWith(canvasColor: Color(0xFF15151F)),
          child: DropdownButton(
            value: dropDownMenuValue,
            style: TextStyle(
              color: Color(0xFFCECEF4),
            ),
            icon: FittedBox(
              fit: BoxFit.contain,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: MyColors.accentColor,
                  size: 30,
                ),
              ),
            ),
            underline: Container(),
            items: widget.dropDownMenuOptions.map((dropDownOption) {
              return DropdownMenuItem(
                value: dropDownOption.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: FittedBox(fit: BoxFit.contain, child: Text(dropDownOption.label))),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(
                () {
                  dropDownMenuValue = value;
                  widget.onSelection(widget.dropDownMenuOptions.firstWhere((element) => element.value == value));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
