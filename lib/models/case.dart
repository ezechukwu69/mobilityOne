import 'package:equatable/equatable.dart';

class Case extends Equatable {
  int id;
  String? tenantId;
  String? name;
  String? vehicleId;
  String? vehicleName;
  int caseTypeId;
  String? caseTypeName;
  int? enclosingCaseId;
  String? enclosingCaseName;
  int? mileage;
  String? mileageUnit;
  DateTime startTime;
  DateTime expectedEndTime;
  DateTime endTime;
  int? caseStatusId;
  String? comment;
  String? detailedDescription;
  String? assigneeId;
  int? assigneeType;
  String? assigneeName;

  Case(
      {
        required this.id,
        required this.tenantId,
        required this.name,
        required this.vehicleId,
        this.vehicleName,
        required this.caseTypeId,
        this.caseTypeName,
        this.enclosingCaseId,
        this.enclosingCaseName,
        required this.startTime,
        required this.expectedEndTime,
        required this.endTime,
        this.caseStatusId,
        required this.comment,
        required this.detailedDescription,
        required this.assigneeId,
        this.assigneeType,
        this.mileage,
        this.mileageUnit,
        this.assigneeName});

  factory Case.fromJson({required Map<String, dynamic> json}) {
    final id = json['Id'];
    final tenantId = json['TenantId'];
    final name = json['Name'];
    final vehicleId = json['VehicleId'];
    final vehicleName = json['VehicleName'];
    final caseTypeId = json['CaseTypeId'];
    final caseTypeName = json['CaseTypeName'];
    final enclosingCaseId = json['EnclosingCaseId'];
    final enclosingCaseName = json['EnclosingCaseName'];
    final startTime = DateTime.parse(json['StartTime']);
    final expectedEndTime =DateTime.parse( json['ExpectedEndTime']);
    final endTime =DateTime.parse(json['EndTime']);
    final caseStatusId = json['CaseStatusId'];
    final comment = json['Comment'];
    final detailedDescription = json['DetailedDescription'];
    final assigneeId = json['AssigneeId'];
    final assigneeType = json['AssigneeType'];
    final mileage = json['Mileage'];
    final mileageUnit = json['MileageUnit'];
    final assigneeName = json['AssigneeName'];

    return Case(id: id, tenantId: tenantId, name: name, vehicleId: vehicleId, vehicleName: vehicleName, caseTypeId: caseTypeId, caseTypeName: caseTypeName, enclosingCaseId: enclosingCaseId, enclosingCaseName: enclosingCaseName, startTime: startTime, expectedEndTime: expectedEndTime, endTime: endTime, caseStatusId: caseStatusId, comment: comment, detailedDescription: detailedDescription, assigneeId: assigneeId, assigneeType: assigneeType, assigneeName: assigneeName, mileage: mileage, mileageUnit: mileageUnit);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['TenantId'] = tenantId;
    data['Name'] = name;
    data['VehicleId'] = vehicleId;
    data['VehicleName'] = vehicleName;
    data['CaseTypeId'] = caseTypeId;
    data['CaseTypeName'] = caseTypeName;
    data['EnclosingCaseId'] = enclosingCaseId;
    data['EnclosingCaseName'] = enclosingCaseName;
    data['StartTime'] = startTime.toIso8601String();
    data['ExpectedEndTime'] = expectedEndTime.toIso8601String();
    data['EndTime'] = endTime.toIso8601String();
    data['CaseStatusId'] = caseStatusId ?? 0;
    data['Comment'] = comment;
    data['DetailedDescription'] = detailedDescription;
    data['AssigneeId'] = assigneeId;
    data['AssigneeType'] = assigneeType ?? 0;
    data['AssigneeName'] = assigneeName;
    data['Mileage'] = mileage;
    data['MileageUnit'] = mileageUnit;
    return data;
  }

  Case copyWith({
  required String? name, required String? vehicleId, required String? assigneeId, required String? description, required String? comment, required DateTime? startDate, required DateTime? endDate, required DateTime? expectedEndDate, required int? caseTypeId, required int? mileage, required String? mileageUnit}
  ) {
    return Case(
      id: id,
      comment: comment ?? this.comment,
      caseTypeId: caseTypeId ?? this.caseTypeId,
      vehicleId: vehicleId ?? this.vehicleId,
      name: name ?? this.name,
      tenantId: this.tenantId,
      assigneeId: assigneeId ?? this.assigneeId,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      endTime: endDate ?? endTime,
      expectedEndTime: expectedEndDate ?? expectedEndTime,
      startTime: startDate ?? startTime,
      assigneeType: assigneeType,
      mileageUnit: mileageUnit ?? this.mileageUnit,
      mileage: mileage ?? this.mileage,
      assigneeName: assigneeName,
      caseStatusId: caseStatusId,
      caseTypeName: caseTypeName,
      enclosingCaseId: enclosingCaseId,
      enclosingCaseName: enclosingCaseName,
      vehicleName: vehicleName
       );
  }

  @override
  List<Object?> get props => [];
}