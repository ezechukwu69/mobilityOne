import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/general_status.dart';


class GeneralStatusesDropdownListState extends Equatable {
  final bool isExpanded;
  final GeneralStatus? selectedGeneralStatus;
  final List<GeneralStatus> availableGeneralStatuses;

  GeneralStatusesDropdownListState(
      {required this.isExpanded, required this.selectedGeneralStatus, required this.availableGeneralStatuses});

  GeneralStatusesDropdownListState copyWith({
    bool? isExpanded,
    GeneralStatus? selectedGeneralStatus,
    List<GeneralStatus>? availableGeneralStatuses,
  }) {
    return GeneralStatusesDropdownListState(
        isExpanded: isExpanded ?? this.isExpanded,
        selectedGeneralStatus: selectedGeneralStatus ?? this.selectedGeneralStatus,
        availableGeneralStatuses: availableGeneralStatuses ?? this.availableGeneralStatuses);
  }

  @override
  List<Object?> get props => [isExpanded, selectedGeneralStatus, availableGeneralStatuses];
}
