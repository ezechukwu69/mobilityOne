import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/availability.dart';
import 'package:mobility_one/models/general_status.dart';
import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/models/vehicle_type.dart';

class Vehicle extends Equatable {
  final String id;
  final String? displayName;
  final String? licencePlate;
  final String? vin;
  final String? model;
  final String? type;
  final String tenantId;
  final String poolId;
  final int vehicleTypeId;
  final int generalStatusId;
  final int availabilityId;
  final String? poolName;
  final String? vehicleTypeName;
  final String? generalStatusName;
  final String? availability;

  Pool? pool;
  VehicleType? vehicleType;
  GeneralStatus? generalStatus;
  Availability? availabilityObject;

  Vehicle(
      {required this.id,
      this.displayName,
      this.licencePlate,
      this.vin,
      this.model,
      this.type,
      required this.poolId,
      required this.vehicleTypeId,
      required this.tenantId,
      required this.generalStatusId,
      required this.availabilityId,
      this.poolName,
      this.vehicleTypeName,
      this.generalStatusName,
      this.availability,
      this.pool,
      this.vehicleType,
      this.generalStatus,
      this.availabilityObject});

  factory Vehicle.fromJson({required Map<String, dynamic> json}) {
    final String id = json['Id'];
    final String? displayName = json['DisplayName'];
    final String? licencePlate = json['LicencePlate'];
    final String? vin = json['VIN'];
    final String? model = json['Model'];
    final String? type = json['Type'];
    final String tenantId = json['TenantId'];
    final String poolId = json['PoolId'];
    final int vehicleTypeId = json['VehicleTypeId'];
    final int generalStatusId = json['GeneralStatusId'];
    final int availabilityId = json['AvailabilityId'];
    final String? poolName = json['PoolName'];
    final String? vehicleTypeName = json['VehicleTypeName'];
    final String? generalStatusName = json['GeneralStatusName'];
    final String? availability = json['Availability'];

    return Vehicle(
        id: id,
        displayName: displayName,
        licencePlate: licencePlate,
        vin: vin,
        type: type,
        model: model,
        tenantId: tenantId,
        poolId: poolId,
        vehicleTypeId: vehicleTypeId,
        generalStatusId: generalStatusId,
        availabilityId: availabilityId,
        poolName: poolName,
        vehicleTypeName: vehicleTypeName,
        generalStatusName: generalStatusName,
        availability: availability,
        pool: Pool(id: poolId, name: poolName!, tenantId: tenantId),
        vehicleType: VehicleType(
            id: vehicleTypeId, name: vehicleTypeName!, tenantId: tenantId),
        generalStatus:
            GeneralStatus(id: generalStatusId, name: generalStatusName!),
        availabilityObject:
            Availability(id: availabilityId, name: availability!));
  }

  Vehicle copyWith(
      {String? id,
      String? displayName,
      String? licencePlate,
      String? vin,
      String? model,
      String? type,
      String? tenantId,
      String? poolId,
      int? vehicleTypeId,
      int? generalStatusId,
      int? availabilityId,
      String? poolName,
      String? vehicleTypeName,
      String? generalStatusName,
      String? availability}) {
    return Vehicle(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        licencePlate: licencePlate ?? this.licencePlate,
        vin: vin ?? this.vin,
        model: model ?? this.model,
        type: type ?? this.type,
        tenantId: tenantId ?? this.tenantId,
        poolId: poolId ?? this.poolId,
        poolName: poolName ?? this.poolName,
        vehicleTypeId: vehicleTypeId ?? this.vehicleTypeId,
        generalStatusId: generalStatusId ?? this.generalStatusId,
        availabilityId: availabilityId ?? this.availabilityId,
        vehicleTypeName: vehicleTypeName ?? this.vehicleTypeName,
        generalStatusName: generalStatusName ?? this.generalStatusName,
        availability: availability ?? this.availability);
  }

  Map<String, String> toMap() {
    return {
      'Id': id,
      'DisplayName': displayName ?? '',
      'LicencePlate': licencePlate ?? '',
      'VIN': vin ?? '',
      'Model': model ?? '',
      'type': type ?? '',
      'TenantId': tenantId,
      'PoolId': poolId,
      'VehicleTypeId': vehicleTypeId.toString(),
      'GeneralStatusId': generalStatusId.toString(),
      'AvailabilityId': availabilityId.toString(),
      'VehicleTypeName': vehicleTypeName ?? '',
      'GeneralStatusName': generalStatusName ?? '',
      'Availability': availability ?? '',
    };
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        licencePlate,
        vin,
        model,
        type,
        tenantId,
        poolId,
        vehicleTypeId,
        generalStatusId,
        availabilityId,
        vehicleTypeName,
        generalStatusName,
        availability
      ];

  @override
  bool? get stringify => true;
}
