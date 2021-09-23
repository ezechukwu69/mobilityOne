import 'package:mobility_one/models/general_status.dart';
import 'package:mobility_one/util/api_calls.dart';

class GeneralStatusesRepository {
  final ApiCalls api;

  GeneralStatusesRepository({required this.api});

  Future<List<GeneralStatus>> getGeneralStatuses({required String tenantId}) async {
    return await api.getGeneralStatuses(tenantId: tenantId);
  }
}
