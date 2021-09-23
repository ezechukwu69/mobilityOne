import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/cases_type_cubit/cases_type_cubit.dart';
import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/models/case_type.dart';
import 'package:mobility_one/ui/dialogs/case_type_dialog.dart';
import 'package:mobility_one/ui/widgets/m_one_data_table.dart';
import 'package:mobility_one/util/util.dart';

class CaseTypesDataTable extends StatefulWidget {
  const CaseTypesDataTable({Key? key, this.caseTypes = const []}) : super(key: key);

  final List<CaseType> caseTypes;

  @override
  _CaseTypesDataTableState createState() => _CaseTypesDataTableState();
}

class _CaseTypesDataTableState extends State<CaseTypesDataTable> {
  final List<String> columns = const [
    'Name',
  ];

  List<DataRow> _getRows() {
    return widget.caseTypes.map((caseType) {
      final cells = _getRowCells(caseType: caseType);

      return DataRow(cells: cells);
    }).toList();
  }

  List<DataCell> _getRowCells({required CaseType caseType}) {
    // ignore: omit_local_variable_types
    List cellValues = [
      caseType.name,
    ];

    return cellValues.map((value) {
      return DataCell(Text('$value'), onTap: () async {
        await Util.showMyDialog(
          barrierDismissible: false,
          barrierColorTransparent: false,
          context: context,
          child: BlocProvider.value(
            value: context.read<CasesTypeCubit>(),
            child: CaseTypeDialog(action: CaseTypeDialogAction.update, caseTypeToBeUpdated: caseType,),
          ),
        );
      });
    }).toList();
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.caseTypes.sort((caseType1, caseType2) =>
          compareString(ascending, caseType1.name, caseType2.name));
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