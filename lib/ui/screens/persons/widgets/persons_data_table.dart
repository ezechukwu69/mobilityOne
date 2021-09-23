import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/persons_cubit/persons_cubit.dart';
import 'package:mobility_one/models/person.dart';
import 'package:mobility_one/ui/dialogs/person_dialog.dart';
import 'package:mobility_one/ui/widgets/m_one_data_table.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/util.dart';

class PersonsDataTable extends StatefulWidget {
  const PersonsDataTable({Key? key, this.persons = const []}) : super(key: key);

  final List<Person> persons;

  @override
  _PersonsDataTableState createState() => _PersonsDataTableState();
}

class _PersonsDataTableState extends State<PersonsDataTable> {
  final List<String> columns = const [
    'First Name',
    'Second Name',
    'Email',
    'Org. Unit',
  ];

  List<DataRow> _getRows() {
    return widget.persons.map((person) {
      final cells = _getRowCells(person: person);

      return DataRow(cells: cells);
    }).toList();
  }

  List<DataCell> _getRowCells({required Person person}) {
    // ignore: omit_local_variable_types
    List cellValues = [
      person.firstName,
      person.lastName,
      person.email,
      person.orgUnit,
    ];

    return cellValues.map((value) {
      return DataCell(Text('$value'), onTap: () async {
        await Util.showMyDialog(
          barrierDismissible: false,
          barrierColorTransparent: false,
          context: context,
          child: BlocProvider.value(
            value: context.read<PersonsCubit>(),
            child: PersonDialog(
              personToBeUpdated: person,
              action: PersonAction.update,
            ),
          ),
        );
      });
    }).toList();
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.persons.sort((person1, person2) =>
          compareString(ascending, person1.firstName!, person2.firstName!));
    } else if (columnIndex == 1) {
      widget.persons.sort((person1, person2) =>
          compareString(ascending, person1.lastName!, person2.lastName!));
    } else if (columnIndex == 2) {
      widget.persons.sort((person1, person2) =>
          compareString(ascending, person1.email!, person2.email!));
    } else if (columnIndex == 3) {
      widget.persons.sort((person1, person2) => compareString(
          ascending, person1.orgUnit!.name!, person2.orgUnit!.name!));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MOneDataTable(
      columns: columns,
      rows: _getRows(),
      onSort: onSort,
    );
  }
}
