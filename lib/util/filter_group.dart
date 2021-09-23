import 'package:equatable/equatable.dart';

class FilterGroup {
  final String groupName;
  final List<Filter> filters;
  FilterGroup({required this.groupName, required this.filters});
}

class Filter extends Equatable {
  /// display name
  final String label;

  /// ID
  final dynamic value;

  /// column name  Database
  final String filterName;

  ///
  bool isSelected;

  Filter({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.filterName,
  });

  @override
  List<Object?> get props => [label, value];
}
