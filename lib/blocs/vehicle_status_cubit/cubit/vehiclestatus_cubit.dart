import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/pool.dart';
import 'package:mobility_one/models/vehicle_stat.dart';
import 'package:mobility_one/models/vehicle_type.dart';
import 'package:mobility_one/ui/widgets/draggable_card.dart';

part 'vehiclestatus_state.dart';

class VehicleStatusCubit extends Cubit<VehicleStatusState> {
  late List<Draggable_custom_card> needsAttentionList = [];
  late List<Draggable_custom_card> driverUnassignedList = [];
  late List<Draggable_custom_card> inMaintanceList = [];
  late List<Draggable_custom_card> recentlyHandledList = [];
  late List<Draggable_custom_card> allVehiclesList = [];
  final List<VehicleType> vehicletypes = [
    VehicleType(id: 1, name: 'Tram', tenantId: '1'),
    VehicleType(id: 1, name: 'Car', tenantId: '1'),
    VehicleType(id: 1, name: 'Truck', tenantId: '1'),
    VehicleType(id: 1, name: 'Motorbike', tenantId: '1'),
    VehicleType(id: 1, name: 'Forklift', tenantId: '1'),
    VehicleType(id: 1, name: 'Boat', tenantId: '1'),
  ];
  final List<Pool> pools = [
    Pool(id: '1', name: 'Forklifts', tenantId: '1'),
    Pool(id: '1', name: 'Motorbikers', tenantId: '1'),
    Pool(id: '1', name: 'Trams', tenantId: '1'),
    Pool(id: '1', name: 'Mopeds', tenantId: '1'),
    Pool(id: '1', name: 'Taxies', tenantId: '1'),
    Pool(id: '1', name: 'Cars', tenantId: '1'),
    Pool(id: '1', name: 'Trucks', tenantId: '1'),
  ];
  final List<VehicleStat> vehicleStats = [
    VehicleStat(
        availability: 'In procurement', count: 2, generalStatus: 'status'),
    VehicleStat(
        availability: 'Active:Reserved', count: 2, generalStatus: 'status'),
    VehicleStat(availability: 'Active:Free', count: 2, generalStatus: 'status'),
  ];
  VehicleStatusCubit() : super(VehiclestatusInitial());

  Future<void> mockVehicleStatus() async {
    emit(VehicleStatusLoading());

    await Future.delayed(Duration(seconds: 1), () {
      needsAttentionList.add(Draggable_custom_card(
          status: 0,
          name: 'John',
          vehicle: 'Skoda',
          distance: '1 mile away',
          list: needsAttentionList));
      driverUnassignedList.add(Draggable_custom_card(
          status: 1,
          name: 'Sarah',
          vehicle: 'Bmw',
          distance: '15 mile away',
          list: driverUnassignedList));
      inMaintanceList.add(Draggable_custom_card(
          status: 2,
          name: 'Johannes',
          vehicle: 'Mercedes',
          distance: '7 mile away',
          list: inMaintanceList));
      recentlyHandledList.add(Draggable_custom_card(
          status: 1,
          name: 'Alex',
          vehicle: 'Volkswagen',
          distance: '3 mile away',
          list: recentlyHandledList));
      allVehiclesList.add(Draggable_custom_card(
          status: 0,
          name: 'Dave',
          vehicle: 'Ford',
          distance: '21 mile away',
          list: allVehiclesList));
      emit(VehicleStatusFetched(
          needsAttentionList,
          driverUnassignedList,
          inMaintanceList,
          recentlyHandledList,
          allVehiclesList,
          vehicletypes,
          pools,
          vehicleStats));
    });
  }

  Future<void> dropOnTarget(
      List origin, List target, Draggable_custom_card data) async {
    emit(VehicleStatusLoading());

    var newData = Draggable_custom_card(
        status: data.status,
        name: data.name,
        vehicle: data.vehicle,
        distance: data.distance,
        list: target as List<Draggable_custom_card>);
    origin.remove(data);
    target.add(newData);

    emit(VehicleStatusFetched(
        needsAttentionList,
        driverUnassignedList,
        inMaintanceList,
        recentlyHandledList,
        allVehiclesList,
        vehicletypes,
        pools,
        vehicleStats));
  }

  Future<void> filterCards() async {
    emit(VehicleStatusLoading());

    try {
      //mock api
      await Future.delayed(Duration(seconds: 1), () {
        emit(VehicleStatusFetched(
            needsAttentionList,
            driverUnassignedList,
            inMaintanceList,
            recentlyHandledList,
            allVehiclesList,
            vehicletypes,
            pools,
            vehicleStats));
      });
    } catch (err, stackTrace) {
      print(err);
      emit(VehicleStatusError(error: err, stackTrace: stackTrace));
    }
  }

   Future<void> searchItems(String searchText) async {
    emit(VehicleStatusLoading());

    try {
      //mock api
      await Future.delayed(Duration(seconds: 1), () {
        emit(VehicleStatusFetched(
            needsAttentionList,
            driverUnassignedList,
            inMaintanceList,
            recentlyHandledList,
            allVehiclesList,
            vehicletypes,
            pools,
            vehicleStats));
      });
    } catch (err, stackTrace) {
      print(err);
      emit(VehicleStatusError(error: err, stackTrace: stackTrace));
    }
  }
  
}
