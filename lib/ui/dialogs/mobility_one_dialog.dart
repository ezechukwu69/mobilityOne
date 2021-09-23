import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobilityOneDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget? additionalWidget;
  const MobilityOneDialog({required this.title, required this.message, this.additionalWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            decoration: BoxDecoration(
              color:  Colors.white,
              borderRadius: BorderRadius.circular(27),
            ),
            constraints: BoxConstraints(maxHeight: 285),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],  //TODO close button
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(title, textAlign: TextAlign.center),
                ),
                const SizedBox(height: 28),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 38, right: 38),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                additionalWidget ?? const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
