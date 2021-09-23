import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/node_item.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/accounts_repository.dart';
import 'package:mobility_one/repositories/org_units_repository.dart';
import 'package:mobility_one/repositories/persons_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';

part 'hierarchy_state.dart';

class HierarchyCubit extends Cubit<HierarchyState> {
  HierarchyCubit({
    required this.personsRepository,
    required this.tenantsRepository,
    required this.orgUnitsRepository,
    required this.accountsRepository,
  }) : super(HierarchyInitial());

  final PersonsRepository personsRepository;
  final TenantsRepository tenantsRepository;
  final OrgUnitsRepository orgUnitsRepository;
  final AccountsRepository accountsRepository;

  late List<Tenant> tenants;
  Map<NodeItem, List<NodeItem>> hierarchy = {};

  Future<void> getDataFromApi() async {
    emit(HierarchyLoading());
    try {
      tenants = await tenantsRepository.getTenants();

      var orgUnitsRequests = tenants.map((tenant) async {
        return await orgUnitsRepository.getOrgUnitsTree(tenantId: tenant.id);
      }).toList();

      var orgUnitsRequestsResult = (await Future.wait(orgUnitsRequests)).toList();
      _createHierarchyFirstLevel(tenants);

      await Future.forEach<List<OrgUnit>>(orgUnitsRequestsResult, (_orgUnits) => _addOrgUnitsToHierarchy(_orgUnits));

      emit(HierarchyLoaded(hierarchy: hierarchy, selectedTenant: hierarchy.keys.first, numberOfNodes: OrgUnit.numberOfNodes));
    } catch (error, stackTrace) {
      print('error $error');
      emit(HierarchyError(error: error, stackTrace: stackTrace));
    }
  }

  void _createHierarchyFirstLevel(List<Tenant> tenants) {
    for (var tenant in tenants) {
      var nodeItem = NodeItem(value: tenant, name: tenant.name!, id: tenant.id);
      hierarchy[nodeItem] = [];
    }
  }

  void _addOrgUnitsToHierarchy(List<OrgUnit> orgUnits) async {
    var tenantParent = hierarchy.keys.firstWhere((element) => element.id == orgUnits.first.tenantId);
    for (var orgUnit in orgUnits) {
      var orgUnitNode = NodeItem(value: orgUnit, name: orgUnit.name!, id: orgUnit.id!);
      for (var child in orgUnit.children!) {
        orgUnitNode.addChild(NodeItem(value: child, name: child.name!, id: child.id!));
      }

      hierarchy[tenantParent]!.add(orgUnitNode);
    }
  }

