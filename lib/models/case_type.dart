class CaseType {
  int id;
  String name;
  String tenantId;
  int? causesAvailabilityId;
  String? causesAvailability;

  CaseType(
      {required this.id,
        required this.name,
        required this.tenantId,
        this.causesAvailabilityId,
        this.causesAvailability});

  factory CaseType.fromJson({required Map<String, dynamic> json}) {
    final id = json['Id'];
    final name = json['Name'];
    final tenantId = json['TenantId'];
    final causesAvailabilityId = json['CausesAvailabilityId'];
    final causesAvailability = json['CausesAvailability'];

    return CaseType(id: id, name: name, tenantId: tenantId, causesAvailabilityId: causesAvailabilityId, causesAvailability: causesAvailability);
  }

  CaseType copyWith({
    String? name, int? causesAvailabilityId, String? causesAvailability}
      ) {
    return CaseType(
        id: id,
        tenantId: tenantId,
      name: name ?? this.name,
      causesAvailabilityId: causesAvailabilityId ?? this.causesAvailabilityId,
      causesAvailability: causesAvailability ?? this.causesAvailability
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['TenantId'] = tenantId;
    data['CausesAvailabilityId'] = causesAvailabilityId ?? 0;
    data['CausesAvailability'] = causesAvailability ?? 0;
    return data;
  }
}
