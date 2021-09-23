import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool? autofocus;
  final bool isPasswordField;
  final TextInputType? inputType;
  final Function(BuildContext, String?)? fieldValidator;
  final bool expanded;
  const MyTextFormField(
      {required this.controller,
      required this.label,
      this.autofocus,
      this.isPasswordField = false,
      this.fieldValidator,
        this.inputType,
      this.expanded = false});

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {

  var hidePassword = true;

  @override
  Widget build(BuildContext context) {
    Widget textField = LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: widget.expanded ? null : 380,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: MyTextStyles.dataTableHeading,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autofocus: widget.autofocus ?? false,
                  controller: widget.controller,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  obscureText: widget.isPasswordField ? hidePassword : false,
                  enableSuggestions: widget.isPasswordField,
                  autocorrect: widget.isPasswordField,
                  decoration: InputDecoration(
                    // labelText: label,
                    fillColor: MyColors.textFormFieldBackgroundColor,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                        borderSide: BorderSide(
                            color: MyColors.textFormFieldBackgroundColor)),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    labelStyle: MyTextStyles.dataTableText,
                    suffixIcon: widget.isPasswordField
                        ? MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              child: Icon(
                                Icons.remove_red_eye_rounded,
                                color: MyColors.cardTextColor,
                              ),
                            ),
                          )
                        : null,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(14),
                      ),
                      borderSide:
                          BorderSide(color: Color(0xff9797AC), width: 1),
                    ),
                  ),
                  style: MyTextStyles.dataTableText.copyWith(
                      fontSize:
                          hidePassword && widget.isPasswordField ? 30 : 14),
                  validator: (text) {
                    if (widget.fieldValidator != null) {
                      return widget.fieldValidator!(context, text);
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    return widget.expanded ? Expanded(child: textField) : textField;
  }
}
