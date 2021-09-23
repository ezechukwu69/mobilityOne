import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/util/api_calls.dart';

class VehiclesRepository {
  final ApiCalls api;

  VehiclesRepository({required this.api});

  Future<List<Vehicle>> getVehicles({
    required String tenantId,
  }) async {
    return await api.getVehicles(tenantId: tenantId);
  }

  Future<List<Vehicle>> getVehiclesByGeneralSearch(
      {required String tenantId, required String searchText}) async {
    return await api.getVehiclesByGeneralSearch(
        tenantId: tenantId, searchText: searchText);
  }

  Future<Vehicle> getVehicleById(
      {required String tenantId, required String vehicleId}) async {
    return await api.getVehicleById(tenantId: tenantId, vehicleId: vehicleId);
  }

  Future<List<Vehicle>> getVehiclesByFilter(
      {required String tenantId, required String requestFilters}) async {
    return await api.getVehiclesByFilter(
      tenantId: tenantId,
      requestFilters: requestFilters,
    );
  }

  Future<void> postVehicle(
      {required String tenantId,
      required Map<String, String> requestBody}) async {
    return await api.postVehicle(tenantId: tenantId, requestBody: requestBody);
  }

  Future<void> putVehicle({
    required String tenantId,
    required Map<String, String> requestBody,
    required String vehicleId,
  }) async {
    return await api.putVehicle(
      tenantId: tenantId,
      requestBody: requestBody,
      vehicleId: vehicleId,
    );
  }

  Future<void> deleteVehicle({
    required String tenantId,
    required String vehicleId,
  }) async {
    return await api.deleteVehicle(tenantId: tenantId, vehicleId: vehicleId);
  }
}
