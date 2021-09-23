import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/pools_cubit/pools_cubit.dart';
import 'package:mobility_one/blocs/pools_cubit/pools_cubit.dart';
import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/repositories/pools_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/ui/dialogs/pool_dialog.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/util/util.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PoolFilter extends Equatable {
  final String label;
  final dynamic value;
  final String filterName;
  bool isSelected;

  PoolFilter(
      {required this.label,
      required this.value,
      required this.isSelected,
      required this.filterName});

  @override
  List<Object?> get props => [label, value];
}

class PoolFilterGroup {
  final String groupName;
  final List<PoolFilter> filters;
  PoolFilterGroup({required this.groupName, required this.filters});
}

class PoolsScreen extends StatelessWidget {
  const PoolsScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PoolsCubit>(
      create: (context) => PoolsCubit(
          poolsRepository: context.read<PoolsRepository>(),
          tenantsRepository: context.read<TenantsRepository>())
        ..getDataFromApi(),
      child: PoolsDataTable(),
    );
  }
}

class PoolPlutoGridRow extends PlutoRow {
  PoolPlutoGridRow({required this.pool, required this.cells})
      : super(cells: cells);
  Pool pool;
  @override
  Map<String, PlutoCell> cells;
}

class PoolsDataTable extends StatelessWidget {
  PoolsDataTable();
  final List<PlutoColumn> columns = [
    PlutoColumn(type: PlutoColumnType.text(), title: 'Pool Name', field: 'name')
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoolsCubit, PoolsState>(
      builder: (context, state) {
        print(state);
        if (state is PoolsLoaded) {
          final rows = _convertListOfPoolToListOfDataRow(
              data: [...state.pools], context: context);
          return poolsGrid(
            key: UniqueKey(),
            columns: columns,
            rows: rows,
            poolsLoaded: state,
          );
        } else if (state is PoolsLoading) {
          return Center(child: MyCircularProgressIndicator());
        } else if (state is PoolsError) {
          return Text(
            'Error',
            style: TextStyle(color: Colors.white),
          );
        }
        return const SizedBox();
      },
    );
  }

  List<PoolPlutoGridRow> _convertListOfPoolToListOfDataRow(
          {required List<Pool> data, required BuildContext context}) =>
      data
          .map((_pool) => PoolPlutoGridRow(
              pool: _pool, cells: {'name': PlutoCell(value: _pool.name)}))
          .toList();
}

class poolsGrid extends StatelessWidget {
  final List<PoolFilter> _selectedPoolFilters = [];
  poolsGrid({
    Key? key,
    required this.columns,
    required this.rows,
    required this.poolsLoaded,
  }) : super(key: key);
  final PoolsLoaded poolsLoaded;
  final List<PlutoColumn> columns;
  final List<PoolPlutoGridRow> rows;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark(),
        child: Center(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConfirmButton(
                title: 'New pool',
                onPressed: () async {
                  log('Started creating pool');
                  await Util.showMyDialog(
                    barrierDismissible: false,
                    barrierColorTransparent: false,
                    context: context,
                    child: BlocProvider.value(
                      value: context.read<PoolsCubit>(),
                      child: PoolDialog(
                        poolToBeUpdated: null,
                        action: PoolAction.create,
                      ),
                    ),
                  );
                },
                canClick: true,
              ),
              // CancelButton(
              //   title: 'Delete pool',
              //   onPressed: () async {
              //     log('Started deleting pool');
              //     await context.read<PoolsCubit>().deletePool();
              //   },
              // )
              IconButton(
                onPressed: () {
                  _showSideSheet(context, poolsLoaded);
                },
                icon: Icon(
                  Icons.filter_list,
                  color: MyColors.cardTextColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 140,
            child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: MyColors.backgroundCardColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(19.0693),
                    ),
                    border: Border.all(color: Color(0xFF3A3A4E), width: 1)),
                child: PlutoGrid(
                    configuration: PlutoGridConfiguration(
                        gridBackgroundColor: MyColors.backgroundCardColor,
                        enableColumnBorder: false,
                        gridBorderColor: MyColors.backgroundCardColor,
                        activatedColor: MyColors.backgroundColor,
                        cellTextStyle: TextStyle(color: MyColors.cardTextColor),
                        columnTextStyle:
                            TextStyle(color: MyColors.cardTextColor)),
                    mode: PlutoGridMode.select,
                    columns: columns,
                    rows: rows,
                    onSelected: (PlutoGridOnSelectedEvent e) async {
                      log('Started selecting pool');
                      await context
                          .read<PoolsCubit>()
                          .selectPool(pool: (e.row as PoolPlutoGridRow).pool);
                    },
                    onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent e) async {
                      log('Started creating pool');
                      await Util.showMyDialog(
                        barrierDismissible: false,
                        barrierColorTransparent: false,
                        context: context,
                        child: BlocProvider.value(
                          value: context.read<PoolsCubit>(),
                          child: PoolDialog(
                            poolToBeUpdated: (e.row as PoolPlutoGridRow).pool,
                            action: PoolAction.update,
                          ),
                        ),
                      );
                    })),
          )
        ])));
  }

  Function()? _showSideSheet(BuildContext context, PoolsLoaded poolsLoaded) {
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
              child: _buildFilterGroups(poolsLoaded),
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

  Widget _buildFilterGroups(PoolsLoaded poolsLoaded) {
    // manually gived data to filter
    final List<PoolFilterGroup>? filterGroups = [
      PoolFilterGroup(
        groupName: 'Pool',
        filters: poolsLoaded.pools
            .map((e) => PoolFilter(
                label: e.name,
                value: e.id,
                filterName: 'PoolId',
                isSelected: _selectedPoolFilters
                        .indexWhere((element) => element.value == e.id) !=
                    -1))
            .toList(),
      ),
    ];
    // blocprovider for accesing filtercards method
    return BlocProvider(
      create: (context) => PoolsCubit(
          poolsRepository: context.read<PoolsRepository>(),
          tenantsRepository: context.read<TenantsRepository>()),
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
                                        if (!_selectedPoolFilters.contains(e)) {
                                          _selectedPoolFilters.add(e);
                                        } else {
                                          _selectedPoolFilters.remove(e);
                                        }
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
                        print(_selectedPoolFilters);
                        var filter = <String, dynamic>{};
                        for (var selected in _selectedPoolFilters) {
                          if (!filter.containsKey(selected.filterName)) {
                            filter[selected.filterName] = selected.value;
                          }
                        }
                        if(filter.isNotEmpty){
                          statecontext.read<PoolsCubit>().filterPools(filter);
                        }
                        Navigator.of(statecontext).pop();
                      },
                      title: MyLocalization.of(statecontext)!
                          .filterLabel
                          .toUpperCase(),
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
