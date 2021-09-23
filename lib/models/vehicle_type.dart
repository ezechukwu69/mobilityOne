import 'package:equatable/equatable.dart';

class VehicleType extends Equatable {
  final int id;
  final String name;
  final String tenantId;

  VehicleType({
    required this.id,
    required this.name,
    required this.tenantId
  });

  factory VehicleType.fromJson({required Map<String, dynamic> json}) {
    final int id = json['Id'];
    final String name = json['Name'];
    final String tenantId = json['TenantId'];


    return VehicleType(
        id: id,
        name: name,
        tenantId: tenantId);
  }

  VehicleType copyWith({
    int? id,
    String? name,
    String? tenantId
  }) {
    return VehicleType(
      id: id ?? this.id,
      name: name ?? this.name,
      tenantId: tenantId ?? this.tenantId
    );
  }

  Map<String, String> toMap() {
    return {'Id': id.toString(), 'Name': name, 'TenantId': tenantId};
  }

  @override
  List<Object?> get props => [
        id,
        name,
        tenantId
      ];

  @override
  bool? get stringify => true;

  @override
  String toString() {
    return name;
  }
}
