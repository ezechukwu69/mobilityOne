import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/cases_cubit/cases_cubit.dart';
import 'package:mobility_one/blocs/cases_cubit/cases_state.dart';
import 'package:mobility_one/blocs/gantt_chart_car_cubit/gantt_chart_car_cubit.dart';
import 'package:mobility_one/blocs/gantt_chart_car_cubit/gantt_chart_car_state.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_cubit.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_state.dart';
import 'package:mobility_one/blocs/persons_cubit/persons_cubit.dart';
import 'package:mobility_one/blocs/pools_cubit/pools_cubit.dart';
import 'package:mobility_one/blocs/teams_cubit/teams_cubit.dart';
import 'package:mobility_one/blocs/teams_cubit/teams_state.dart';
import 'package:mobility_one/blocs/vehicle_stats_cubit/vehicle_stats_cubit.dart';
import 'package:mobility_one/blocs/vehicle_types_cubit/vehicle_types_cubit.dart';
import 'package:mobility_one/blocs/vehicles_cubit/vehicles_cubit.dart';
import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/models/dropdown_option.dart';
import 'package:mobility_one/models/mileage_report.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/models/vehicle_assignment.dart';
import 'package:mobility_one/repositories/availabilities_repository.dart';
import 'package:mobility_one/repositories/cases_repository.dart';
import 'package:mobility_one/repositories/general_statuses_repository.dart';
import 'package:mobility_one/repositories/mileage_reports_repository.dart';
import 'package:mobility_one/repositories/pools_repository.dart';
import 'package:mobility_one/repositories/teams_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/repositories/assignments_repository.dart';
import 'package:mobility_one/repositories/vehicle_stats_repository.dart';
import 'package:mobility_one/repositories/vehicle_types_repository.dart';
import 'package:mobility_one/repositories/vehicles_repository.dart';
import 'package:mobility_one/ui/dialogs/assignment_dialog.dart';
import 'package:mobility_one/ui/dialogs/case_dialog.dart';
import 'package:mobility_one/ui/dialogs/mileage_report_dialog.dart';
import 'package:mobility_one/ui/dialogs/vehicle_dialog.dart';
import 'package:mobility_one/ui/widgets/gantt_chart.dart';
import 'package:mobility_one/ui/widgets/m_one_error_widget.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_simple_circular_progress_indicator.dart';
import 'package:mobility_one/util/util.dart';

class VehiclesGanttScreen extends StatelessWidget {
  const VehiclesGanttScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GanttChartCarCubit(
            tenantsRepository: context.read<TenantsRepository>(),
            vehiclesRepository: context.read<VehiclesRepository>(),
            vehiclesCalendarRepository: context.read<VehiclesCalendarRepository>(),
            casesRepository: context.read<CasesRepository>(),
            mileagesReportsRepository: context.read<MileageReportsRepository>(),
          )..getDataFromApi(),
        ),
      ],
      child: _VehiclesGanttScreen(),
    );
  }
}

class _VehiclesGanttScreen extends StatefulWidget {
  const _VehiclesGanttScreen({Key? key}) : super(key: key);

  @override
  _VehiclesGanttScreenState createState() => _VehiclesGanttScreenState();
}

