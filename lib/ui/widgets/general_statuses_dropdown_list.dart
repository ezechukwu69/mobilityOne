import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/general_statuses_dropdown_list_cubit/general_statuses_dropdown_list_state.dart';
import 'package:mobility_one/blocs/general_statuses_dropdown_list_cubit/general_statuses_dropdown_list_cubit.dart';
import 'package:mobility_one/models/general_status.dart';
import 'package:mobility_one/ui/widgets/dropdown_list_entry.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_icon_button.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class GeneralStatusesDropdownList extends StatelessWidget {
  GeneralStatusesDropdownList();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralStatusesDropdownListCubit, GeneralStatusesDropdownListState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MyLocalization.of(context)!.generalStatus,
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
                      child: state.availableGeneralStatuses.isEmpty
                          ? Text(
                              MyLocalization.of(context)!.noAvailableGeneralStatuses,
                              style: MyTextStyles.dataTableText.copyWith(color: MyColors.white),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: _buildPlaceholderOrSelectedGeneralStatusName(
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
                                          .read<GeneralStatusesDropdownListCubit>()
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
                          itemCount: state.availableGeneralStatuses.length,
                          itemBuilder: (context, index) {
                            return _buildDropdownListEntry(
                              state: state,
                              entry: state.availableGeneralStatuses[index],
                              onPressed: () {
                                context.read<GeneralStatusesDropdownListCubit>().updateSelectedGeneralStatus(
                                      selectedGeneralStatus: state.availableGeneralStatuses[index],
                                    );
                              },
                            ); //TODOD check with Rendulic if Name of GeneralStatus should be non nullable
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

  Text _buildPlaceholderOrSelectedGeneralStatusName(
      {required GeneralStatusesDropdownListState state, required BuildContext context}) {
    if (state.selectedGeneralStatus != null) {
      return Text(
        state.selectedGeneralStatus!.name,
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
      {required GeneralStatusesDropdownListState state,
      required GeneralStatus entry,
      required VoidCallback onPressed}) {
    if (state.isExpanded && state.selectedGeneralStatus != null) {
      if (state.selectedGeneralStatus!.id == entry.id) {
        return DropdownListEntry(
          isSelected: true,
          onPressed: () {
            //do nothing
          },
          child: Text(
            entry.name,
            style: MyTextStyles.dataTableText.copyWith(color: MyColors.dataTableBackgroundColor),
          ),
        );
      }
    }
    return DropdownListEntry(
      onPressed: onPressed,
      child: Text(
        entry.name,
        style: MyTextStyles.dataTableText,
      ),
    );
  }
}
