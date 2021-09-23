import 'package:equatable/equatable.dart';

abstract class DrawerState extends Equatable {

}

class PinnedDrawer extends DrawerState {
  @override
  List<Object?> get props => [];
}

class NotPinnedDrawer extends DrawerState {
  @override
  List<Object?> get props => [];
}