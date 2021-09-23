import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/pool.dart';


class PoolsDropdownListState extends Equatable {
  final bool isExpanded;
  final Pool? selectedPool;
  final List<Pool> availablePools;

  PoolsDropdownListState(
      {required this.isExpanded, required this.selectedPool, required this.availablePools});

  PoolsDropdownListState copyWith({
    bool? isExpanded,
    Pool? selectedPool,
    List<Pool>? availablePools,
  }) {
    return PoolsDropdownListState(
        isExpanded: isExpanded ?? this.isExpanded,
        selectedPool: selectedPool ?? this.selectedPool,
        availablePools: availablePools ?? this.availablePools);
  }

  @override
  List<Object?> get props => [isExpanded, selectedPool, availablePools];
}
