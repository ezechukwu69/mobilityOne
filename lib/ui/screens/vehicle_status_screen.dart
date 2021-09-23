import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_cubit.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_state.dart';
import 'package:mobility_one/blocs/vehicle_status_cubit/cubit/vehiclestatus_cubit.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/custom_kanban.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class VehicleStatusFilterGroup {
  final String groupName;
  final List<VehicleStatusFilter> filters;
  VehicleStatusFilterGroup({required this.groupName, required this.filters});
}

class VehicleStatusFilter extends Equatable {
  final String label;
  final dynamic value;
  final String filterName;
  bool isSelected;

  VehicleStatusFilter(
      {required this.label,
      required this.value,
      required this.isSelected,
      required this.filterName});

  @override
  List<Object?> get props => [label, value];
}

class VehicleStatusScreen extends StatelessWidget {
  const VehicleStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleStatusCubit()..mockVehicleStatus(),
      child: _VehicleStatusScreen(),
    );
  }
}

class _VehicleStatusScreen extends StatefulWidget {
  const _VehicleStatusScreen();
  @override
  __VehicleStatusScreenState createState() => __VehicleStatusScreenState();
}

class __VehicleStatusScreenState extends State<_VehicleStatusScreen> {
  final List<VehicleStatusFilter> _selectedChipsFilters = [];

  @override
  Widget build(BuildContext context) {
    var deviceheight = MediaQuery.of(context).size.height;
    return BlocBuilder<VehicleStatusCubit, VehicleStatusState>(
      builder: (context, state) {
        if (state is VehicleStatusLoading) {
          return MyCircularProgressIndicator();
        } else if (state is VehicleStatusFetched) {
          return buildVehicleStatus(deviceheight, state);
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildVehicleStatus(
      double deviceheight, VehicleStatusFetched vehiclestatusstate) {
    return BlocBuilder<GeneralSearchCubit, GeneralSearchState>(
      builder: (context, state) {
        if (state is GeneralSearchMakeSearch) {
          var vehicleStatusCubit = context.read<VehicleStatusCubit>();
          if (state.searchText.isEmpty) {
            vehicleStatusCubit.mockVehicleStatus();
          } else {
            vehicleStatusCubit.searchItems(state.searchText);
          }
          context.read<GeneralSearchCubit>().searchExecuted();
        }
        return Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
          child: Container(
            height: deviceheight - 160,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Color(0xff2B2B41),
              borderRadius: BorderRadius.circular(10),
            ),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints cons) {
              if (cons.maxWidth < 1300) {
                return Column(
                  children: [
                    filterButton(vehiclestatusstate),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: buildDragArea(deviceheight, context),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    filterButton(vehiclestatusstate),
                    buildDragArea(deviceheight, context),
                  ],
                );
              }
            }),
          ),
        );
      },
    );
  }

  Widget filterButton(VehicleStatusFetched state) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () {
          _showSideSheet(state);
        },
        icon: Icon(
          Icons.filter_list,
          color: MyColors.cardTextColor,
        ),
      ),
    );
  }

  Widget buildDragArea(double deviceheight, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomKanban(
            title: 'Needs Attention',
            key: Key('1'),
            list: (context.read<VehicleStatusCubit>().state
                    as VehicleStatusFetched)
                .needsAttentionList),
        CustomKanban(
            title: 'Driver Unassigned',
            key: Key('5'),
            list: (context.read<VehicleStatusCubit>().state
                    as VehicleStatusFetched)
                .driverUnassignedList),
        CustomKanban(
            title: 'In Maintenance',
            key: Key('2'),
            list: (context.read<VehicleStatusCubit>().state
                    as VehicleStatusFetched)
                .inMaintanceList),
        CustomKanban(
            title: 'Recently Handled',
            key: Key('3'),
            list: (context.read<VehicleStatusCubit>().state
                    as VehicleStatusFetched)
                .recentlyHandledList),
        CustomKanban(
            title: 'All Vehicles',
            key: Key('4'),
            list: (context.read<VehicleStatusCubit>().state
                    as VehicleStatusFetched)
                .allVehiclesList),
      ],
    );
  }

  Function()? _showSideSheet(
      VehicleStatusFetched state) {
    showGeneralDialog(
      barrierLabel: 'Barrier',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            child: Container(
              height: double.infinity,
              width: 300,
              decoration: BoxDecoration(
                color: MyColors.backgroundCardColor,
              ),
              child: _buildFilterGroups(state),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(animation1),
          child: child,
        );
      },
    );
  }

  Widget _buildFilterGroups(
      VehicleStatusFetched vehicleStatusState) {
    // manually gived data to filter
    final List<VehicleStatusFilterGroup>? filterGroups = [
      VehicleStatusFilterGroup(
        groupName: 'Vehicle Type',
        filters: vehicleStatusState.vehicletypes
            .map((e) => VehicleStatusFilter(
                label: e.name,
                value: e.id,
                filterName: 'VehicleTypeId',
                isSelected: _selectedChipsFilters
                        .indexWhere((element) => element.value == e.id) !=
                    -1))
            .toList(),
      ),
      VehicleStatusFilterGroup(
        groupName: 'Pool',
        filters: vehicleStatusState.pools
            .map((e) => VehicleStatusFilter(
                label: e.name,
                value: e.id,
                filterName: 'PoolId',
                isSelected: _selectedChipsFilters
                        .indexWhere((element) => element.value == e.id) !=
                    -1))
            .toList(),
      ),
      VehicleStatusFilterGroup(
        groupName: 'Vehicle Stats',
        filters: vehicleStatusState.vehicleStats
            .map((e) => VehicleStatusFilter(
                label: e.availability,
                value: e.availability,
                filterName: 'GeneralStatusId',
                isSelected: _selectedChipsFilters.indexWhere(
                        (element) => element.value == e.availability) !=
                    -1))
            .toList(),
      )
    ];
    // blocprovider for accesing filtercards method
    return BlocProvider(
      create: (context) => VehicleStatusCubit(),
      child: StatefulBuilder(
        builder: (statecontext, _state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...filterGroups!.map(
                    (e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.groupName,
                          style: MyTextStyles.dataTableHeading,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: e.filters
                              .map(
                                (e) => FilterChip(
                                    backgroundColor:
                                        MyColors.mobilityOneBlackColor,
                                    side: BorderSide(
                                        color: MyColors.mobilityOneBlackColor),
                                    selected: e.isSelected,
                                    selectedColor: MyColors.accentColor,
                                    label: Text(
                                      e.label,
                                      style: MyTextStyles.dataTableText,
                                    ),
                                    onSelected: (selected) {
                                      _state(() {
                                        e.isSelected = selected;
                                      });
                                    }),
                              )
                              .toList(),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ConfirmButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<VehicleStatusCubit>().filterCards();
                      },
                      title:
                          MyLocalization.of(context)!.filterLabel.toUpperCase(),
                    ),
                  )
                ].toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
