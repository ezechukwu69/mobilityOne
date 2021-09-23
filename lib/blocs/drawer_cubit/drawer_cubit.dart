import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/drawer_cubit/drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {

  bool isPinned = false;

  DrawerCubit() : super(NotPinnedDrawer());

  void pinDrawer() {
    isPinned = true;
    emit(PinnedDrawer());
  }
  void unPinDrawer() {
    isPinned = false;
    emit(NotPinnedDrawer());
  }
}