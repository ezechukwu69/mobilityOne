import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/persons_cubit/persons_cubit.dart';
import 'package:mobility_one/repositories/accounts_repository.dart';
import 'package:mobility_one/repositories/org_units_repository.dart';
import 'package:mobility_one/repositories/persons_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/ui/screens/persons/widgets/persons_data_table.dart';
import 'package:mobility_one/ui/screens/persons/widgets/persons_table_actions.dart';
import 'package:mobility_one/ui/widgets/m_one_container.dart';
import 'package:mobility_one/ui/widgets/m_one_error_widget.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/util/filter_group.dart';

class PersonsScreen extends StatelessWidget {
  const PersonsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    List<Filter> selectedFilters = [];

    return BlocProvider<PersonsCubit>(
      create: (context) => PersonsCubit(
        personsRepository: context.read<PersonsRepository>(),
        tenantsRepository: context.read<TenantsRepository>(),
        orgUnitsRepository: context.read<OrgUnitsRepository>(),
        accountsRepository: context.read<AccountsRepository>(),
      )..getDataFromApi(),
      child: BlocBuilder<PersonsCubit, PersonsState>(
        builder: (context, state) {
          if (state is PersonsLoaded) {
            return MOneContainer(
              children: [
                PersonsTableActions(selectedFilters: selectedFilters),
                Divider(),
                Flexible(
                  child: PersonsDataTable(
                    persons: [...state.persons],
                  ),
                )
              ],
            );
          } else if (state is PersonsLoading) {
            return Center(child: MyCircularProgressIndicator());
          } else if (state is PersonsError) {
            return MOneErrorWidget();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
