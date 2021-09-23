import 'package:bloc/bloc.dart';
import 'package:mobility_one/blocs/teams_cubit/teams_state.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/teams_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit({required this.tenantsRepository, required this.teamsRepository})
      : super(TeamsInitial());

  final TenantsRepository tenantsRepository;
  final TeamsRepository teamsRepository;

  late Tenant tenant;

  Future<void> getDataFromApi() async {
    emit(TeamsLoading());
    try {
      tenant =
      await tenantsRepository.getTenants().then((value) => value.first);
      final teams = await teamsRepository.getTeams(tenantId: tenant.id);

      emit(TeamsLoaded(teams: teams));
    } catch (error, stackTrace) {
      emit(TeamsError(error: error, stackTrace: stackTrace));
    }
  }
}
