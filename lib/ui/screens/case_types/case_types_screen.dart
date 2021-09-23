import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/cases_cubit/cases_state.dart';
import 'package:mobility_one/blocs/cases_type_cubit/cases_type_cubit.dart';
import 'package:mobility_one/blocs/cases_type_cubit/cases_type_state.dart';
import 'package:mobility_one/repositories/cases_type_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/ui/screens/case_types/widgets/case_types_data_table.dart';
import 'package:mobility_one/ui/screens/case_types/widgets/case_types_table_actions.dart';
import 'package:mobility_one/ui/widgets/m_one_container.dart';
import 'package:mobility_one/ui/widgets/m_one_error_widget.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';

class CaseTypesScreen extends StatelessWidget {
  const CaseTypesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CasesTypeCubit>(
      create: (context) => CasesTypeCubit(
        tenantsRepository: context.read<TenantsRepository>(),
        casesTypeRepository: context.read<CasesTypeRepository>()
      )..getDataFromApi(),
      child: BlocBuilder<CasesTypeCubit, CasesTypeState>(
        builder: (context, casesState) {
          if (casesState is CasesTypeLoaded) {
            return MOneContainer(children: [
              CaseTypesTableActions(selectedFilters: []),
              Divider(),
              CaseTypesDataTable(caseTypes: casesState.casesType,)
            ]);
          } else if (casesState is CasesTypeLoading) {
            return Center(child: MyCircularProgressIndicator(),);
          } else if (casesState is CasesTypeError) {
            return MOneErrorWidget();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
