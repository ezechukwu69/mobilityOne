import 'package:mobility_one/models/case_type.dart';
import 'package:mobility_one/util/api_calls.dart';

class CasesTypeRepository {
  final ApiCalls api;

  CasesTypeRepository({required this.api});

  Future<List<CaseType>> getCaseTypes({required String tenantId}) async {
    return await api.getCasesType(tenantId: tenantId);
  }

  Future<void> postCaseType({required String tenantId, required Map<String, dynamic> requestBody}) async {
    return await api.postCaseType(tenantId: tenantId, requestBody: requestBody);
  }

  Future<void> putCaseType({required String tenantId, required int caseTypeId, required Map<String, dynamic> requestBody}) async {
    return await api.putCaseType(tenantId: tenantId, caseTypeId: caseTypeId, requestBody: requestBody);
  }

  Future<void> deleteCaseType({required String tenantId, required int caseTypeId}) async {
    return await api.deleteCaseType(tenantId: tenantId, caseTypeId: caseTypeId);
  }
}
