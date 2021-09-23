import 'package:flutter/material.dart';
import 'package:mobility_one/util/filter_group.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class FilterGroupContainer extends StatelessWidget {
  const FilterGroupContainer({
    Key? key,
    required this.filterGroup,
    required this.selectedFilters,
  }) : super(key: key);

  final FilterGroup filterGroup;
  final List<Filter> selectedFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${filterGroup.groupName}',
            style: MyTextStyles.dataTableHeading,
          ),
          SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filterGroup.filters.map(
              (filter) {
                return StatefulBuilder(builder: (context, _state) {
                  return FilterChip(
                      backgroundColor: MyColors.mobilityOneBlackColor,
                      side: BorderSide(color: MyColors.mobilityOneBlackColor),
                      selected: filter.isSelected,
                      selectedColor: MyColors.accentColor,
                      label: Text(
                        '${filter.label}',
                        style: MyTextStyles.dataTableText,
                      ),
                      onSelected: (selected) {
                        _state(() {
                          filter.isSelected = selected;

                          if (selected) {
                            selectedFilters.add(filter);
                          } else {
                            selectedFilters.remove(filter);
                          }
                        });
                      });
                });
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
