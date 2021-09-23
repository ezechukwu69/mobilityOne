import 'package:mobility_one/models/role.dart';
import 'package:mobility_one/util/api_calls.dart';

class RolesRepository {
  final ApiCalls api;

  RolesRepository({required this.api});

  Future<List<Role>> getRoles({required String tenantId}) async {
    return await api.getRoles(tenantId: tenantId);
  }
}
