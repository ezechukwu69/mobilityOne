import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/util/api_calls.dart';

class TenantsRepository {
  final ApiCalls api;

  TenantsRepository({required this.api});

   Future<List<Tenant>> getTenants() async {
    return await api.getTenants();
  }

  Future<void> putTenant({required String tenantId, required Map<String, String> requestBody}) async {
     return await api.putTenant(tenantId: tenantId, requestBody: requestBody);
  }
}
