import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/case_type.dart';

abstract class CasesTypeState extends Equatable {
  const CasesTypeState();

  @override
  List<Object?> get props => [];
}

class CasesTypeInitial extends CasesTypeState {}

class CaseTypeSelected extends CasesTypeState {
  final CaseType caseType;
  CaseTypeSelected({required this.caseType});
}

class CasesTypeLoading extends CasesTypeState {}

class CasesTypeLoaded extends CasesTypeState {
  final List<CaseType> casesType;
  CasesTypeLoaded({required this.casesType});

  @override
  List<Object?> get props => [casesType];
}

class CasesTypeSelected extends CasesTypeState {
  final CaseType selectedCaseType;

  CasesTypeSelected({required this.selectedCaseType});
}

class CasesTypeError extends CasesTypeState {
  final dynamic error;
  final StackTrace stackTrace;

  CasesTypeError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}

