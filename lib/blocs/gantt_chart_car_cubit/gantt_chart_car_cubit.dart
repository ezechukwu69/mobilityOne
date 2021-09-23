import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/gantt_chart_car_cubit/gantt_chart_car_state.dart';
import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/models/mileage_report.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/models/vehicle_assignment.dart';
import 'package:mobility_one/repositories/cases_repository.dart';
import 'package:mobility_one/repositories/mileage_reports_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/repositories/assignments_repository.dart';
import 'package:mobility_one/repositories/vehicles_repository.dart';

class GanttChartCarCubit extends Cubit<GanttChartCarState> {
  GanttChartCarCubit({required this.tenantsRepository, required this.vehiclesRepository, required this.vehiclesCalendarRepository, required this.casesRepository, required this.mileagesReportsRepository}) : super(GanttChartCarInitial());

  final TenantsRepository tenantsRepository;
  final VehiclesRepository vehiclesRepository;
  final VehiclesCalendarRepository vehiclesCalendarRepository;
  final CasesRepository casesRepository;
  final MileageReportsRepository mileagesReportsRepository;

  Tenant? tenant;

  Future<void> getDataFromApi() async {
    emit(GanttChartCarLoading());
    try {
      tenant = await tenantsRepository.getTenants().then((value) => value.first);
      var requests = await Future.wait(
        [
          vehiclesRepository.getVehicles(tenantId: tenant!.id),
          vehiclesCalendarRepository.getVehiclesCalendar(tenantId: tenant!.id),
          casesRepository.getCases(tenantId: tenant!.id),
          mileagesReportsRepository.getMileageReports(tenantId: tenant!.id),
        ],
      );

      emit(
        GanttChartCarLoaded(vehicles: requests[0] as List<Vehicle>, vehicleCalendarEntries: requests[1] as List<VehicleAssignment>, cases: requests[2] as List<Case>, mileageReports: requests[3] as List<MileageReport>),
      );
    } catch (err, stackTrace) {
      emit(
        GanttChartCarError(error: err, stackTrace: stackTrace),
      );
    }
  }

  Future<void> createVehicleCalendarEntry({required VehicleAssignment vehicleCalendar}) async {
    try {
      emit(GanttChartCarLoading());
      tenant ??= await tenantsRepository.getTenants().then((value) => value.first);

      vehicleCalendar.tenantId = tenant!.id;
      await vehiclesCalendarRepository.postVehicleCalendar(tenantId: tenant!.id, requestBody: vehicleCalendar.toJson());
      await getDataFromApi();
    } catch (err, stackTrace) {
      print(err);
      emit(GanttChartCarError(error: err, stackTrace: stackTrace));
    }
  }

  Future<VehicleAssignment?> loadVehicleCalendarItem({required int vehicleCalendarId}) async {
    try {
      tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
      return await vehiclesCalendarRepository.getVehicleCalendarById(tenantId: tenant!.id, vehicleCalendarId: vehicleCalendarId);
    } catch (err, stackTrace) {
      print(err);
      emit(GanttChartCarError(error: err, stackTrace: stackTrace));
      return null;
    }
  }

  Future<void> updateVehicleCalendarEntry({required VehicleAssignment vehicleCalendar}) async {
    try {
      emit(GanttChartCarLoading());
      tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
      await vehiclesCalendarRepository.putVehicleCalendar(tenantId: tenant!.id, requestBody: vehicleCalendar.toJson(), vehicleCalendarId: vehicleCalendar.id!);
      await getDataFromApi();
    } catch (err, stackTrace) {
      print(err);
      emit(GanttChartCarError(error: err, stackTrace: stackTrace));
    }
  }

  Future<void> deleteVehicleCalendarEntry({required int vehicleCalendarId}) async {
    try {
      emit(GanttChartCarLoading());
      tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
      await vehiclesCalendarRepository.deleteVehicleCalendar(tenantId: tenant!.id, vehicleCalendarId: vehicleCalendarId);
      await getDataFromApi();
    } catch (err, stackTrace) {
      print(err);
      emit(GanttChartCarError(error: err, stackTrace: stackTrace));
    }
  }

  Future<void> searchItems(String searchText) async {
    try {
      emit(GanttChartCarLoading());
      tenant ??= await tenantsRepository.getTenants().then((value) => value.first);

      List<Vehicle> vehicles;
      List<VehicleAssignment> vehicleCalendarEntriesSearch;

      var requests = await Future.wait([vehiclesRepository.getVehiclesByGeneralSearch(tenantId: tenant!.id, searchText: searchText), vehiclesCalendarRepository.getVehiclesCalendarByGeneralSearch(tenantId: tenant!.id, searchText: searchText)]);

      vehicles = requests[0] as List<Vehicle>;
      vehicleCalendarEntriesSearch = requests[1] as List<VehicleAssignment>;

      // get the id of vehicles that assignments that was returned but the vehicles was not on the vehicles request
      final vehicleOnAssignmentsNotReturned = vehicleCalendarEntriesSearch.where((e) => (vehicles.indexWhere((element) => element.id == e.vehicleId) == -1)).map((e) => e.vehicleId);
      // this is getting vehicles id that not has respectively assignments returned
      final assignmentsOnVehiclesNotReturned = vehicles.where((e) => (vehicleCalendarEntriesSearch.indexWhere((element) => e.id == element.vehicleId) == -1)).map((e) => e.id);
      var lengthVehiclesOnAssignmentsNotReturned = vehicleOnAssignmentsNotReturned.length;
      var resultMissedRequests = await Future.wait([
        ...vehicleOnAssignmentsNotReturned.map(
          (e) => vehiclesRepository.getVehicleById(tenantId: tenant!.id, vehicleId: e),
        ),
        ...assignmentsOnVehiclesNotReturned.map(
          (e) => vehiclesCalendarRepository.getVehicleCalendarByFilter(tenantId: tenant!.id, filter: {'VehicleId': e}),
        )
      ]);

      vehicles.addAll(
        resultMissedRequests.sublist(0, vehicleOnAssignmentsNotReturned.length).map((e) => e as Vehicle),
      );

      for (var missed in resultMissedRequests.sublist(lengthVehiclesOnAssignmentsNotReturned)) {
        vehicleCalendarEntriesSearch.addAll(missed as List<VehicleAssignment>);
      }

      // TODO: make request to get cases from filtered assigments
      emit(GanttChartCarLoaded(vehicles: vehicles, vehicleCalendarEntries: vehicleCalendarEntriesSearch, cases: [], mileageReports: []));
      return;
    } catch (err, stackTrace) {
      print('err $err');
      emit(GanttChartCarError(error: err, stackTrace: stackTrace));
    }
  }

