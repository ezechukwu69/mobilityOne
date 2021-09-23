import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/util/api_calls.dart';

class CasesRepository {
  final ApiCalls api;

  CasesRepository({required this.api});

  Future<List<Case>> getCases({required String tenantId}) async {
    return await api.getCases(tenantId: tenantId);
  }

  Future<Case> getCase({required String tenantId, required int caseId}) async {
    return await api.getCaseById(tenantId: tenantId, caseId: caseId);
  }

  Future<void> postCase({required String tenantId, required Map<String, dynamic> requestBody}) async {
    return await api.postCase(tenantId: tenantId, requestBody: requestBody);
  }

  Future<void> putCase({required String tenantId, required String caseId, required Map<String, dynamic> requestBody}) async {
    return await api.putCase(tenantId: tenantId, caseId: caseId, requestBody: requestBody);
  }

  Future<void> deleteCase({required String tenantId, required int caseId}) async {
    return await api.deleteCase(tenantId: tenantId, caseId: caseId);
  }
}
