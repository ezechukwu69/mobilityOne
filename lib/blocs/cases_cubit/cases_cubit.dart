import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/cases_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';

import 'cases_state.dart';

class CasesCubit extends Cubit<CasesState> {
  CasesCubit({required this.tenantsRepository, required this.casesRepository}) : super(CasesInitial());

  final TenantsRepository tenantsRepository;
  final CasesRepository casesRepository;

  Tenant? tenant;

  Future<void> getDataFromApi() async {
    emit(CasesLoading());
    try {
      tenant = await tenantsRepository.getTenants().then((value) => value.first);
      log('Tenant: ${tenant!.id}');
      final cases = await casesRepository.getCases(tenantId: tenant!.id);

      emit(CasesLoaded(cases: cases));
    } catch (error, stackTrace) {
      emit(CasesError(error: error, stackTrace: stackTrace));
    }
  }

  Future<void> getCaseById(int caseId) async {
    try {
      emit(CasesLoading());
      tenant = await tenantsRepository.getTenants().then((value) => value.first);
      final _case = await casesRepository.getCase(tenantId: tenant!.id, caseId: caseId);
      emit(CaseByIdLoaded(loadedCase: _case));
    } catch(error, stackTrace) {
      print('error $error');
      emit(CasesError(error: error, stackTrace: stackTrace),);
    }
  }
}
