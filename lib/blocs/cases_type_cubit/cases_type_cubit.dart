import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:mobility_one/models/case_type.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/cases_type_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'cases_type_state.dart';

class CasesTypeCubit extends Cubit<CasesTypeState> {
  CasesTypeCubit({required this.tenantsRepository, required this.casesTypeRepository}) : super(CasesTypeInitial());

  final TenantsRepository tenantsRepository;
  final CasesTypeRepository casesTypeRepository;
  CaseType selectedCaseType = CaseType(id: 0, name: '', tenantId: '', causesAvailabilityId: 0, causesAvailability: '');

  late Tenant? tenant;

  Future<void> getDataFromApi() async {
    emit(CasesTypeLoading());
    try {
      tenant = await tenantsRepository.getTenants().then((value) => value.first);
      log('Tenant: ${tenant!.id}');
      print('Tenant: ${tenant!.id}');
      final casesType = await casesTypeRepository.getCaseTypes(tenantId: tenant!.id);

      emit(CasesTypeLoaded(casesType: casesType));
    } catch (error, stackTrace) {
      print('Error $error');
      emit(CasesTypeError(error: error, stackTrace: stackTrace));
    }
  }

  void selectCaseType({required CaseType caseType}) {
    selectedCaseType = caseType;
    emit(CasesTypeSelected(selectedCaseType: caseType));
  }

  Future<void> createCaseType({required String name}) async {
    try {
      final currentState = state;
      if (currentState is CasesTypeLoaded) {
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        emit(CasesTypeLoading());
        final newCaseType = CaseType(id: 0, name: name, tenantId: tenant!.id);
        await casesTypeRepository.postCaseType(tenantId: tenant!.id, requestBody: newCaseType.toJson());
        await getDataFromApi();
      }
    } catch (error, stackTrace) {
      print('Error $error');
      emit(CasesTypeError(error: error, stackTrace: stackTrace));
    }
  }

  Future<void> updateCaseType({required CaseType updatedCaseType}) async {
    try {
      final currentState = state;
      if (currentState is CasesTypeLoaded) {
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        emit(CasesTypeLoading());
        await casesTypeRepository.putCaseType(tenantId: tenant!.id, caseTypeId: updatedCaseType.id, requestBody: updatedCaseType.toJson());
        await getDataFromApi();
      }
    } catch (error, stackTrace) {
      print('Error $error');
      emit(CasesTypeError(error: error, stackTrace: stackTrace));
    }
  }

  Future<void> deleteCaseType(int caseTypeId) async {
    try {
      final currentState = state;
      if (currentState is CasesTypeLoaded) {
        tenant ??= await tenantsRepository.getTenants().then((value) => value.first);
        emit(CasesTypeLoading());
        await casesTypeRepository.deleteCaseType(tenantId: tenant!.id, caseTypeId: caseTypeId);
        await getDataFromApi();
      }
    } catch (error, stackTrace) {
      print('Error $error');
      emit(CasesTypeError(error: error, stackTrace: stackTrace));
    }
  }
}
