import 'package:equatable/equatable.dart';
import 'package:mobility_one/models/availability.dart';


class AvailabilitiesDropdownListState extends Equatable {
  final bool isExpanded;
  final Availability? selectedAvailability;
  final List<Availability> availableAvailabilities;

  AvailabilitiesDropdownListState(
      {required this.isExpanded, required this.selectedAvailability, required this.availableAvailabilities});

  AvailabilitiesDropdownListState copyWith({
    bool? isExpanded,
    Availability? selectedAvailability,
    List<Availability>? availableAvailabilities,
  }) {
    return AvailabilitiesDropdownListState(
        isExpanded: isExpanded ?? this.isExpanded,
        selectedAvailability: selectedAvailability ?? this.selectedAvailability,
        availableAvailabilities: availableAvailabilities ?? this.availableAvailabilities);
  }

  @override
  List<Object?> get props => [isExpanded, selectedAvailability, availableAvailabilities];
}
