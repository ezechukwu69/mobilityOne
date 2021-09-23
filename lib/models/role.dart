import 'package:equatable/equatable.dart';

class Role extends Equatable {
  final String id;
  final String? name;
  final String? description;

  Role({required this.id, this.name, this.description});

  factory Role.fromJson({required Map<String, dynamic> json}) {
    final String id = json['Id'];
    final String? name = json['Name'];
    final String? description = json['Description'];

    return Role(id: id, name: name, description: description);
  }

  Role copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return Role(
        id: id ?? this.id, name: name ?? this.name, description: description ?? this.description);
  }

  Map<String, String> toMap() {
    return {
      'Name': name ?? '',
      'Description': description ?? '',
    };
  }

  @override
  List<Object?> get props => [id, name, description];

  @override
  bool? get stringify => true;
}
