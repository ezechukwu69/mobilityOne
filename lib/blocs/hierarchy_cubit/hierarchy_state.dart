part of 'hierarchy_cubit.dart';

abstract class HierarchyState extends Equatable {
  const HierarchyState();

  @override
  List<Object?> get props => [];
}

class HierarchyInitial extends HierarchyState {}

class HierarchyLoading extends HierarchyState {}

class HierarchyLoaded extends HierarchyState {
  // List<OrgUnit> orgUnits;
  final Map<NodeItem, List<NodeItem>?>? hierarchy;
  final NodeItem? selectedNode;
  final NodeItem? selectedTenant;
  final int numberOfNodes;
  HierarchyLoaded({this.hierarchy, this.selectedNode, this.selectedTenant, required this.numberOfNodes});

  @override
  List<Object?> get props => [hierarchy];
}

class HierarchyError extends HierarchyState {
  final dynamic error;
  final StackTrace stackTrace;

  HierarchyError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
