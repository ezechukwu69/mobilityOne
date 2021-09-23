import 'package:mobility_one/models/vehicle_assignment.dart';
import 'package:mobility_one/util/api_calls.dart';

class VehiclesCalendarRepository {
  final ApiCalls api;

  VehiclesCalendarRepository({required this.api});

  Future<List<VehicleAssignment>> getVehiclesCalendar({required String tenantId}) async {
    return await api.getVehiclesCalendar(tenantId: tenantId);
  }

  Future<List<VehicleAssignment>> getVehiclesCalendarByGeneralSearch({required String tenantId, required String searchText}) async {
    return await api.getVehiclesCalendarByGeneralSearch(tenantId: tenantId, searchText: searchText);
  }

  Future<void> postVehicleCalendar(
      {required String tenantId,
        required Map<String, dynamic> requestBody}) async {
    return await api.postVehicleCalendar(tenantId: tenantId, requestBody: requestBody);
  }

  Future<VehicleAssignment> getVehicleCalendarById({required String tenantId, required int vehicleCalendarId}) async {
    return await api.getVehicleCalendarById(tenantId: tenantId, vehicleCalendarId: vehicleCalendarId);
  }

  Future<List<VehicleAssignment>> getVehicleCalendarByFilter({required String tenantId, required Map<String, dynamic> filter}) async {
    return await api.getVehiclesCalendarByFilter(tenantId: tenantId, filter: filter);
  }

  Future<void> putVehicleCalendar({
    required String tenantId,
    required Map<String, dynamic> requestBody,
    required int vehicleCalendarId,
  }) async {
     return await api.putVehicleCalendar(
       tenantId: tenantId,
       requestBody: requestBody,
       vehicleCalendarId: vehicleCalendarId,
     );
  }

  Future<void> deleteVehicleCalendar({
    required String tenantId,
    required int vehicleCalendarId,
  }) async {
    return await api.deleteVehicleCalendar(tenantId: tenantId, vehicleCalendarId: vehicleCalendarId);
  }
}
