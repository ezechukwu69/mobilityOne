import 'package:bloc/bloc.dart';
import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/models/vehicle.dart';

import 'pools_dropdown_list_state.dart';

class PoolsDropdownListCubit
    extends Cubit<PoolsDropdownListState> {
  PoolsDropdownListCubit()
      : super(
          PoolsDropdownListState(
            isExpanded: false,
            selectedPool: null,
            availablePools: [],
          ),
        );

  void getInitialData(
      {required Vehicle? vehicleToBeUpdated,
      required List<Pool> availablePools}) {
    Pool? selectedPool;
    if (vehicleToBeUpdated != null) {
      selectedPool = availablePools.firstWhere(
          (_pool) =>
              _pool.id == vehicleToBeUpdated.poolId);
    }

    emit(state.copyWith(
        availablePools: availablePools,
        selectedPool: selectedPool));
  }

  void updateIsExpanded({required bool isExpanded}) =>
      emit(state.copyWith(isExpanded: isExpanded));

  void updateSelectedPool(
          {required Pool selectedPool}) =>
      emit(state.copyWith(
          selectedPool: selectedPool, isExpanded: false));
}
