class VehicleAssignment {
  String? tenantId;
  String vehicleId;
  DateTime fromTime;
  DateTime toTime;
  String description;
  String assignedToId;
  int assigneeType;
  int? id;
  String vehicleName;
  String? assigneeName;
  String? assigneeTypeName;

  VehicleAssignment({this.tenantId, required this.vehicleId, required this.fromTime, required this.toTime, required this.description, required this.assignedToId, required this.assigneeType, this.id, required this.vehicleName, this.assigneeName, this.assigneeTypeName});

  factory VehicleAssignment.fromJson({required Map<String, dynamic> json}) {
    final tenantId = json['TenantId'] ?? '';
    final vehicleId = json['VehicleId'] ?? '';
    final fromTime = DateTime.parse(json['FromTime']);
    final toTime = DateTime.parse(json['ToTime']);
    final description = json['Description'] ?? '';
    final assignedToId = json['AssignedToId'] ?? '';
    final assigneeType = json['AssigneeType'] ?? '';
    final id = json['Id'] ?? 0;
    final vehicleName = json['VehicleName'] ?? '';
    final assigneeName = json['AssigneeName'] ?? '';
    final assigneeTypeName = json['AssigneeTypeName'] ?? '';

    return VehicleAssignment(id: id, tenantId: tenantId, vehicleId: vehicleId, fromTime: fromTime, toTime: toTime, description: description, assignedToId: assignedToId, assigneeType: assigneeType, vehicleName: vehicleName, assigneeName: assigneeName, assigneeTypeName: assigneeTypeName);
  }

  VehicleAssignment copyWith({
    String? tenantId,
    String? vehicleId,
    DateTime? fromTime,
    DateTime? toTime,
    String? description,
    String? assignedToId,
    int? assigneeType,
    int? id,
    String? vehicleName,
    String? assigneeName,
    String? assigneeTypeName,
  }) {
    return VehicleAssignment(tenantId: tenantId ?? this.tenantId, id: id ?? this.id, vehicleId: vehicleId ?? this.vehicleId, fromTime: fromTime ?? this.fromTime, toTime: toTime ?? this.toTime, description: description ?? this.description, assignedToId: assignedToId ?? this.assignedToId, assigneeType: assigneeType ?? this.assigneeType, vehicleName: vehicleName ?? this.vehicleName);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['TenantId'] = tenantId;
    data['VehicleId'] = vehicleId;
    data['FromTime'] = fromTime.toIso8601String();
    data['ToTime'] = toTime.toIso8601String();
    data['Description'] = description;
    data['AssignedToId'] = assignedToId;
    data['AssigneeType'] = assigneeType;
    data['Id'] = id;
    data['VehicleName'] = vehicleName;
    data['AssigneeName'] = assigneeName;
    data['AssigneeTypeName'] = assigneeTypeName;
    return data;
  }
}
