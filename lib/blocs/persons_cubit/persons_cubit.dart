import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/models/person.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/accounts_repository.dart';
import 'package:mobility_one/repositories/org_units_repository.dart';
import 'package:mobility_one/repositories/persons_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/util/debugBro.dart';
import 'package:mobility_one/util/extentions/string_extention.dart';

part 'persons_state.dart';

class PersonsCubit extends Cubit<PersonsState> {
  PersonsCubit({
    required this.personsRepository,
    required this.tenantsRepository,
    required this.orgUnitsRepository,
    required this.accountsRepository,
  }) : super(PersonsInitial());

  final PersonsRepository personsRepository;
  final TenantsRepository tenantsRepository;
  final OrgUnitsRepository orgUnitsRepository;
  final AccountsRepository accountsRepository;
  Person selectedPerson =
      Person(id: '', tenantId: '', orgUnitId: '', orgUnit: null);

  late Tenant tenant;

  Future<void> getDataFromApi() async {
    emit(PersonsLoading());
    try {
      tenant =
          await tenantsRepository.getTenants().then((value) => value.first);
      log('Tenant: ${tenant.id}');
      final result = await Future.wait(
        [
          orgUnitsRepository.getOrgUnits(tenantId: tenant.id),
          personsRepository.getPersons(tenantId: tenant.id),
        ],
      );

      emit(PersonsLoaded(
          orgUnits: result.first as List<OrgUnit>,
          persons: result[1] as List<Person>));
    } catch (error, stackTrace) {
      print('Error $error');
      emit(PersonsError(error: error, stackTrace: stackTrace));
    }
  }

  Future<bool> createPerson(
      {String? firstName,
      String? lastName,
      String? email,
      required OrgUnit orgUnit}) async {
    final currentState = state;
    if (currentState is PersonsLoaded) {
      try {
        final requestBody = {
          'FirstName': firstName ?? '',
          'LastName': lastName ?? '',
          'Email': email ?? '',
          'OrgUnitId': orgUnit.id!,
          'OrgUnitName': orgUnit.name ?? '',
          'TenantId': tenant.id
        };
        await personsRepository.postPerson(
            tenantId: tenant.id, requestBody: requestBody);
        await getDataFromApi();
        return true;
      } catch (error, stackTrace) {
        return false;
      }
    }
    return false;
  }

  Future<bool> invitePerson(
      {required String personId, required List<String> roles}) async {
    try {
      final requestBody = {'Person': personId, 'RolesNames': roles};
      await personsRepository.invitePerson(
          tenantId: tenant.id, requestBody: requestBody);
      return true;
    } catch (error, stackTrace) {
      return false;
    }
  }

  Future<bool> selectPerson({required Person person}) async {
    try {
      selectedPerson = person;
      return true;
    } catch (error, stackTrace) {
      return false;
    }
  }

  Future<void> deletePerson() async {
    final currentState = state;
    if (currentState is PersonsLoaded && selectedPerson.id != '') {
      try {
        await personsRepository.deletePerson(
            tenantId: tenant.id, personId: selectedPerson.id);
        final indexToRemove = currentState.persons
            .indexWhere((_person) => _person.id == selectedPerson.id);
        currentState.persons.removeAt(indexToRemove);
        emit(PersonsInitial());
        emit(PersonsLoaded(
            persons: currentState.persons, orgUnits: currentState.orgUnits));
      } catch (error, stackTrace) {
        emit(PersonsError(error: error, stackTrace: stackTrace));
      }
    }
  }

  Future<bool> updatePerson({
    required Person personToBeUpdated,
    String? firstName,
    String? lastName,
    String? email,
    required OrgUnit orgUnit,
  }) async {
    final currentState = state;
    if (currentState is PersonsLoaded) {
      try {
        final indexToRemove = currentState.persons
            .indexWhere((_person) => _person.id == personToBeUpdated.id);

        final updatedPerson = Person(
            id: personToBeUpdated.id,
            email: email,
            firstName: firstName,
            lastName: lastName,
            orgUnitId: orgUnit.id!,
            orgUnitName: orgUnit.name,
            tenantId: personToBeUpdated.tenantId,
            orgUnit: orgUnit);

        final requestBody = updatedPerson.toMap();
        await personsRepository.putPerson(
            tenantId: tenant.id,
            requestBody: requestBody,
            personId: updatedPerson.id);

        currentState.persons.removeAt(indexToRemove);
        currentState.persons.insert(indexToRemove, updatedPerson);
        //await getDataFromApi();
        emit(PersonsInitial());
        emit(PersonsLoaded(
            persons: currentState.persons, orgUnits: currentState.orgUnits));
        log('Successfuly updated person');
        return true;
      } catch (error, stackTrace) {
        return false;
      }
    }
    return false;
  }

  Future<void> filterPersonsByOrgUnits(String requestFilters) async {
    final currentState = state;
    if (currentState is PersonsLoaded) {
      emit(PersonsLoading());
      try {
        final persons = await personsRepository.getPersonsByOrgUnitIdFilter(
          tenantId: tenant.id,
          requestFilters: requestFilters,
        );

        emit(PersonsLoaded(
          orgUnits: currentState.orgUnits,
          persons: persons,
        ));
      } catch (error, stackTrace) {
        print('Error $error');
        emit(PersonsError(error: error, stackTrace: stackTrace));
      }
    }
  }

  Future<void> importPersons(List<Map<String, String>> records) async {
    final currentState = state;

    // end here if not loaded
    if (currentState is! PersonsLoaded) return;

    try {
      emit(PersonsLoading());

      await Future.forEach(records, (Map<String, String> record) async {
        try {
          //

          var requestBody = record;
          requestBody['TenantId'] = tenant.id;

          /// requestBody['OrgUnitId'] contains the name not the id
          /// so u use the name to get the id
          var orgUnit = currentState.orgUnits.firstWhere((orgUnit) {
            return orgUnit.name!.isEqualIgnoreCase(requestBody['OrgUnitId']!);
          });

          requestBody['OrgUnitId'] = orgUnit.id.toString();
          requestBody['OrgUnitName'] = orgUnit.name ?? '';

          await personsRepository.postPerson(
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
