import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_localization.dart';

class SearchDialog extends StatelessWidget {

  SearchDialog();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 2,
          left: 4,
          right: 4,
          child: Card(
            child: TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: MyLocalization.of(context)!.searchFieldLabelText,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                    Navigator.of(context).pop();
                  }, color: Colors.grey[700],)
              ),
              onFieldSubmitted: (text) {
                Navigator.of(context).pop(text);
              },
            ),
          ),
        )
      ],
    );
  }
}