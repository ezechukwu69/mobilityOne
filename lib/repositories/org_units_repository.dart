import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/util/api_calls.dart';

class OrgUnitsRepository {
  final ApiCalls api;

  OrgUnitsRepository({required this.api});

  Future<List<OrgUnit>> getOrgUnits({required String tenantId}) async {
    var result = await api.getOrgUnits(tenantId: tenantId);
    return result;
  }

  Future<List<OrgUnit>> getOrgUnitsTree({required String tenantId}) async {
    return await api.getOrgUnitsTree(tenantId: tenantId);
  }

  Future<void> deleteOrgUnit({required String tenantId, required String orgUnitId}) {
    return api.deleteOrgUnit(tenantId: tenantId, orgUnitId: orgUnitId);
  }

  Future<void> putOrgUnit({required String tenantId, required String orgUnitId, required Map<String, String?> requestBody}) {
    return api.putOrgUnit(tenantId: tenantId, orgUnitId: orgUnitId, requestBody: requestBody);
  }

  Future<void> postOrgUnit({required String tenantId, required Map<String, String?> requestBody}) {
    return api.postOrgUnit(tenantId: tenantId, requestBody: requestBody);
  }
}
