import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/models/mileage_report.dart';
import 'package:mobility_one/util/api_calls.dart';

class MileageReportsRepository {
  final ApiCalls api;

  MileageReportsRepository({required this.api});

  Future<List<MileageReport>> getMileageReports({required String tenantId}) async {
    return await api.getMileageReports(tenantId: tenantId);
  }

  Future<void> postMileageReport({required String tenantId, required Map<String, dynamic> requestBody}) async {
    return await api.postMileageReport(tenantId: tenantId, requestBody: requestBody);
  }

  Future<void> putMileageReport({required String tenantId, required int mileageReportId, required Map<String, dynamic> requestBody}) async {
    return await api.putMileageReport(tenantId: tenantId, mileageReportId: mileageReportId, requestBody: requestBody);
  }

  Future<void> deleteMileageReport({required String tenantId, required int mileageReportId}) async {
    return await api.deleteMileageReport(tenantId: tenantId, mileageReportId: mileageReportId);
  }
}
