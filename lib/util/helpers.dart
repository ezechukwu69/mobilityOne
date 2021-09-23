import 'package:mobility_one/util/constants.dart';

/// selectedFilters should be List<Filter>
String generateFiltersString(dynamic selectedFilters) {
  var filters = '';

  selectedFilters.forEach((filter) {
    //
    filters += 'Filter=${filter.filterName}$kEncodedEqualSign${filter.value}&';
  });

  return filters;
}