  Future<bool> createPerson({String? firstName, String? lastName, String? email, required OrgUnit orgUnit}) async {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      try {
        final requestBody = {'FirstName': firstName ?? '', 'LastName': lastName ?? '', 'Email': email ?? '', 'OrgUnitId': orgUnit.id!, 'OrgUnitName': orgUnit.name ?? '', 'TenantId': tenants[0].id};
        await personsRepository.postPerson(tenantId: tenants[0].id, requestBody: requestBody);
        await getDataFromApi();
        return true;
      } catch (error, stackTrace) {
        return false;
      }
    }
    return false;
  }

  Future<void> deleteOrgUnit({required String orgUnitId, required String tenantId}) async {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      try {
        await orgUnitsRepository.deleteOrgUnit(orgUnitId: orgUnitId, tenantId: tenantId);
        await getDataFromApi();
      } catch (error, stackTrace) {
        emit(HierarchyError(error: error, stackTrace: stackTrace));
      }
    }
  }

  Future<bool> updateChildNode({NodeItem? parentNodeItem, required NodeItem childNodeItem, required String tenantId}) async {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      try {

        var requestBody = OrgUnit(id: childNodeItem.id,tenantId: tenantId, parentOrgUnitId: parentNodeItem?.value.id, name: childNodeItem.value.name, parentOrgUnit: parentNodeItem?.value).toMap();
        await orgUnitsRepository.putOrgUnit(tenantId: tenantId, orgUnitId: childNodeItem.id, requestBody: {...requestBody, 'Id': childNodeItem.id});

        await getDataFromApi();
        return true;
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        return false;
      }
    }
    return false;
  }

  Future<bool> insertChildIntoRoot({required NodeItem child, required String tenantId}) async {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      try {
        final indexToRemove = currentState.hierarchy![tenantId]!.indexWhere((orgUnit) => orgUnit.id == child.id);
        //
        // final updatedNodeItem = NodeItem(id: childOrgUnit.id, tenantId: childOrgUnit.tenantId, name: childOrgUnit.name, parentOrgUnitId: null, value: );
        //
        // final requestBody = updatedOrgUnit.toMap();
        // //await orgUnitsRepository.putOrgUnit(tenantId: tenant.id, orgUnitId: updatedOrgUnit.id, requestBody: requestBody);
        //
        // currentState.hierarchy![tenantId]!.removeAt(indexToRemove);
        // currentState.hierarchy![tenantId]!.insert(indexToRemove, updatedOrgUnit);
        //
        // emit(HierarchyInitial());
        // emit(HierarchyLoaded(tenants: List.of(currentState.tenants), hierarchy: currentState.hierarchy));
        return true;
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        return false;
      }
    }
    return false;
  }

  Future<bool> updateNodeItemName({required NodeItem nodeItem, required String name, String? tenantId}) async {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      try {

        final updatedNodeItem = nodeItem.value.copyWith(
          name: name,
        );

        final requestBody = updatedNodeItem.toMap();
        if (updatedNodeItem is OrgUnit) {
          print('[Updating Org Unit Name]');
          await orgUnitsRepository.putOrgUnit(tenantId: tenantId!, orgUnitId: updatedNodeItem.id!, requestBody: {...requestBody, 'Id': updatedNodeItem.id!});
        }

        if (updatedNodeItem is Tenant) {
          print('[Updating Tenant Name]');
          await tenantsRepository.putTenant(tenantId: tenantId!, requestBody: requestBody);
        }

        await getDataFromApi();
        return true;
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        return false;
      }
    }
    return false;
  }

  Future<bool> createOrgUnit({required String name, required String tenantId, String? parentOrgUnitId}) async {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      try {
        final newOrgUnit = OrgUnit(id:'00000000-0000-0000-0000-000000000000', tenantId: tenantId, name: name, parentOrgUnitId: parentOrgUnitId);
        final requestBody = newOrgUnit.toMap();
        print('request body $requestBody');
        await orgUnitsRepository.postOrgUnit(tenantId: tenantId, requestBody: requestBody);

        emit(HierarchyLoading());
        await getDataFromApi();
        return true;
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        return false;
      }
    }
    return false;
  }

  void goToRoot() {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      emit(HierarchyLoaded(hierarchy: currentState.hierarchy, selectedNode: null, numberOfNodes: OrgUnit.numberOfNodes));
    }
  }

  void selectTenantItem(NodeItem nodeItem) {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      emit(HierarchyLoading());
      emit(HierarchyLoaded(hierarchy: currentState.hierarchy, selectedTenant: nodeItem, numberOfNodes: OrgUnit.numberOfNodes));
    }
  }

  void selectNodeItem(NodeItem nodeItem) {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      emit(HierarchyLoading());
      emit(HierarchyLoaded(
        hierarchy: currentState.hierarchy,
        selectedTenant: currentState.hierarchy!.keys.firstWhere((element) => element.id == nodeItem.value.tenantId),
        selectedNode: nodeItem,
        numberOfNodes: OrgUnit.numberOfNodes,
      ));
    }
  }

  void searchItems(String searchText) async {
    final currentState = state;
    if (currentState is HierarchyLoaded) {
      emit(HierarchyLoading());
      final Map<NodeItem, List<NodeItem>?>?  filteredHierarchy = {};
      final originalHierarchy = currentState.hierarchy!;
      var nodeItems = originalHierarchy[originalHierarchy.keys.first]!;

      for (var nodeItem in nodeItems) {
        var foundedNode = getNodeWithName(nodeItem, searchText);
        if (foundedNode != null) {
          if (filteredHierarchy![originalHierarchy.keys.first] == null) {
            filteredHierarchy[originalHierarchy.keys.first] = [];
          }
          filteredHierarchy[originalHierarchy.keys.first]!.add(foundedNode);
        }
      }

      emit(HierarchyLoaded(hierarchy: filteredHierarchy, numberOfNodes: OrgUnit.numberOfNodes));
    }
  }

  NodeItem? getNodeWithName(NodeItem nodeItem, String name) {
    if (nodeItem.name.contains(name)) {
      return nodeItem;
    }
    if (nodeItem.children != null) {
      for(var child in nodeItem.children!) {
        return getNodeWithName(child, name);
      }
    } else {
      return null;
    }
  }
}
