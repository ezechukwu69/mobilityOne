import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_state.dart';
import 'package:mobility_one/util/app_routes.dart';
import 'package:mobility_one/util/my_localization.dart';


class GeneralSearchCubit extends Cubit<GeneralSearchState> {
  late BuildContext context;
  late String currentPath;
  GeneralSearchCubit({required this.context}) : super(GeneralSearchInit()) {
    currentPath = Beamer.of(context).state.uri.path;
    var newSearchFieldPlaceholder = '';
    switch(currentPath) {
      case AppRoutes.home:
        newSearchFieldPlaceholder = MyLocalization.of(context)!.searchFieldDashboardLabel;
        break;
      case AppRoutes.hierarchy:
        newSearchFieldPlaceholder = MyLocalization.of(context)!.searchFieldHierarchyLabel;
        break;
      case AppRoutes.persons:
        newSearchFieldPlaceholder = MyLocalization.of(context)!.searchFieldPersonsLabel;
        break;
      case AppRoutes.pools:
        newSearchFieldPlaceholder = MyLocalization.of(context)!.searchFieldPoolsLabel;
        break;
      case AppRoutes.vehicles:
        newSearchFieldPlaceholder = MyLocalization.of(context)!.searchFieldVehiclesLabel;
        break;
      case AppRoutes.vehicle_types:
        newSearchFieldPlaceholder = MyLocalization.of(context)!.searchFieldVehicleTypesLabel;
        break;
      case AppRoutes.vehicles_list:
        newSearchFieldPlaceholder = MyLocalization.of(context)!.searchFieldVehicleListLabel;
        break;
      case AppRoutes.vehicle_status:
        newSearchFieldPlaceholder = MyLocalization.of(context)!.searchFieldVehicleListLabel;
        break;
      default:
        break;
    }
    emit(GeneralSearchChangedPlaceholder(placeholder: newSearchFieldPlaceholder));
  }

  void notifySearch(String searchText) {
    emit(GeneralSearchMakeSearch(searchText: searchText));
  }

  void searchExecuted() {
    emit(GeneralSearchExecuted());
  }
}