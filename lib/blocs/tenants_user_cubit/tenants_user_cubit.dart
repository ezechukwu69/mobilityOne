import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tenants_user_state.dart';

class TenantsUserCubit extends Cubit<TenantsUserState> {
  TenantsUserCubit() : super(TenantsUserInitial());
}