class _VehiclesGanttScreenState extends State<_VehiclesGanttScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 7));

  final List<GanttFilter> _selectedGanttFilters = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GanttChartCarCubit, GanttChartCarState>(
      builder: (context, state) {
        if (state is GanttChartCarLoaded) {
          return _showGanttChartScreen(state);
        } else if (state is GanttChartCarLoading) {
          return MyCircularProgressIndicator();
        }
        if (state is GanttChartCarError) {
          return MOneErrorWidget();
        }
        return Container();
      },
    );
  }

  Widget _showGanttChartScreen(GanttChartCarLoaded ganttState) {
    return BlocBuilder<GeneralSearchCubit, GeneralSearchState>(
      builder: (context, generalSearchState) {
        if (generalSearchState is GeneralSearchMakeSearch) {
          var ganttCarCubit = context.read<GanttChartCarCubit>();
          if (generalSearchState.searchText.isEmpty) {
            ganttCarCubit.getDataFromApi();
          } else {
            ganttCarCubit.searchItems(generalSearchState.searchText);
          }
          context.read<GeneralSearchCubit>().searchExecuted();
        }
        return MultiBlocProvider(
          providers: [
            BlocProvider<VehicleTypesCubit>(
              create: (context) => VehicleTypesCubit(vehicletypesRepository: context.read<VehicleTypesRepository>(), tenantsRepository: context.read<TenantsRepository>())..getDataFromApi(),
            ),
            BlocProvider<PoolsCubit>(
              create: (context) => PoolsCubit(poolsRepository: context.read<PoolsRepository>(), tenantsRepository: context.read<TenantsRepository>())..getDataFromApi(),
            ),
            BlocProvider<VehicleStatsCubit>(create: (context) => VehicleStatsCubit(vehicleStatsRepository: context.read<VehicleStatsRepository>(), tenantsRepository: context.read<TenantsRepository>())..getDataFromApi())
          ],
          child: BlocBuilder<VehicleTypesCubit, VehicleTypesState>(
            builder: (context, vehiclesTypeState) {
              if (vehiclesTypeState is VehicleTypesLoaded) {
                return BlocBuilder<PoolsCubit, PoolsState>(
                  builder: (context, poolsState) {
                    if (poolsState is PoolsLoaded) {
                      return BlocBuilder<VehicleStatsCubit, VehicleStatsState>(
                        builder: (context, vehicleStatsState) {
                          if (vehicleStatsState is VehicleStatsLoaded) {
                            return GanttChart<Vehicle>(
                                pageSkip: 1,
                                title: MyLocalization.of(context)!.vehiclesText,
                                assignments: ganttState.vehicleCalendarEntries
                                    .map(
                                      (calendarEntry) => Assignment(id: calendarEntry.id, operatorName: calendarEntry.assigneeName!, startDate: calendarEntry.fromTime, endDate: calendarEntry.toTime, itemId: calendarEntry.vehicleId),
                                    )
                                    .toList(),
                                cases: ganttState.cases,
                                mileages: ganttState.mileageReports,
                                startDate: startDate,
                                endDate: endDate,
                                items: ganttState.vehicles,
                                cardBuilder: (vehicle) {
                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        showVehicleDialog(vehicle);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Container(
                                                //   width: 50,
                                                //   height: 50,
                                                //   decoration: BoxDecoration(
                                                //       image: DecorationImage(image: NetworkImage(vehicle.displayName!), fit: BoxFit.cover),
                                                //       borderRadius: BorderRadius.all(
                                                //         Radius.circular(50),
                                                //       )),
                                                // ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  vehicle.displayName!,
                                                  style: TextStyle(color: MyColors.cardTextColor, fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                addCaseButton(vehicle),
                                                addAssignmentButton(vehicle),
                                                addMileageReportButton(vehicle),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onDaysSelected: (DateTime startDate, DateTime endDate, Vehicle vehicle) {
                                  showAssignmentDialog(vehicle, startDate, endDate);
                                },
                                onDateChanged: (startDate, endDate) {
                                  setState(() {
                                    this.startDate = startDate;
                                    this.endDate = endDate;
                                  });
                                },
                                onSelectAssignment: (Assignment assignment) async {
                                  var assignmentInfo = await context.read<GanttChartCarCubit>().loadVehicleCalendarItem(vehicleCalendarId: assignment.id);
                                  var vehicle = ganttState.vehicles.firstWhere((element) => element.id == assignmentInfo!.vehicleId);
                                  await Util.showMyDialog(
                                    context: context,
                                    child: MultiBlocProvider(
                                      providers: [
                                        BlocProvider<TeamsCubit>(
                                          create: (context) => TeamsCubit(tenantsRepository: context.read<TenantsRepository>(), teamsRepository: context.read<TeamsRepository>())..getDataFromApi(),
                                        ),
                                        BlocProvider<GanttChartCarCubit>.value(
                                          value: context.read<GanttChartCarCubit>(),
                                        ),
                                      ],
                                      child: BlocBuilder<TeamsCubit, TeamsState>(
                                        builder: (_context, state) {
                                          if (state is TeamsLoaded) {
                                            return AssignmentDialog(
                                              assignmentDialogOperation: AssignmentDialogOperation.UPDATE,
                                              item: vehicle,
                                              dropDownLabel: MyLocalization.of(context)!.teamText,
                                              startDate: assignmentInfo!.fromTime,
                                              endDate: assignmentInfo.toTime,
                                              dropDownOptions: state.teams
                                                  .map(
                                                    (team) => DropDownOption(label: team.name, value: team.id),
                                                  )
                                                  .toList(),
                                              preSelectedDropDownOption: state.teams.firstWhere((element) => element.id == assignmentInfo.assignedToId).id,
                                              choosedItem: Container(
                                                padding: EdgeInsets.all(8),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Container(
                                                        //   width: 50,
                                                        //   height: 50,
                                                        //   decoration: BoxDecoration(
                                                        //       image: DecorationImage(image: NetworkImage(vehicle.), fit: BoxFit.cover),
                                                        //       borderRadius: BorderRadius.all(
                                                        //         Radius.circular(50),
                                                        //       )),
                                                        // ),
                                                        // SizedBox(
                                                        //   width: 8,
                                                        // ),
                                                        Text(
                                                          vehicle.displayName!,
                                                          style: TextStyle(color: MyColors.cardTextColor, fontSize: 14),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onComplete: (selectedOption, startDate, endDate, vehicle) {
                                                context.read<GanttChartCarCubit>().updateVehicleCalendarEntry(
                                                      vehicleCalendar: assignmentInfo.copyWith(fromTime: startDate, toTime: endDate, vehicleId: (vehicle as Vehicle).id, assignedToId: selectedOption.value),
                                                    );
                                              },
                                              onDeleteAssignment: () {
                                                context.read<GanttChartCarCubit>().deleteVehicleCalendarEntry(vehicleCalendarId: assignmentInfo.id!);
                                                Navigator.pop(context);
                                              },
                                            );
                                          }
                                          ;
                                          if (state is TeamsLoading) {
                                            return MyCircularProgressIndicator();
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                  );
                                },
                                onSelectCase: (Case _case) {
                                  Util.showMyDialog(
                                    context: context,
                                    child: MultiBlocProvider(
                                      providers: [
                                        BlocProvider<CasesCubit>(
                                          create: (context) => CasesCubit(
                                            tenantsRepository: context.read<TenantsRepository>(),
                                            casesRepository: context.read<CasesRepository>(),
                                          ),
                                        ),
                                        BlocProvider.value(value: context.read<GanttChartCarCubit>())
                                      ],
                                      child: BlocBuilder<CasesCubit, CasesState>(
                                        builder: (context, caseState) {
                                          if (caseState is CasesInitial) {
                                            context.read<CasesCubit>().getCaseById(_case.id);
                                          }

                                          if (caseState is CaseByIdLoaded) {
                                            return CaseDialog(
                                              caseDialogOperation: CaseDialogOperation.UPDATE,
                                              selectedCase: caseState.loadedCase,
                                              vehicle: ganttState.vehicles.firstWhere((element) => element.id == caseState.loadedCase.vehicleId),
                                              onConfirm: ({required String name, required String vehicleId, required String assigneeId, required String description, required String comment, required DateTime startDate, required DateTime endDate, required DateTime expectedEndDate, required int caseTypeId, required int mileage, required String mileageUnit}) async {
                                                final updatedCase = caseState.loadedCase.copyWith(name: name, vehicleId: vehicleId, assigneeId: assigneeId, description: description, comment: comment, startDate: startDate, endDate: endDate, expectedEndDate: expectedEndDate, caseTypeId: caseTypeId, mileage: mileage, mileageUnit: mileageUnit);
                                                await context.read<GanttChartCarCubit>().updateCase(updatedCase);
                                              },
                                              onDeleteCase: () {
                                                context.read<GanttChartCarCubit>().deleteCase(_case.id);
                                                Navigator.pop(context);
                                              },
                                            );
                                          } else {
                                            return MySimpleCircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                                onSelectMileageReport: (MileageReport mileageReport) {
                                  Util.showMyDialog(
                                    context: context,
                                    child: MileageReportDialog(
                                      mileageReportOperation: MileageReportOperation.UPDATE,
                                      selectedMileageReport: mileageReport,
                                      vehicle: ganttState.vehicles.firstWhere((element) => element.id == mileageReport.vehicleId),
                                      onConfirm: ({required String vehicleId, required String comment, required double mileage, required String measuringUnit, required DateTime date}) async {
                                        final updatedMileageReport = mileageReport.copyWith(vehicleId: vehicleId, comment: comment, mileage: mileage, measuringUnit: measuringUnit, date: date);
                                        await context.read<GanttChartCarCubit>().updateMileageReport(updatedMileageReport);
                                      },
                                      onDeleteMileageReport: () {
                                        context.read<GanttChartCarCubit>().deleteMileageReport(mileageReport.id);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                                filterGroups: [
                                  GanttFilterGroup(
                                    groupName: 'Vehicle Type',
                                    filters: vehiclesTypeState.vehicletypes.map((e) => GanttFilter(label: e.name, value: e.id, filterName: 'VehicleTypeId', isSelected: _selectedGanttFilters.indexWhere((element) => element.value == e.id) != -1)).toList(),
                                  ),
                                  GanttFilterGroup(
                                    groupName: 'Pool',
                                    filters: poolsState.pools.map((e) => GanttFilter(label: e.name, value: e.id, filterName: 'PoolId', isSelected: _selectedGanttFilters.indexWhere((element) => element.value == e.id) != -1)).toList(),
                                  ),
                                  GanttFilterGroup(
                                    groupName: 'Vehicle Stats',
                                    filters: vehicleStatsState.vehicleStats.map((e) => GanttFilter(label: e.availability, value: e.availability, filterName: 'GeneralStatusId', isSelected: _selectedGanttFilters.indexWhere((element) => element.value == e.availability) != -1)).toList(),
                                  )
                                ],
                                onFilterSelect: (filter) {
                                  if (!_selectedGanttFilters.contains(filter)) {
                                    _selectedGanttFilters.add(filter);
                                  } else {
                                    _selectedGanttFilters.remove(filter);
                                  }
                                  print(_selectedGanttFilters);
                                },
                                onFilterConfirmed: () {
                                  var filter = '';
                                  // TODO implement filter
                                  context.read<GanttChartCarCubit>().filterVehicles(filter);
                                });
                          }
                          return MyCircularProgressIndicator();
                        },
                      );
                    }
                    return MyCircularProgressIndicator();
                  },
                );
              }
              return MyCircularProgressIndicator();
            },
          ),
        );
      },
    );
  }

  Widget addAssignmentButton(Vehicle vehicle) {
    return Tooltip(
      message: MyLocalization.of(context)!.createNewAssignmentText,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            showAssignmentDialog(vehicle, startDate, endDate.add(Duration(days: -1)));
          },
          child: Icon(
            Icons.add,
            color: MyColors.accentColor,
          ),
        ),
      ),
    );
  }

  Widget addCaseButton(Vehicle vehicle) {
    return Tooltip(
      message: MyLocalization.of(context)!.createCaseText,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            showCaseDialog(vehicle);
          },
          child: Icon(
            Icons.event_sharp,
            color: MyColors.accentColor,
          ),
        ),
      ),
    );
  }

  Widget addMileageReportButton(Vehicle vehicle) {
    return Tooltip(
      message: MyLocalization.of(context)!.createMileageReportText,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            showMileageReportDialog(vehicle);
          },
          child: Icon(Icons.add_road, color: MyColors.accentColor),
        ),
      ),
    );
  }

  void showAssignmentDialog(Vehicle vehicle, DateTime startDate, DateTime endDate) {
    Util.showMyDialog(
        context: context,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TeamsCubit>(
              create: (context) => TeamsCubit(tenantsRepository: context.read<TenantsRepository>(), teamsRepository: context.read<TeamsRepository>())..getDataFromApi(),
            ),
            BlocProvider<GanttChartCarCubit>.value(
              value: context.read<GanttChartCarCubit>(),
            ),
          ],
          child: BlocBuilder<TeamsCubit, TeamsState>(
            builder: (_context, state) {
              if (state is TeamsLoaded) {
                return AssignmentDialog(
                  assignmentDialogOperation: AssignmentDialogOperation.NEW,
                  item: vehicle,
                  startDate: startDate,
                  endDate: endDate,
                  choosedItem: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   width: 50,
                            //   height: 50,
                            //   decoration: BoxDecoration(
                            //       image: DecorationImage(image: NetworkImage(vehicle.), fit: BoxFit.cover),
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(50),
                            //       )),
                            // ),
                            // SizedBox(
                            //   width: 8,
                            // ),
                            Text(
                              vehicle.displayName!,
                              style: TextStyle(color: MyColors.cardTextColor, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  dropDownLabel: MyLocalization.of(context)!.teamText,
                  dropDownOptions: state.teams
                      .map(
                        (team) => DropDownOption(label: team.name, value: team.id),
                      )
                      .toList(),
                  onComplete: (selectedOption, startDate, endDate, item) {
                    setState(() {
                      context.read<GanttChartCarCubit>().createVehicleCalendarEntry(
                            // todo: putting assigneeType as 2 for Team type but when include persons need to change to be 0 or 1
                            vehicleCalendar: VehicleAssignment(
                              id: 0,
                              vehicleId: vehicle.id,
                              fromTime: startDate,
                              toTime: endDate,
                              description: '',
                              assignedToId: selectedOption.value,
                              assigneeType: 2,
                              vehicleName: vehicle.displayName!,
                              assigneeName: selectedOption.label,
                            ),
                          );
                    });
                  },
                );
              }
              ;
              if (state is PersonsLoading) {
                return MyCircularProgressIndicator();
              }
              return Container();
            },
          ),
        ));
  }

  void showCaseDialog(Vehicle vehicle) {
    Util.showMyDialog(
      context: context,
      child: CaseDialog(
        caseDialogOperation: CaseDialogOperation.NEW,
        vehicle: vehicle,
        onConfirm: ({required String name, required String vehicleId, required String assigneeId, required String description, required String comment, required DateTime startDate, required DateTime endDate, required DateTime expectedEndDate, required int caseTypeId, required int mileage, required String mileageUnit}) async {
          await context.read<GanttChartCarCubit>().createCase(name: name, vehicleId: vehicleId, description: description, endDate: endDate, assigneeId: assigneeId, caseTypeId: caseTypeId, comment: comment, expectedEndDate: expectedEndDate, startDate: startDate, mileage: mileage, mileageUnit: mileageUnit, assigneeType: 1);
        },
      ),
    );
  }

  void showMileageReportDialog(Vehicle vehicle) {
    Util.showMyDialog(
      context: context,
      child: MileageReportDialog(
        vehicle: vehicle,
        mileageReportOperation: MileageReportOperation.NEW,
        onConfirm: ({required String vehicleId, required String comment, required double mileage, required String measuringUnit, required DateTime date}) async {
          await context.read<GanttChartCarCubit>().createMileageReport(vehicleId: vehicleId, date: date, comment: comment, mileage: mileage, measuringUnit: measuringUnit);
        },
      ),
    );
  }

  void showVehicleDialog(Vehicle vehicle) {
    Util.showMyDialog(
      context: context,
      child: BlocProvider(
        create: (context) => VehiclesCubit(vehiclesRepository: context.read<VehiclesRepository>(), tenantsRepository: context.read<TenantsRepository>(), poolsRepository: context.read<PoolsRepository>(), generalStatusesRepository: context.read<GeneralStatusesRepository>(), vehicleTypeRepository: context.read<VehicleTypesRepository>(), availabilitiesRepository: context.read<AvailabilitiesRepository>())..getDataFromApi(),
        child: VehicleDialog(
          action: VehicleAction.update,
          vehicleToBeUpdated: vehicle,
        ),
      ),
    );
  }
}
