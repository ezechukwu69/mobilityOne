import 'package:mobility_one/models/Team.dart';
import 'package:mobility_one/util/api_calls.dart';

class TeamsRepository {
  final ApiCalls api;

  TeamsRepository({required this.api});

  Future<List<Team>> getTeams({required String tenantId}) async {
    return await api.getTeams(tenantId: tenantId);
  }
}
