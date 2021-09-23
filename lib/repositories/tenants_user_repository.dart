import 'package:mobility_one/models/tenant_user.dart';
import 'package:mobility_one/util/api_calls.dart';

class TenantsUserRepository {
  final ApiCalls api;

  TenantsUserRepository({required this.api});

  Future<List<TenantUser>> getTenantsUser({required String tenantId, String? userId}) async {
    return await api.getTenantsUser(tenantId: tenantId, userId: userId);
  }
}
