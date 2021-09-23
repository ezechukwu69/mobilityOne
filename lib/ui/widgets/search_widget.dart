import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_cubit.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_state.dart';
import 'package:mobility_one/util/my_images.dart';
import 'package:mobility_one/util/my_localization.dart';
import '../dialogs/search_dialog.dart';

class SearchWidget extends StatefulWidget {
  final bool showFixedTextField;

  SearchWidget({this.showFixedTextField = true});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  Timer? searchOnStoppedTyping;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.showFixedTextField ? 361 : 55,
      padding: EdgeInsets.only(top: 5),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            widget.showFixedTextField
                ? Container(
                    height: 45,
                    child: BlocBuilder<GeneralSearchCubit, GeneralSearchState>(
                      builder: (context, state) {
                        var searchFieldLabel = '';
                        if (state is GeneralSearchChangedPlaceholder) {
                          searchFieldLabel = state.placeholder;
                        }
                        return TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: searchFieldLabel,
                            labelStyle: TextStyle(color: Color(0xFFCECEF4), fontSize: 14),
                            filled: true,
                            fillColor: Color(0xFF15151F),
                            contentPadding: EdgeInsets.only(left: 26, right: 64),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                color: Color(0xFF3A3A4E),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(color: Color(0xFF3A3A4E), width: 1),
                            ),
                          ),
                          onChanged: _onChangeHandler,
                        );
                      },
                    ),
                  )
                : Container(),
            Positioned(
              top: 22,
              right: 0.6,
              child: GestureDetector(
                  onTap: () {
                    if (!widget.showFixedTextField) {
                      _openShowDialog(context);
                    }
                  },
                  child: SvgPicture.asset(
                    MyImages.searchButton,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _openShowDialog(context) async {
    final search = await showDialog<String>(context: context, builder: (_) => SearchDialog());
  }

  void _onChangeHandler(value ) {
    const duration = Duration(milliseconds: 500); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping = Timer(duration, () => _search(value)));
  }

  void _search(String text) {
    context.read<GeneralSearchCubit>().notifySearch(text);
  }
}
