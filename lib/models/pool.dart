import 'package:equatable/equatable.dart';

class Pool extends Equatable {
  final String id;
  final String name;
  final String tenantId;

  Pool({
    required this.id,
    required this.name,
    required this.tenantId
  });

  factory Pool.fromJson({required Map<String, dynamic> json}) {
    final String id = json['Id'];
    final String name = json['Name'];
    final String tenantId = json['TenantId'];


    return Pool(
        id: id,
        name: name,
        tenantId: tenantId);
  }

  Pool copyWith({
    String? id,
    String? name,
    String? tenantId
  }) {
    return Pool(
      id: id ?? this.id,
      name: name ?? this.name,
      tenantId: tenantId ?? this.tenantId
    );
  }

  Map<String, String> toMap() {
    return {'Id': id, 'Name': name, 'TenantId': tenantId};
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