  Future<void> filterVehicles(String filter) async {
    try {
      var currentState = state;
      if (currentState is GanttChartCarLoaded) {
        emit(GanttChartCarLoading());
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        var filteredVehicles = await vehiclesRepository.getVehiclesByFilter(tenantId: tenant!.id, requestFilters: filter);
        emit(
          GanttChartCarLoaded(vehicles: filteredVehicles, vehicleCalendarEntries: [], cases: [], mileageReports: []),
        );
      }
    } catch (err, stackTrace) {
      print(err);
      emit(GanttChartCarError(error: err, stackTrace: stackTrace));
    }
  }

  Future<void> createCase({required String name, required String vehicleId, required String assigneeId, required String comment, required String description, required DateTime startDate, required DateTime endDate, required DateTime expectedEndDate, required int caseTypeId, required int mileage, required String mileageUnit, required int assigneeType}) async {
    try {
      final currentState = state;
      if (currentState is GanttChartCarLoaded) {
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        emit(GanttChartCarLoading());
        final newCase = Case(id: 0, tenantId: tenant!.id, name: name, vehicleId: vehicleId, caseTypeId: caseTypeId, startTime: startDate, expectedEndTime: expectedEndDate, endTime: endDate, comment: comment, detailedDescription: description, assigneeId: assigneeId, mileage: mileage, mileageUnit: mileageUnit, assigneeType: assigneeType);
        await casesRepository.postCase(tenantId: tenant!.id, requestBody: newCase.toJson());
        await getDataFromApi();
      }
    } catch (error, stackTrace) {
      print('Error $error');
      emit(GanttChartCarError(error: error, stackTrace: stackTrace));
    }
  }


  Future<void> updateCase(Case updatedCase) async {
    try {
      final currentState = state;
      if (currentState is GanttChartCarLoaded) {
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        emit(GanttChartCarLoading());
        await casesRepository.postCase(tenantId: tenant!.id, requestBody: updatedCase.toJson());
        await getDataFromApi();
      }
    } catch (error, stackTrace) {
      print('Error $error');
      emit(GanttChartCarError(error: error, stackTrace: stackTrace));
    }
  }

  Future<void> deleteCase(int caseId) async {
    try {
      final currentState = state;
      if (currentState is GanttChartCarLoaded) {
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        emit(GanttChartCarLoading());
        await casesRepository.deleteCase(tenantId: tenant!.id, caseId: caseId);
        await getDataFromApi();
      }
    } catch (error, stackTrace) {
      print('Error $error');
      emit(GanttChartCarError(error: error, stackTrace: stackTrace));
    }
  }

  Future<void> createMileageReport({required String vehicleId, required DateTime date, required String comment, required double mileage, required String measuringUnit}) async {
    try {
      final currentState = state;
      if (currentState is GanttChartCarLoaded) {
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        emit(GanttChartCarLoading());
        final newMileageReport = MileageReport(id: 0, tenantId: tenant!.id, vehicleId: vehicleId, time: date, measuringUnit: measuringUnit, value: mileage, comment: comment);
        await mileagesReportsRepository.postMileageReport(tenantId: tenant!.id, requestBody: newMileageReport.toJson());
        await getDataFromApi();
      }
    } catch (error, stackTrace) {
      print('Error $error');
      emit(
        GanttChartCarError(error: error, stackTrace: stackTrace),
      );
    }
  }

  Future<void> updateMileageReport(MileageReport updatedMileageReport) async {
    try {
      final currentState = state;
      if (currentState is GanttChartCarLoaded) {
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        emit(GanttChartCarLoading());
        await mileagesReportsRepository.putMileageReport(tenantId: tenant!.id, mileageReportId: updatedMileageReport.id, requestBody: updatedMileageReport.toJson(),);
        await getDataFromApi();
      }
    } catch (error, stackTrace) {
      print('Error $error');
      emit(GanttChartCarError(error: error, stackTrace: stackTrace));
    }
  }

  Future<void> deleteMileageReport(int mileageReportId) async {
    try {
      final currentState = state;
      if (currentState is GanttChartCarLoaded) {
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        emit(GanttChartCarLoading());
        await mileagesReportsRepository.deleteMileageReport(tenantId: tenant!.id, mileageReportId: mileageReportId);
        await getDataFromApi();
      }
    } catch (error, stackTrace) {
      print('Error $error');
      emit(GanttChartCarError(error: error, stackTrace: stackTrace));
    }
  }
}
