import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';

// ignore: must_be_immutable
class MyDropDownFormField<Entity> extends StatefulWidget {
  //
  final String label;
  late bool wrapWithExpanded;
  late Entity value;
  final List<Entity> items;
  final Function(dynamic) onValueChanged;

  MyDropDownFormField({
    required this.label,
    required this.items,
    required this.value,
    required this.onValueChanged,
    this.wrapWithExpanded = false,
  });

  @override
  _MyDropDownFormFieldState<Entity> createState() =>
      _MyDropDownFormFieldState<Entity>(items: items);
}

class _MyDropDownFormFieldState<Entity> extends State<MyDropDownFormField> {
  late FocusNode focusNode;
  late bool entityInFocus = false;
  final List<Entity> items;

  _MyDropDownFormFieldState({required this.items});

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();

    focusNode.addListener(() {
      print('Has focus: ${focusNode.hasFocus}');
      setState(() {
        entityInFocus = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdown = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: MyTextStyles.dataTableHeading,
              ),
              const SizedBox(height: 12),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 13),
                  width: 380,
                  // height: 50,
                  decoration: ShapeDecoration(
                    color: MyColors.textFormFieldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.transparent,
                          width: 0,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    ),
                  ),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<Entity>(
                      value: widget.value,
                      icon: const Icon(Icons.arrow_downward),
                      focusNode: focusNode,
                      isExpanded: true,
                      isDense: true,
                      iconSize: 24,
                      elevation: 16,
                      dropdownColor: MyColors.backgroundColor,
                      style: const TextStyle(color: MyColors.white),
                      underline: Container(
                        height: 2,
                        color: entityInFocus
                            ? MyColors.accentColor
                            : Colors.transparent,
                      ),
                      onChanged: (Entity? newValue) {
                        setState(() {
                          widget.value = newValue!;
                          widget.onValueChanged(newValue);
                        });
                      },
                      items:
                          items.map<DropdownMenuItem<Entity>>((Entity value) {
                        return DropdownMenuItem<Entity>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ))
            ]));

    return widget.wrapWithExpanded ? Expanded(child: dropdown) : dropdown;
  }
}
