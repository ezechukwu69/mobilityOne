import 'package:mobility_one/models/Team.dart';
import 'package:mobility_one/models/availability.dart';
import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/models/case_type.dart';
import 'package:mobility_one/models/general_status.dart';
import 'package:mobility_one/models/mileage_report.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/models/person.dart';
import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/models/role.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/models/tenant_user.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/models/vehicle_assignment.dart';
import 'package:mobility_one/models/vehicle_stat.dart';
import 'package:mobility_one/models/vehicle_type.dart';
import 'package:mobility_one/util/api_client.dart';
import 'package:mobility_one/util/auth_util.dart';
import 'package:mobility_one/util/local_storage.dart';
import 'package:mobility_one/util/mobility_one_app.dart';
import 'package:mobility_one/util/request_config.dart';
import 'package:universal_io/io.dart';

class ApiCalls {
  final ApiClient apiClient = ApiClient();
  final LocalStorage localStorage;

  ApiCalls({required this.localStorage});
  String get server => MobilityOneApp.server;
  String get server2 => MobilityOneApp.server2;
  Uri get oauthIdentity => AuthUtil.sso;

  Future<void>? _processNullResponse(HttpClientResponse? response) {
    if (response!.statusCode >= 200 && response.statusCode < 300) {
      return null;
    }
    return Future<void>.error(response);
  }

  Future<void> userInfoEndpoint() async {
    return await apiClient.request<dynamic>(
      Config(
        uri: Uri.parse('$oauthIdentity/connect/userinfo'),
        method: RequestMethod.get,
        responseType: ResponseBody.json(),
      ),
    );
  }

