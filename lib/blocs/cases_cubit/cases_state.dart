import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/case.dart';

abstract class CasesState extends Equatable {
  const CasesState();

  @override
  List<Object?> get props => [];
}

class CasesInitial extends CasesState {}

class CaseSelected extends CasesState {
  final Case selectedCase;
  CaseSelected({required this.selectedCase});
}

class CasesLoading extends CasesState {}

class CasesLoaded extends CasesState {
  final List<Case> cases;
  CasesLoaded({required this.cases});

  @override
  List<Object?> get props => [cases];
}

class CaseByIdLoaded extends CasesState {
  final Case loadedCase;
  CaseByIdLoaded({required this.loadedCase});
}


class CasesError extends CasesState {
  final dynamic error;
  final StackTrace stackTrace;

  CasesError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}


