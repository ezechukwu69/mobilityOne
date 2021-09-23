import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/vehicle_type.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/vehicle_types_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';

part 'vehicle_types_state.dart';

class VehicleTypesCubit extends Cubit<VehicleTypesState> {
  VehicleTypesCubit({
    required this.vehicletypesRepository,
    required this.tenantsRepository
  }) : super(VehicleTypesInitial());

  final VehicleTypesRepository vehicletypesRepository;
  final TenantsRepository tenantsRepository;
  VehicleType selectedVehicleType =
      VehicleType(id: 0, name: '', tenantId: '');

  late Tenant tenant;

  Future<void> getDataFromApi() async {
    emit(VehicleTypesLoading());
    try {
      tenant =
          await tenantsRepository.getTenants().then((value) => value.first);
      log('Tenant: ${tenant.id}');
      final result = await Future.wait(
        [
          vehicletypesRepository.getVehicleTypes(tenantId: tenant.id),
        ],
      );

      emit(VehicleTypesLoaded(
          vehicletypes: result[0] as List<VehicleType>));
    } catch (error, stackTrace) {
      emit(VehicleTypesError(error: error, stackTrace: stackTrace));
    }
  }

  Future<bool> createVehicleType(
      {String? name}) async {
    final currentState = state;
    if (currentState is VehicleTypesLoaded) {
      try {
        final requestBody = {
          'Name': name ?? '',
          'TenantId': tenant.id
        };
        await vehicletypesRepository.postVehicleType(
            tenantId: tenant.id, requestBody: requestBody);
        await getDataFromApi();
        return true;
      } catch (error, stackTrace) {
        return false;
      }
    }
    return false;
  }

  Future<bool> selectVehicleType({required VehicleType vehicletype}) async {
    try {
      selectedVehicleType = vehicletype;
      return true;
    } catch (error, stackTrace) {
      return false;
    }
  }

  Future<void> deleteVehicleType() async {
    final currentState = state;
    if (currentState is VehicleTypesLoaded && selectedVehicleType.id != '') {
      try {
        await vehicletypesRepository.deleteVehicleType(
            tenantId: tenant.id, vehicleTypeId: selectedVehicleType.id);
        await getDataFromApi();
      } catch (error, stackTrace) {
        emit(VehicleTypesError(error: error, stackTrace: stackTrace));
      }
    }
  }

  Future<bool> updateVehicleType({
    required VehicleType vehicletypeToBeUpdated,
    String? name
  }) async {
    final currentState = state;
    if (currentState is VehicleTypesLoaded) {
      try {
        // final indexToRemove =
        //     currentState.VehicleTypes.indexWhere((_vehicletype) => _vehicletype.id == vehicletypeToBeUpdated.id);

        final updatedVehicleType = vehicletypeToBeUpdated.copyWith(
          id: vehicletypeToBeUpdated.id,
          name: name
        );

        final requestBody = updatedVehicleType.toMap();
        await vehicletypesRepository.putVehicleType(
            tenantId: tenant.id,
            requestBody: requestBody,
            vehicleTypeId: updatedVehicleType.id);

        // currentState.VehicleTypes.removeAt(indexToRemove);
        // currentState.VehicleTypes.insert(indexToRemove, updatedVehicleType);
        await getDataFromApi();

        // emit(VehicleTypesLoaded(
        //     VehicleTypes: List.of(currentState.VehicleTypes),
        //     orgUnits: currentState.orgUnits));
        log('Successfuly updated vehicletype');
        return true;
      } catch (error, stackTrace) {
        return false;
      }
    }
    return false;
  }
}