  Future<List<Person>> getPersons({required String tenantId}) async {
    print(server);
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server/Persons'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((person) => Person.fromJson(json: person))
                .toList());
  }

  Future<List<Person>> getPersonsByOrgUnitId(
      {required tenantId, required orgUnitId}) async {
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse(
                '$server/Persons?Filter=OrgUnitID%28%3D%29$orgUnitId'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((person) => Person.fromJson(json: person))
                .toList());
  }

  Future<List<Tenant>> getTenants() async {
    print('${localStorage.getCredentials()}');
    try {
      var tenants = await apiClient
          .request<dynamic>(
              Config(
                uri: Uri.parse('$server/Tenants'),
                method: RequestMethod.get,
                responseType: ResponseBody.json(),
              ),
              includeAuthorizationHeader: true)
          .then((dynamic jsonResponse) => jsonResponse['Data'] == null
              ? []
              : (jsonResponse['Data'] as List)
                  .map((tenant) => Tenant.fromJson(json: tenant))
                  .toList());
      return tenants as List<Tenant>;
    } catch (err) {
      print('err $err');
      return [];
    }
  }

  Future<List<CaseType>> getCasesType({required String tenantId}) async {
    return await apiClient
        .request<dynamic>(
      Config(
        uri: Uri.parse('$server2/CaseTypes'),
        method: RequestMethod.get,
        responseType: ResponseBody.json(),
        headers: {'x-tenant': tenantId},
      ),
    )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
    ? []
            : (jsonResponse['Data'] as List)
        .map((caseType) => CaseType.fromJson(json: caseType))
        .toList());
  }

  Future<void> postCaseType(
      {required String tenantId, required Map<String, dynamic> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
      Config(
          uri: Uri.parse('$server2/CaseTypes'),
          method: RequestMethod.post,
          body: RequestBody.json(requestBody),
          headers: {'x-tenant': tenantId}),
    )
        .then(_processNullResponse);
  }

  Future<void> putCaseType(
      {required String tenantId,
        required int caseTypeId,
        required Map<String, dynamic> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
      Config(
          uri: Uri.parse('$server2/CaseTypes/$caseTypeId'),
          method: RequestMethod.put,
          body: RequestBody.json(requestBody),
          headers: {'x-tenant': tenantId}),
    )
        .then(_processNullResponse);
  }

  Future<void> deleteCaseType({required String tenantId, required int caseTypeId}) {
    return apiClient
        .request<HttpClientResponse>(
      Config(
          uri: Uri.parse('$server2/CaseTypes/$caseTypeId'),
          method: RequestMethod.delete,
          headers: {'x-tenant': tenantId}),
    )
        .then(_processNullResponse);
  }

  Future<List<Case>> getCases({required String tenantId}) async {
    return await apiClient
        .request<dynamic>(
      Config(
        uri: Uri.parse('$server2/Cases'),
        method: RequestMethod.get,
        responseType: ResponseBody.json(),
        headers: {'x-tenant': tenantId},
      ),
    )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
    ? []
            : (jsonResponse['Data'] as List)
        .map((_case) => Case.fromJson(json: _case))
        .toList());
  }

  Future<Case> getCaseById(
      {required tenantId, required int caseId}) async {
    return await apiClient
        .request<dynamic>(
      Config(
        uri: Uri.parse('$server2/Cases/$caseId'),
        method: RequestMethod.get,
        responseType: ResponseBody.json(),
        headers: {'x-tenant': tenantId},
      ),
    )
        .then((dynamic jsonResponse) => Case.fromJson(json: jsonResponse));
  }

  Future<void> postCase(
      {required String tenantId, required Map<String, dynamic> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
      Config(
          uri: Uri.parse('$server2/Cases'),
          method: RequestMethod.post,
          body: RequestBody.json(requestBody),
          headers: {'x-tenant': tenantId}),
    )
        .then(_processNullResponse);
  }

  Future<void> putCase(
      {required String tenantId,
        required String caseId,
        required Map<String, dynamic> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
      Config(
          uri: Uri.parse('$server2/Cases/$caseId'),
          method: RequestMethod.put,
          body: RequestBody.json(requestBody),
          headers: {'x-tenant': tenantId}),
    )
        .then(_processNullResponse);
  }

  Future<void> deleteCase({required String tenantId, required int caseId}) {
    return apiClient
        .request<HttpClientResponse>(
      Config(
          uri: Uri.parse('$server2/Cases/$caseId'),
          method: RequestMethod.delete,
          headers: {'x-tenant': tenantId}),
    )
        .then(_processNullResponse);
  }

  Future<List<MileageReport>> getMileageReports({required String tenantId}) async {
    return await apiClient
        .request<dynamic>(
      Config(
        uri: Uri.parse('$server2/MileageReports'),
        method: RequestMethod.get,
        responseType: ResponseBody.json(),
        headers: {'x-tenant': tenantId},
      ),
    )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
    ? []
            : (jsonResponse['Data'] as List)
        .map((mileageReports) => MileageReport.fromJson(json: mileageReports))
        .toList());
  }

  Future<void> postMileageReport(
      {required String tenantId, required Map<String, dynamic> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
      Config(
          uri: Uri.parse('$server2/MileageReports'),
          method: RequestMethod.post,
          body: RequestBody.json(requestBody),
          headers: {'x-tenant': tenantId}),
    )
        .then(_processNullResponse);
  }

  Future<void> putMileageReport(
      {required String tenantId,
        required int mileageReportId,
        required Map<String, dynamic> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
      Config(
          uri: Uri.parse('$server2/MileageReports/$mileageReportId'),
          method: RequestMethod.put,
          body: RequestBody.json(requestBody),
          headers: {'x-tenant': tenantId}),
    )
        .then(_processNullResponse);
  }

  Future<void> deleteMileageReport({required String tenantId, required int mileageReportId}) {
    return apiClient
        .request<HttpClientResponse>(
      Config(
          uri: Uri.parse('$server2/MileageReports/$mileageReportId'),
          method: RequestMethod.delete,
          headers: {'x-tenant': tenantId}),
    )
        .then(_processNullResponse);
  }

  Future<List<Team>> getTeams({required String tenantId}) async {
    return await apiClient
        .request<dynamic>(
      Config(
        uri: Uri.parse('$server/Teams'),
        method: RequestMethod.get,
        responseType: ResponseBody.json(),
        headers: {'x-tenant': tenantId},
      ),
    )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
    ? []
            : (jsonResponse['Data'] as List)
        .map((team) => Team.fromJson(json: team))
        .toList());
  }

  Future<Tenant> getTenantById({required String tenantId}) {
    return apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server/Tenants/$tenantId'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then(
          (dynamic jsonResponse) => Tenant.fromJson(json: jsonResponse),
        );
  }

  Future<void> postTenant(
      {required String tenantId, required Map<String, String> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server/Tenants'),
              method: RequestMethod.post,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> putTenant(
      {required String tenantId, required Map<String, String> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server/Tenants/$tenantId'),
              method: RequestMethod.put,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> deleteTenant({required String tenantId}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server/Tenants/$tenantId'),
              method: RequestMethod.delete,
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<String> getCurrentAccount() async {
    var result = await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server/Echo/whoami'),
            responseType: ResponseBody.json(),
            method: RequestMethod.get,
          ),
        )
        .then((dynamic jsonResponse) {
      return jsonResponse['FullName'] as String;
    }
    );
    return result;
  }

  Future<void> postAccount(
      {required Map<String, String> requestBody}) async {
    return await apiClient
        .request<HttpClientResponse>(
      Config(
        uri: Uri.parse('${AuthUtil.sso}/register'),
        method: RequestMethod.post,
        body: RequestBody.json(requestBody),
        headers: {},
      ),
    )
        .then(_processNullResponse);
  }

  Future<void> postPerson(
      {required String tenantId,
      required Map<String, String> requestBody}) async {
    return await apiClient
        .request<HttpClientResponse>(
          Config(
            uri: Uri.parse('$server/Persons'),
            method: RequestMethod.post,
            body: RequestBody.json(requestBody),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then(_processNullResponse);
  }

  Future<List<OrgUnit>> getOrgUnits({required String tenantId}) async {
    OrgUnit.numberOfNodes = 0;
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server/OrgUnits'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then(
          (dynamic jsonResponse) => jsonResponse['Data'] == null
              ? []
              : (jsonResponse['Data'] as List)
                  .map((orgUnit) => OrgUnit.fromJson(json: orgUnit))
                  .toList(),
        );
  }

  Future<List<OrgUnit>> getOrgUnitsTree({required String tenantId}) async {
    OrgUnit.numberOfNodes = 0;
    return await apiClient
        .request<dynamic>(
      Config(
        uri: Uri.parse('$server/OrgUnits/tree'),
        method: RequestMethod.get,
        responseType: ResponseBody.json(),
        headers: {'x-tenant': tenantId},
      ),
    )
        .then((dynamic jsonResponse) {
      return jsonResponse['TopLevelOrgUnits'] == null
          ? []
          : (jsonResponse['TopLevelOrgUnits'] as List).map((jsonOrgUnit) {
              var orgUnit = OrgUnit.fromJson(
                  json: jsonOrgUnit['Item'],
                  jsonChildren: jsonOrgUnit['Children']);
              return orgUnit;
            }).toList();
    });
  }

  Future<OrgUnit> getOrgUnitById(
      {required String tenantId, required String orgUnitId}) {
    return apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server/OrgUnits/$orgUnitId'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then(
          (dynamic jsonResponse) => OrgUnit.fromJson(json: jsonResponse),
        );
  }

  Future<void> postOrgUnit(
      {required String tenantId, required Map<String, String?> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server/OrgUnits'),
              method: RequestMethod.post,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> putOrgUnit(
      {required String tenantId,
      required String orgUnitId,
      required Map<String, String?> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server/OrgUnits/$orgUnitId'),
              method: RequestMethod.put,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> deleteOrgUnit(
      {required String tenantId, required String orgUnitId}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server/OrgUnits/$orgUnitId'),
              method: RequestMethod.delete,
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> putPerson({
    required String tenantId,
    required Map<String, String> requestBody,
    required String personId,
  }) async {
    return await apiClient
        .request<HttpClientResponse>(
          Config(
            uri: Uri.parse('$server/Persons/$personId'),
            method: RequestMethod.put,
            body: RequestBody.json(requestBody),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then(_processNullResponse);
  }

  Future<void> invitePerson({
    required String tenantId,
    required Map<String, Object> requestBody,
  }) async {
    return await apiClient
        .request<HttpClientResponse>(
          Config(
            uri: Uri.parse('$server/Persons/Invite'),
            method: RequestMethod.post,
            body: RequestBody.json(requestBody),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then(_processNullResponse);
  }

  Future<void> deletePerson({
    required String tenantId,
    required String personId,
  }) async {
    return await apiClient
        .request<HttpClientResponse>(
          Config(
            uri: Uri.parse('$server/Persons/$personId'),
            method: RequestMethod.delete,
            headers: {'x-tenant': tenantId},
          ),
        )
        .then(_processNullResponse);
  }

  Future<List<Role>> getRoles({required String tenantId}) async {
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server/Roles'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((role) => Role.fromJson(json: role))
                .toList());
  }

  Future<List<TenantUser>> getTenantsUser(
      {required String tenantId, String? userId}) async {
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server/TenantsUser?Filter=UserId=$userId'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((person) => TenantUser.fromJson(json: person))
                .toList());
  }

  Future<void> postTenantsUser(
      {required String tenantId, required Map<String, String> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server/TenantsUser'),
              method: RequestMethod.post,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<List<Pool>> getPools({required String tenantId}) async {
    print(server);
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server2/Pools'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((pool) => Pool.fromJson(json: pool))
                .toList());
  }

  Future<void> postPool(
      {required String tenantId, required Map<String, String> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/Pools'),
              method: RequestMethod.post,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> putPool(
      {required String tenantId,
      required String poolId,
      required Map<String, String> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/Pools/$poolId'),
              method: RequestMethod.put,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> deletePool({required String tenantId, required String poolId}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/Pools/$poolId'),
              method: RequestMethod.delete,
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<List<VehicleType>> getVehicleTypes({required String tenantId}) async {
    print(server);
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server2/VehicleTypes'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((vehicleType) => VehicleType.fromJson(json: vehicleType))
                .toList());
  }

  Future<void> postVehicleType(
      {required String tenantId, required Map<String, String> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/VehicleTypes'),
              method: RequestMethod.post,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> putVehicleType(
      {required String tenantId,
      required int vehicleTypeId,
      required Map<String, String> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/VehicleTypes/$vehicleTypeId'),
              method: RequestMethod.put,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> deleteVehicleType(
      {required String tenantId, required int vehicleTypeId}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/VehicleTypes/$vehicleTypeId'),
              method: RequestMethod.delete,
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<List<GeneralStatus>> getGeneralStatuses(
      {required String tenantId}) async {
    print(server);
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server2/Lookup/GeneralStatuses'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse == null
            ? []
            : (jsonResponse as List)
                .map((generalStatus) =>
                    GeneralStatus.fromJson(json: generalStatus))
                .toList());
  }

  Future<List<Availability>> getAvailabilities(
      {required String tenantId}) async {
    print(server);
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server2/Lookup/Availabilies'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse == null
            ? []
            : (jsonResponse as List)
                .map(
                    (availability) => Availability.fromJson(json: availability))
                .toList());
  }

  Future<List<Vehicle>> getVehicles({required String tenantId}) async {
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server2/Vehicles'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((vehicle) => Vehicle.fromJson(json: vehicle))
                .toList());
  }

  Future<Vehicle> getVehicleById(
      {required tenantId, required String vehicleId}) async {
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server2/Vehicles/$vehicleId'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => Vehicle.fromJson(json: jsonResponse));
  }

  Future<List<Vehicle>> getVehiclesByGeneralSearch(
      {required String tenantId, required String searchText}) async {
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse(
                '$server2/Vehicles?Filter=General(contains)$searchText'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((vehicle) => Vehicle.fromJson(json: vehicle))
                .toList());
  }

  Future<List<Vehicle>> getVehiclesByFilter(
      {required String tenantId, required String requestFilters}) async {

    return await apiClient
        .request<dynamic>(Config(
          uri: Uri.parse('$server2/Vehicles$requestFilters'),
          method: RequestMethod.get,
          responseType: ResponseBody.json(),
          headers: {'x-tenant': tenantId},
        ))
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((vehicleCalendar) =>
                    Vehicle.fromJson(json: vehicleCalendar))
                .toList());
  }

  Future<void> postVehicle(
      {required String tenantId, required Map<String, String> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/Vehicles'),
              method: RequestMethod.post,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> putVehicle(
      {required String tenantId,
      required String vehicleId,
      required Map<String, String> requestBody}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/Vehicles/$vehicleId'),
              method: RequestMethod.put,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> deleteVehicle(
      {required String tenantId, required String vehicleId}) {
    return apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/Vehicles/$vehicleId'),
              method: RequestMethod.delete,
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<List<VehicleAssignment>> getVehiclesCalendar(
      {required String tenantId}) async {
    return await apiClient
        .request<dynamic>(Config(
          uri: Uri.parse('$server2/VehicleCalendar'),
          method: RequestMethod.get,
          responseType: ResponseBody.json(),
          headers: {'x-tenant': tenantId},
        ))
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((vehicleCalendar) =>
        VehicleAssignment.fromJson(json: vehicleCalendar))
                .toList());
  }

  Future<List<VehicleAssignment>> getVehiclesCalendarByGeneralSearch(
      {required String tenantId, required String searchText}) async {
    return await apiClient
        .request<dynamic>(Config(
          uri: Uri.parse(
              '$server2/VehicleCalendar?Filter=General(contains)$searchText'),
          method: RequestMethod.get,
          responseType: ResponseBody.json(),
          headers: {'x-tenant': tenantId},
        ))
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((vehicleCalendar) =>
        VehicleAssignment.fromJson(json: vehicleCalendar))
                .toList());
  }

  Future<VehicleAssignment> getVehicleCalendarById(
      {required String tenantId, required int vehicleCalendarId}) async {
    return await apiClient
        .request<dynamic>(Config(
          uri: Uri.parse('$server2/VehicleCalendar/$vehicleCalendarId'),
          method: RequestMethod.get,
          responseType: ResponseBody.json(),
          headers: {'x-tenant': tenantId},
        ))
        .then((dynamic jsonResponse) =>
        VehicleAssignment.fromJson(json: jsonResponse));
  }

  Future<List<VehicleAssignment>> getVehiclesCalendarByFilter(
      {required String tenantId, required Map<String, dynamic> filter}) async {
    var requestFilter = '?';

    filter.keys.forEach((key) {
      requestFilter += 'Filter=$key(=)${filter[key]}';
    });

    return await apiClient
        .request<dynamic>(Config(
          uri: Uri.parse('$server2/VehicleCalendar$requestFilter'),
          method: RequestMethod.get,
          responseType: ResponseBody.json(),
          headers: {'x-tenant': tenantId},
        ))
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((vehicleCalendar) =>
        VehicleAssignment.fromJson(json: vehicleCalendar))
                .toList());
  }

  Future<void> postVehicleCalendar(
      {required String tenantId,
      required Map<String, dynamic> requestBody}) async {
    return await apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/VehicleCalendar'),
              method: RequestMethod.post,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> putVehicleCalendar(
      {required String tenantId,
      required int vehicleCalendarId,
      required Map<String, dynamic> requestBody}) async {
    return await apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/VehicleCalendar/$vehicleCalendarId'),
              method: RequestMethod.put,
              body: RequestBody.json(requestBody),
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<void> deleteVehicleCalendar(
      {required String tenantId, required int vehicleCalendarId}) async {
    return await apiClient
        .request<HttpClientResponse>(
          Config(
              uri: Uri.parse('$server2/VehicleCalendar/$vehicleCalendarId'),
              method: RequestMethod.delete,
              headers: {'x-tenant': tenantId}),
        )
        .then(_processNullResponse);
  }

  Future<List<VehicleStat>> getVehicleStats({required String tenantId}) async {
    return await apiClient
        .request<dynamic>(Config(
          uri: Uri.parse('$server2/Stats/Vehicles'),
          method: RequestMethod.get,
          responseType: ResponseBody.json(),
          headers: {'x-tenant': tenantId},
        ))
        .then((dynamic jsonResponse) => (jsonResponse as List)
            .map((vehicleCalendar) =>
                VehicleStat.fromJson(json: vehicleCalendar))
            .toList());
  }

  Future<List<Person>> getPersonsByOrgUnitIdFilter({
    required String tenantId,
    required String requestFilters,
  }) async {
    return await apiClient
        .request<dynamic>(
          Config(
            uri: Uri.parse('$server/Persons?$requestFilters'),
            method: RequestMethod.get,
            responseType: ResponseBody.json(),
            headers: {'x-tenant': tenantId},
          ),
        )
        .then((dynamic jsonResponse) => jsonResponse['Data'] == null
            ? []
            : (jsonResponse['Data'] as List)
                .map((person) => Person.fromJson(json: person))
                .toList());
  }
}
