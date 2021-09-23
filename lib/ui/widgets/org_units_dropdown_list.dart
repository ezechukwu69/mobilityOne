import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/org_units_dropdown_list_cubit/org_units_dropdown_list_cubit.dart';
import 'package:mobility_one/blocs/org_units_dropdown_list_cubit/org_units_dropdown_list_state.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/ui/widgets/dropdown_list_entry.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_icon_button.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class OrgUnitsDropdownList extends StatelessWidget {
  OrgUnitsDropdownList();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrgUnitsDropdownListCubit, OrgUnitsDropdownListState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MyLocalization.of(context)!.orgUnit,
                style: MyTextStyles.dataTableHeading,
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    width: 380,
                    height: 47,
                    color: MyColors.mobilityOneBlackColor,
                    child: Center(
                      child: state.availableOrgUnits.isEmpty
                          ? Text(
                              MyLocalization.of(context)!.noAvailableOrgUnits,
                              style: MyTextStyles.dataTableText.copyWith(color: MyColors.white),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: _buildPlaceholderOrSelectedOrgUnitName(
                                      state: state, context: context),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: MyIconButton(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: MyColors.white,
                                    ),
                                    tooltip: MyLocalization.of(context)!.expand,
                                    onPressed: () {
                                      context
                                          .read<OrgUnitsDropdownListCubit>()
                                          .updateIsExpanded(isExpanded: true);
                                    },
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                  if (state.isExpanded)
                    RawScrollbar(
                      controller: scrollController,
                      isAlwaysShown: true,
                      thumbColor: MyColors.white,
                      child: Container(
                        width: 380,
                        constraints: BoxConstraints(maxHeight: 100),
                        color: MyColors.mobilityOneBlackColor,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: state.availableOrgUnits.length,
                          itemBuilder: (context, index) {
                            return _buildDropdownListEntry(
                              state: state,
                              entry: state.availableOrgUnits[index],
                              onPressed: () {
                                context.read<OrgUnitsDropdownListCubit>().updateSelectedOrgUnit(
                                      selectedOrgUnit: state.availableOrgUnits[index],
                                    );
                              },
                            ); //TODOD check with Rendulic if Name of OrgUnit should be non nullable
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Text _buildPlaceholderOrSelectedOrgUnitName(
      {required OrgUnitsDropdownListState state, required BuildContext context}) {
    if (state.selectedOrgUnit != null) {
      return Text(
        state.selectedOrgUnit!.name!,
        style: MyTextStyles.dataTableText.copyWith(color: MyColors.white),
      );
    }
    return Text(
      MyLocalization.of(context)!.pleaseSelect,
      style: MyTextStyles.dataTableText.copyWith(
        color: MyColors.white.withOpacity(0.5),
      ),
    );
  }

  DropdownListEntry _buildDropdownListEntry(
      {required OrgUnitsDropdownListState state,
      required OrgUnit entry,
      required VoidCallback onPressed}) {
    if (state.isExpanded && state.selectedOrgUnit != null) {
      if (state.selectedOrgUnit!.id == entry.id) {
        return DropdownListEntry(
          isSelected: true,
          onPressed: () {
            //do nothing
          },
          child: Text(
            entry.name!,
            style: MyTextStyles.dataTableText.copyWith(color: MyColors.dataTableBackgroundColor),
          ),
        );
      }
    }
    return DropdownListEntry(
      onPressed: onPressed,
      child: Text(
        entry.name!,
        style: MyTextStyles.dataTableText,
      ),
    );
  }
}
