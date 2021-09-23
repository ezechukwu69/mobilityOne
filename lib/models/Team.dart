
class Team {
  String id;
  String name;
  String description;
  String tenantId;

  Team({required this.id, required this.name, required this.description, required this.tenantId});

  factory Team.fromJson({required Map<String, dynamic> json}) {
    final id = json['Id'];
    final name = json['Name'];
    final description = json['Description'];
    final tenantId = json['TenantId'];

    return Team(id: id, name: name, description: description, tenantId: tenantId);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Description'] = description;
    data['TenantId'] = tenantId;
    return data;
  }
}