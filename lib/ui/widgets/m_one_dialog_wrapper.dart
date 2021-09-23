import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';

class MOneDialogWrapper extends StatelessWidget {
  const MOneDialogWrapper({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Material(
        color: Colors.transparent,
        child: Align(
          child: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .5,
            ),
            decoration: BoxDecoration(
              color: MyColors.backgroundCardColor,
              borderRadius: BorderRadius.all(
                Radius.circular(19.0693),
              ),
              border: Border.all(color: Color(0xFF3A3A4E), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
