import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/models/mileage_report.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/models/vehicle_assignment.dart';

abstract class GanttChartCarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GanttChartCarInitial extends GanttChartCarState {}

class GanttChartCarLoading extends GanttChartCarState {}

class GanttChartCarLoaded extends GanttChartCarState {
  final List<Vehicle> vehicles;
  final List<VehicleAssignment> vehicleCalendarEntries;
  final List<Case> cases;
  final List<MileageReport> mileageReports;

  GanttChartCarLoaded({
    required this.vehicles,
    required this.vehicleCalendarEntries,
    required this.cases,
    required this.mileageReports,
  });

  @override
  List<Object> get props => [vehicles, vehicleCalendarEntries];
}

class GanttChartCarError extends GanttChartCarState {
  final dynamic error;
  final StackTrace stackTrace;

  GanttChartCarError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
