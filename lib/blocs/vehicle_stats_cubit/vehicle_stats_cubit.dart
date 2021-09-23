import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/vehicle_stat.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/repositories/vehicle_stats_repository.dart';

part 'vehicle_stats_state.dart';

class VehicleStatsCubit extends Cubit<VehicleStatsState> {
  VehicleStatsCubit({required this.vehicleStatsRepository, required this.tenantsRepository}) : super(VehicleStatsInitial());

  final VehicleStatsRepository vehicleStatsRepository;
  final TenantsRepository tenantsRepository;

  late Tenant tenant;

  Future<void> getDataFromApi() async {
    emit(VehicleStatsLoading());
    try {
      tenant = await tenantsRepository.getTenants().then((value) => value.first);
      log('Tenant: ${tenant.id}');
      final result = await vehicleStatsRepository.getVehiclesStats(tenantId: tenant.id);

      emit(VehicleStatsLoaded(vehicleStats: result));
    } catch (error, stackTrace) {
      print('error $error');
      emit(VehicleStatsError(error: error, stackTrace: stackTrace));
    }
  }
}
