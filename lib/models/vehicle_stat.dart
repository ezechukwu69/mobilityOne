class VehicleStat {
  final String availability;
  final String generalStatus;
  final int count;

  VehicleStat({required this.availability, required this.generalStatus, required this.count});

  factory VehicleStat.fromJson({required Map<String, dynamic> json}) {
    final availability = json['Availability'];
    final generalStatus = json['GeneralStatus'];
    final count = json['Count'];

    return VehicleStat(availability: availability, generalStatus: generalStatus, count: count);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Availability'] = availability;
    data['GeneralStatus'] = generalStatus;
    data['Count'] = count;
    return data;
  }
}