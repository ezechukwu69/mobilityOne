import 'package:mobility_one/models/vehicle_stat.dart';
import 'package:mobility_one/util/api_calls.dart';

class VehicleStatsRepository {
  final ApiCalls api;

  VehicleStatsRepository({required this.api});

  Future<List<VehicleStat>> getVehiclesStats({required String tenantId}) async {
    return await api.getVehicleStats(tenantId: tenantId);
  }
}
