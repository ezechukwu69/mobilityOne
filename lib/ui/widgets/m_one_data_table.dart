import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';

int compareString(bool ascending, String value1, String value2) {
  return ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}

class MOneDataTable extends StatefulWidget {
  const MOneDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.onSort,
  }) : super(key: key);

  final List<String> columns;
  final List<DataRow> rows;

  /// for now:  [onSort] implementaion needs to call setState at the end
  final void Function(int, bool)? onSort;

  @override
  _MOneDataTableState createState() => _MOneDataTableState();
}

class _MOneDataTableState extends State<MOneDataTable> {
  //
  int? sortColumnIndex = 0;
  bool isAscending = true;

  //
  List<DataColumn> _getColumns() {
    return widget.columns.map((String column) {
      return DataColumn(
        label: Text('$column'),
        onSort: (columnIndex, sortAccending) {
          sortColumnIndex = columnIndex;
          isAscending = sortAccending;

          widget.onSort!(columnIndex, sortAccending);

          // setState(() {});
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(color: MyColors.accentColor),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      sortAscending: isAscending,
                      sortColumnIndex: sortColumnIndex,
                      columns: _getColumns(),
                      rows: widget.rows,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
