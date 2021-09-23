import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/role.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/roles_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';

part 'roles_state.dart';

class RolesCubit extends Cubit<RolesState> {
  RolesCubit({required this.tenantsRepository, required this.rolesRepository})
      : super(RolesInitial());

  final TenantsRepository tenantsRepository;
  final RolesRepository rolesRepository;

  late Tenant tenant;

  Future<void> getRoles() async {
    emit(RolesLoading());
    try {
      tenant =
          await tenantsRepository.getTenants().then((value) => value.first);
      final roles =await rolesRepository.getRoles(tenantId: tenant.id);
      
      emit(RolesLoaded(roles: roles));
    } catch (error, stackTrace) {
      emit(RolesError(error: error, stackTrace: stackTrace));
    }
  }
}
