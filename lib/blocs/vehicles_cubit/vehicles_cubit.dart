import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/availability.dart';
import 'package:mobility_one/models/general_status.dart';
import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/models/vehicle.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/models/vehicle_type.dart';
import 'package:mobility_one/repositories/availabilities_repository.dart';
import 'package:mobility_one/repositories/general_statuses_repository.dart';
import 'package:mobility_one/repositories/pools_repository.dart';
import 'package:mobility_one/repositories/vehicle_types_repository.dart';
import 'package:mobility_one/repositories/vehicles_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/util/debugBro.dart';
import 'package:mobility_one/util/extentions/string_extention.dart';

part 'vehicles_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> {
  VehiclesCubit(
      {required this.vehiclesRepository,
      required this.tenantsRepository,
      required this.poolsRepository,
      required this.generalStatusesRepository,
      required this.vehicleTypeRepository,
      required this.availabilitiesRepository})
      : super(VehiclesInitial());

  final VehiclesRepository vehiclesRepository;
  final TenantsRepository tenantsRepository;
  final PoolsRepository poolsRepository;
  final GeneralStatusesRepository generalStatusesRepository;
  final VehicleTypesRepository vehicleTypeRepository;
  final AvailabilitiesRepository availabilitiesRepository;
  Vehicle selectedVehicle = Vehicle(
      id: '',
      tenantId: '',
      poolId: '',
      vehicleTypeId: 0,
      generalStatusId: 0,
      availabilityId: 0);

  late Tenant tenant;

  Future<void> getDataFromApi() async {
    emit(VehiclesLoading());
    try {
      tenant =
          await tenantsRepository.getTenants().then((value) => value.first);
      log('Tenant: ${tenant.id}');
      final result = await Future.wait(
        [
          poolsRepository.getPools(tenantId: tenant.id),
          vehicleTypeRepository.getVehicleTypes(tenantId: tenant.id),
          generalStatusesRepository.getGeneralStatuses(tenantId: tenant.id),
          availabilitiesRepository.getAvailabilities(tenantId: tenant.id),
          vehiclesRepository.getVehicles(tenantId: tenant.id),
        ],
      );

      emit(VehiclesLoaded(
          pools: result.first as List<Pool>,
          vehicleTypes: result[1] as List<VehicleType>,
          generalStatuses: result[2] as List<GeneralStatus>,
          availabilities: result[3] as List<Availability>,
          vehicles: result[4] as List<Vehicle>));
    } catch (error, stackTrace) {
      emit(VehiclesError(error: error, stackTrace: stackTrace));
    }
  }

  Future<bool> createVehicle(
      {String? displayName,
      String? licencePlate,
      String? vin,
      String? model,
      String? type,
      required Pool pool,
      required VehicleType vehicleType,
      required GeneralStatus generalStatus,
      required Availability availability}) async {
    final currentState = state;
    if (currentState is VehiclesLoaded) {
      try {
        emit(VehiclesLoading());

        final requestBody = {
          'DisplayName': displayName ?? '',
          'LicencePlate': licencePlate ?? '',
          'VIN': vin ?? '',
          'Model': model ?? '',
          'Type': type ?? '',
          'TenantId': tenant.id,
          'PoolId': pool.id,
          'VehicleTypeId': vehicleType.id.toString(),
          'GeneralStatusId': generalStatus.id.toString(),
          'AvailabilityId': availability.id.toString()
        };
        await vehiclesRepository.postVehicle(
            tenantId: tenant.id, requestBody: requestBody);
        await getDataFromApi();
        return true;
      } catch (error, stackTrace) {
        emit(VehiclesError(error: error, stackTrace: stackTrace));
        return false;
      }
    }
    return false;
  }

  Future<bool> selectVehicle({required Vehicle vehicle}) async {
    try {
      selectedVehicle = vehicle;
      return true;
    } catch (error, stackTrace) {
      return false;
    }
  }

  Future<void> deleteVehicle({required String vehicleId}) async {
    final currentState = state;
    if (currentState is VehiclesLoaded) {
      emit(VehiclesLoading());

      try {
        await vehiclesRepository.deleteVehicle(
          tenantId: tenant.id,
          vehicleId: vehicleId,
        );

        final indexToRemove = currentState.vehicles
            .indexWhere((_vehicle) => _vehicle.id == vehicleId);

        currentState.vehicles.removeAt(indexToRemove);

        emit(VehiclesLoaded(
          pools: currentState.pools,
          vehicleTypes: currentState.vehicleTypes,
          generalStatuses: currentState.generalStatuses,
          availabilities: currentState.availabilities,
          vehicles: currentState.vehicles,
        ));
      } catch (error, stackTrace) {
        emit(VehiclesError(error: error, stackTrace: stackTrace));
      }
    }
  }

  Future<bool> updateVehicle(
      {required Vehicle vehicleToBeUpdated,
      String? displayName,
      String? licencePlate,
      String? vin,
      String? model,
      String? type,
      required Pool pool,
      required VehicleType vehicleType,
      required GeneralStatus generalStatus,
      required Availability availability}) async {
    final currentState = state;
    if (currentState is VehiclesLoaded) {
      try {
        emit(VehiclesLoading());

        final indexToRemove = currentState.vehicles
            .indexWhere((_vehicle) => _vehicle.id == vehicleToBeUpdated.id);

        final updatedVehicle = vehicleToBeUpdated.copyWith(
            id: vehicleToBeUpdated.id,
            displayName: displayName,
            licencePlate: licencePlate,
            type: type,
            model: model,
            vin: vin,
            poolId: pool.id,
            availabilityId: availability.id,
            availability: availability.name,
            generalStatusId: generalStatus.id,
            poolName: pool.name,
            generalStatusName: generalStatus.name,
            vehicleTypeId: vehicleType.id,
            vehicleTypeName: vehicleType.name);

        final requestBody = updatedVehicle.toMap();
        await vehiclesRepository.putVehicle(
            tenantId: tenant.id,
            requestBody: requestBody,
            vehicleId: updatedVehicle.id);

        currentState.vehicles.removeAt(indexToRemove);
        currentState.vehicles.insert(indexToRemove, updatedVehicle);

        emit(VehiclesInitial());

        emit(VehiclesLoaded(
            pools: currentState.pools,
            vehicleTypes: currentState.vehicleTypes,
            generalStatuses: currentState.generalStatuses,
            availabilities: currentState.availabilities,
            vehicles: currentState.vehicles));

        log('Successfuly updated vehicle');
        return true;
      } catch (error, stackTrace) {
        // elog(error);
        emit(VehiclesError(error: error, stackTrace: stackTrace));
        return false;
      }
    }
    return false;
  }

  Future<void> filterVehiclesList(String requestFilters) async {
    final currentState = state;

    // end here if not loaded
    if (!(currentState is VehiclesLoaded)) return;

    try {
      emit(VehiclesLoading());

      final vehicles = await vehiclesRepository.getVehiclesByFilter(
        tenantId: tenant.id,
        requestFilters: requestFilters,
      );

      emit(VehiclesLoaded(
        pools: currentState.pools,
        vehicleTypes: currentState.vehicleTypes,
        generalStatuses: currentState.generalStatuses,
        availabilities: currentState.availabilities,
        vehicles: vehicles,
      ));
    } catch (error, stackTrace) {
      emit(VehiclesError(error: error, stackTrace: stackTrace));
    }
  }

  Future<void> importVehicle(List<Map<String, String>> records) async {
    final currentState = state;

    // end here if not loaded
    if (currentState is! VehiclesLoaded) return;

    try {
      emit(VehiclesLoading());

      await Future.forEach(records, (Map<String, String> record) async {
        try {
          //

          var requestBody = record;

          /// record['PoolId']  contains the name not the id
          /// so we use the name to find the id
          /// SAME APPLIES TO THE OTHER FIELDS DOWN THERE
          var poolId = currentState.pools
              .firstWhere(
                  (pool) => pool.name.isEqualIgnoreCase(record['PoolId']!))
              .id;

          var vehicleTypeId = currentState.vehicleTypes
              .firstWhere((vehicelType) =>
                  vehicelType.name.isEqualIgnoreCase(record['VehicleTypeId']!))
              .id
              .toString();

          var generalStatusId = currentState.generalStatuses
              .firstWhere((status) =>
                  status.name.isEqualIgnoreCase(record['GeneralStatusId']!))
              .id
              .toString();

          var availabilityId = currentState.availabilities
              .firstWhere((availability) => availability.name
                  .isEqualIgnoreCase(record['AvailabilityId']!))
              .id
              .toString();

          requestBody['PoolId'] = poolId;
          requestBody['VehicleTypeId'] = vehicleTypeId;
          requestBody['GeneralStatusId'] = generalStatusId;
          requestBody['AvailabilityId'] = availabilityId;

          ilog(requestBody);

          await vehiclesRepository.postVehicle(
            tenantId: tenant.id,
            requestBody: requestBody,
          );
        } catch (e) {
          logger.e(e);
        }
      });

      // get records from serve and emit VehiclesLoaded
      await getDataFromApi();
    } catch (e) {
      elog(e);
    }
  }
}
