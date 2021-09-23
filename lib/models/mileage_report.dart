class MileageReport {
  int id;
  String tenantId;
  String vehicleId;
  String? vehicleName;
  DateTime time;
  String measuringUnit;
  double value;
  String comment;

  MileageReport(
      {required this.id,
        required this.tenantId,
        required this.vehicleId,
        this.vehicleName,
        required this.time,
        required this.measuringUnit,
        required this.value,
        required this.comment});

  factory MileageReport.fromJson({required Map<String, dynamic> json}) {
    final id = json['Id'];
    final tenantId = json['TenantId'];
    final vehicleId = json['VehicleId'];
    final vehicleName = json['VehicleName'];
    final time = DateTime.parse(json['Time']);
    final measuringUnit = json['MeasuringUnit'];
    final value = json['Value'];
    final comment = json['Comment'];

    return MileageReport(id: id, tenantId: tenantId, vehicleId: vehicleId, vehicleName: vehicleName, time: time, measuringUnit: measuringUnit, value: value, comment: comment);
  }

  MileageReport copyWith({required String? vehicleId, required String? comment, required double? mileage, required String? measuringUnit, required DateTime? date}) {
    return MileageReport(
        id: id,
        comment: comment ?? this.comment,
        vehicleId: vehicleId ?? this.vehicleId,
        tenantId: tenantId,
        value: mileage ?? value,
        measuringUnit: measuringUnit ?? this.measuringUnit,
        time: date ?? time,
        vehicleName: vehicleName
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['TenantId'] = tenantId;
    data['VehicleId'] = vehicleId;
    data['VehicleName'] = vehicleName;
    data['Time'] = time.toIso8601String();
    data['MeasuringUnit'] = measuringUnit;
    data['Value'] = value;
    data['Comment'] = comment;
    return data;
  }
}