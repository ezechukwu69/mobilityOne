import 'package:mobility_one/models/vehicle_type.dart';
import 'package:mobility_one/util/api_calls.dart';

class VehicleTypesRepository {
  final ApiCalls api;

  VehicleTypesRepository({required this.api});

  Future<List<VehicleType>> getVehicleTypes({required String tenantId}) async {
    return await api.getVehicleTypes(tenantId: tenantId);
  }

  Future<void> postVehicleType(
      {required String tenantId,
      required Map<String, String> requestBody}) async {
    return await api.postVehicleType(tenantId: tenantId, requestBody: requestBody);
  }

  Future<void> putVehicleType({
    required String tenantId,
    required Map<String, String> requestBody,
    required int vehicleTypeId,
  }) async {
    return await api.putVehicleType(
      tenantId: tenantId,
      requestBody: requestBody,
      vehicleTypeId: vehicleTypeId,
    );
  }

  Future<void> deleteVehicleType({
    required String tenantId,
    required int vehicleTypeId,
  }) async {
    return await api.deleteVehicleType(tenantId: tenantId, vehicleTypeId: vehicleTypeId);
  }
}
