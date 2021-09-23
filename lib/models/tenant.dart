import 'package:equatable/equatable.dart';

class Tenant extends Equatable {
  final String id;
  final String? identifier;
  final String? name;
  final String? currency;
  final String? accountId;

  Tenant({required this.id, this.identifier, this.name, required this.accountId, this.currency});

  factory Tenant.fromJson({required Map<String, dynamic> json}) {
    final String id = json['Id'];
    final String? identifier = json['Identifier'];
    final String? name = json['Name'];
    final String? accountId = json['AccountId'];
    final String? currency = json['Currency'] ?? 'mockedTenant';
    return Tenant(id: id, accountId: accountId, identifier: identifier, name: name, currency: currency);
  }

  Tenant copyWith({
    String? id,
    String? name,
    String? identifier,
    String? accountId,
    String? currency,
  }) {
    return Tenant(
        id: id ?? this.id,
        name: name ?? this.name,
        identifier: identifier ?? this.identifier,
        accountId: accountId ?? this.accountId,
        currency: currency ?? this.currency
    );
  }

  Map<String, String> toMap() {
    return {
      'Id': id ,
      'Identifier': identifier ?? '',
      'Name': name ?? '',
      'AccountId': accountId ?? '',
      'Currency': currency ?? ''
    };
  }

  @override
  List<Object?> get props => [id, identifier, name, accountId];
}
