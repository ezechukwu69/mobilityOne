import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/util/api_calls.dart';

class PoolsRepository {
  final ApiCalls api;

  PoolsRepository({required this.api});

  Future<List<Pool>> getPools({required String tenantId}) async {
    return await api.getPools(tenantId: tenantId);
  }

  Future<void> postPool(
      {required String tenantId,
      required Map<String, String> requestBody}) async {
    return await api.postPool(tenantId: tenantId, requestBody: requestBody);
  }

  Future<void> putPool({
    required String tenantId,
    required Map<String, String> requestBody,
    required String poolId,
  }) async {
    return await api.putPool(
      tenantId: tenantId,
      requestBody: requestBody,
      poolId: poolId,
    );
  }

  Future<void> deletePool({
    required String tenantId,
    required String poolId,
  }) async {
    return await api.deletePool(tenantId: tenantId, poolId: poolId);
  }
}
