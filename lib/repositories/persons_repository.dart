import 'package:mobility_one/models/person.dart';
import 'package:mobility_one/util/api_calls.dart';

class PersonsRepository {
  final ApiCalls api;

  PersonsRepository({required this.api});

  Future<List<Person>> getPersons({required String tenantId}) async {
    return await api.getPersons(tenantId: tenantId);
  }

  Future<List<Person>> getPersonsByOrgUnitId(
      {required String tenantId, required orgUnitId}) async {
    return await api.getPersonsByOrgUnitId(
        tenantId: tenantId, orgUnitId: orgUnitId);
  }

  Future<void> postPerson(
      {required String tenantId,
      required Map<String, String> requestBody}) async {
    return await api.postPerson(tenantId: tenantId, requestBody: requestBody);
  }

  Future<void> putPerson({
    required String tenantId,
    required Map<String, String> requestBody,
    required String personId,
  }) async {
    return await api.putPerson(
      tenantId: tenantId,
      requestBody: requestBody,
      personId: personId,
    );
  }

  Future<void> invitePerson({
    required String tenantId,
    required Map<String, Object> requestBody,
  }) async {
    return await api.invitePerson(
      tenantId: tenantId,
      requestBody: requestBody,
    );
  }

  Future<void> deletePerson({
    required String tenantId,
    required String personId,
  }) async {
    return await api.deletePerson(tenantId: tenantId, personId: personId);
  }

  Future<List<Person>> getPersonsByOrgUnitIdFilter({
    required String tenantId,
    required String requestFilters,
  }) async {
    return await api.getPersonsByOrgUnitIdFilter(
      tenantId: tenantId,
      requestFilters: requestFilters,
    );
  }
}
