import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/org_unit.dart';

class Person extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String orgUnitId;
  final String tenantId;
  final String? orgUnitName;
  final OrgUnit? orgUnit;

  Person({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    required this.orgUnitId,
    required this.tenantId,
    this.orgUnitName,
    required this.orgUnit
  });

  factory Person.fromJson({required Map<String, dynamic> json}) {
    final String id = json['Id'];
    final String? firstName = json['FirstName'];
    final String? lastName = json['LastName'];
    final String? email = json['Email'];
    final String orgUnitId = json['OrgUnitId'];
    final String tenantId = json['TenantId'];
    final String? orgUnitName = json['OrgUnitName'];
    final String? userId = json['UserId'];

    return Person(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        orgUnitId: orgUnitId,
        tenantId: tenantId,
        orgUnitName: orgUnitName,
        orgUnit: OrgUnit(id: orgUnitId, name: orgUnitName, tenantId: tenantId));
  }

  Person copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? orgUnitId,
    String? tenantId,
    String? orgUnitName,

  }) {
    return Person(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      orgUnitId: orgUnitId ?? this.orgUnitId,
      tenantId: tenantId ?? this.tenantId,
      orgUnitName: orgUnitName ?? this.orgUnitName,
      orgUnit: OrgUnit(id: orgUnitId, name: orgUnitName, tenantId: tenantId!),
    );
  }

  Map<String, String> toMap() {
    return {
      'Id': id,
      'FirstName': firstName ?? '',
      'LastName': lastName ?? '',
      'Email': email ?? '',
      'OrgUnitId': orgUnitId,
      'OrgUnitName': orgUnitName ?? '',
      'TenantId': tenantId
    };
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        orgUnitId,
        tenantId,
        orgUnitName
      ];

  @override
  bool? get stringify => true;
}
