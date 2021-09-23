import 'package:equatable/equatable.dart';

class OrgUnit extends Equatable {
  final String? id;
  final String? name;
  OrgUnit? parentOrgUnit;
  final String? parentOrgUnitId;
  final String tenantId;
  final List<OrgUnit>? children;
  static int numberOfNodes = 0;

  OrgUnit({this.id, this.name, this.parentOrgUnit, this.parentOrgUnitId, required this.tenantId, this.children = const []});

  OrgUnit copyWith({
    String? id,
    String? name,
    String? parentOrgUnitId,
    OrgUnit? parentOrgUnit,
    String? tenantId,
    List<OrgUnit>? children
  }) {
    return OrgUnit(
      id: id ?? this.id,
      name: name ?? this.name,
      parentOrgUnit: parentOrgUnit ?? this.parentOrgUnit,
      parentOrgUnitId: parentOrgUnitId ?? this.parentOrgUnitId,
      tenantId: tenantId ?? this.tenantId,
      children: children ?? this.children
    );
  }

  factory OrgUnit.fromJson({required Map<String, dynamic> json, List<dynamic>? jsonChildren}) {

    OrgUnit.numberOfNodes +=1;
    final String id = json['Id'];
    final String? name = json['Name'];
    final String? parentOrgUnitId = json['ParentOrgUnitId'];
    final String tenantId = json['TenantId'];

    final children = jsonChildren != null ? jsonChildren.map((_org) {
      return OrgUnit.fromJson(json: _org['Item'], jsonChildren: _org['Children']);
    }).toList() : null;


    return OrgUnit(
        id: id, tenantId: tenantId, name: name, parentOrgUnitId: parentOrgUnitId, children: children ?? []);
  }


  Map<String, String?> toMap() {
    return {
      'Id': id ?? '',
      'Name': name ?? '',
      'ParentOrgUnitId': parentOrgUnitId,
      'TenantId': tenantId,
    };
  }

  @override
  List<Object?> get props => [id, name, parentOrgUnitId, tenantId];

  @override
  String toString() {
    return name!;
  }
}
