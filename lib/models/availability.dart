import 'package:equatable/equatable.dart';

class Availability extends Equatable {
  final int id;
  final String name;
  //final String tenantId;

  Availability({
    required this.id,
    required this.name,
    //required this.tenantId
  });

  factory Availability.fromJson({required Map<String, dynamic> json}) {
    final int id = json['Id'];
    final String name = json['Name'];
    //final String tenantId = json['TenantId'];


    return Availability(
        id: id,
        name: name,
        //tenantId: tenantId
        );
  }

  Availability copyWith({
    int? id,
    String? name,
    //String? tenantId
  }) {
    return Availability(
      id: id ?? this.id ,
      name: name ?? this.name,
     // tenantId: tenantId ?? this.tenantId
    );
  }

  Map<String, String> toMap() {
    return {'Id': id.toString(),
            'Name': name,
             //'TenantId': tenantId
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        //tenantId
      ];

  @override
  bool? get stringify => true;

  @override
  String toString() {
    return name;
  }
}
