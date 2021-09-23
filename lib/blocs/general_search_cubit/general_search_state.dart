import 'package:equatable/equatable.dart';

abstract class GeneralSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GeneralSearchInit extends GeneralSearchState {}

class GeneralSearchLoading extends GeneralSearchState {}

class GeneralSearchLoaded extends GeneralSearchState {
  final List<dynamic> items;

  GeneralSearchLoaded({required this.items});
}

class GeneralSearchChangedPlaceholder extends GeneralSearchState {
  final String placeholder;
  GeneralSearchChangedPlaceholder({required this.placeholder});
}

class GeneralSearchMakeSearch extends GeneralSearchState {
  final String searchText;
  GeneralSearchMakeSearch({required this.searchText});
}

class GeneralSearchExecuted extends GeneralSearchState {
  GeneralSearchExecuted();
}