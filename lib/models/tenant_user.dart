import 'package:equatable/equatable.dart';

class TenantUser extends Equatable {
  final String id;
  final String? tenantId;
  final String? tenantName;
  final String? userId;
  final String? userEmail;
  final String? roleId;
  final String? roleName;

  TenantUser(
      {required this.id,
      this.tenantId,
      this.tenantName,
      this.userId,
      this.userEmail,
      this.roleId,
      this.roleName});

  factory TenantUser.fromJson({required Map<String, dynamic> json}) {
    final String id = json['Id'];
    final String? tenantId = json['TenantId'];
    final String? tenantName = json['TenantName'];
    final String? userId = json['UserId'];
    final String? userEmail = json['UserEmail'];
    final String? roleId = json['RoleId'];
    final String? roleName = json['RoleName'];

    return TenantUser(
        id: id,
        tenantId: tenantId,
        tenantName: tenantName,
        userId: userId,
        userEmail: userEmail,
        roleId: roleId,
        roleName: roleName);
  }

  TenantUser copyWith(
      {String? id,
      String? tenantId,
      String? tenantName,
      String? userId,
      String? userEmail,
      String? roleId,
      String? roleName}) {
    return TenantUser(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        tenantName: tenantName ?? this.tenantName,
        userId: userId ?? this.userId,
        userEmail: userEmail ?? this.userEmail,
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName);
  }

  Map<String, String> toMap() {
    return {
      'TenantId': tenantId ?? '',
      'TenantName': tenantName ?? '',
      'UserId': userId ?? '',
      'UserEmail': userEmail ?? '',
      'RoleId': roleId ?? '',
      'RoleName': roleName ?? ''
    };
  }

  @override
  List<Object?> get props => [id, tenantName, userId, userEmail, roleId, roleName];

  @override
  bool? get stringify => true;
}
