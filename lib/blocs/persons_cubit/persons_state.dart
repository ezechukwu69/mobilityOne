part of 'persons_cubit.dart';

abstract class PersonsState extends Equatable {
  const PersonsState();

  @override
  List<Object?> get props => [];
}

class PersonsInitial extends PersonsState {}

class PersonsSelected extends PersonsState {
  final Person person;
  PersonsSelected({required this.person});
}

class PersonsLoading extends PersonsState {}

class PersonsLoaded extends PersonsState {
  final List<Person> persons;
  final List<OrgUnit> orgUnits;
  PersonsLoaded({required this.persons, required this.orgUnits});

  @override
  List<Object?> get props => [persons, orgUnits];
}

class PersonsUpdated extends PersonsState {
  final List<Person> persons;
  final List<OrgUnit> orgUnits;
  PersonsUpdated({required this.persons, required this.orgUnits});

  @override
  List<Object?> get props => [persons, orgUnits];
}

class PersonsError extends PersonsState {
  final dynamic error;
  final StackTrace stackTrace;

  PersonsError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => [error, stackTrace];
}
