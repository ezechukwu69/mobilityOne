import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/pools_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';

part 'pools_state.dart';

class PoolsCubit extends Cubit<PoolsState> {
  PoolsCubit({required this.poolsRepository, required this.tenantsRepository})
      : super(PoolsInitial());

  final PoolsRepository poolsRepository;
  final TenantsRepository tenantsRepository;
  Pool selectedPool = Pool(id: '', name: '', tenantId: '');

  late Tenant tenant;

  Future<void> getDataFromApi() async {
    emit(PoolsLoading());
    try {
      tenant =
          await tenantsRepository.getTenants().then((value) => value.first);
      log('Tenant: ${tenant.id}');
      final result = await Future.wait(
        [
          poolsRepository.getPools(tenantId: tenant.id),
        ],
      );

      emit(PoolsLoaded(pools: result[0] as List<Pool>));
    } catch (error, stackTrace) {
      emit(PoolsError(error: error, stackTrace: stackTrace));
    }
  }

  Future<bool> createPool({String? name}) async {
    final currentState = state;
    if (currentState is PoolsLoaded) {
      try {
        final requestBody = {'Name': name ?? '', 'TenantId': tenant.id};
        await poolsRepository.postPool(
            tenantId: tenant.id, requestBody: requestBody);
        await getDataFromApi();
        return true;
      } catch (error, stackTrace) {
        return false;
      }
    }
    return false;
  }

  Future<bool> selectPool({required Pool pool}) async {
    try {
      selectedPool = pool;
      return true;
    } catch (error, stackTrace) {
      return false;
    }
  }

  Future<void> deletePool() async {
    final currentState = state;
    if (currentState is PoolsLoaded && selectedPool.id != '') {
      try {
        await poolsRepository.deletePool(
            tenantId: tenant.id, poolId: selectedPool.id);
        final indexToRemove = currentState.pools
            .indexWhere((_pool) => _pool.id == selectedPool.id);
        currentState.pools.removeAt(indexToRemove);

        emit(PoolsInitial());
        emit(PoolsLoaded(pools: currentState.pools));
      } catch (error, stackTrace) {
        emit(PoolsError(error: error, stackTrace: stackTrace));
      }
    }
  }

  Future<bool> updatePool({required Pool poolToBeUpdated, String? name}) async {
    final currentState = state;
    if (currentState is PoolsLoaded) {
      try {
        final indexToRemove = currentState.pools
            .indexWhere((_pool) => _pool.id == poolToBeUpdated.id);

        final updatedPool =
            poolToBeUpdated.copyWith(id: poolToBeUpdated.id, name: name);

        final requestBody = updatedPool.toMap();
        await poolsRepository.putPool(
            tenantId: tenant.id,
            requestBody: requestBody,
            poolId: updatedPool.id);

        currentState.pools.removeAt(indexToRemove);
        currentState.pools.insert(indexToRemove, updatedPool);

        emit(PoolsInitial());
        emit(PoolsLoaded(pools: currentState.pools));

        log('Successfuly updated pool');
        return true;
      } catch (error, stackTrace) {
        return false;
      }
    }
    return false;
  }

  Future<void> filterPools(Map<String, dynamic> filter) async {
    final currentState = state;
    try{
      if(currentState is PoolsLoaded){
        emit(PoolsLoading());
        List<Pool> filteredPools = [];
      print('filter $filter');

      }
      
    }catch(e,stackTrace){
      emit(PoolsError(error: e, stackTrace: stackTrace));
    }
  }
}
