import 'package:mobility_one/models/availability.dart';
import 'package:mobility_one/util/api_calls.dart';

class AvailabilitiesRepository {
  final ApiCalls api;

  AvailabilitiesRepository({required this.api});

  Future<List<Availability>> getAvailabilities({required String tenantId}) async {
    return await api.getAvailabilities(tenantId: tenantId);
  }
}
