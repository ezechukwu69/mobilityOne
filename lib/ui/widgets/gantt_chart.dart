import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobility_one/models/case.dart';
import 'package:mobility_one/models/mileage_report.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class Assignment<T> {
  final dynamic id;
  final String operatorName;
  final String itemId;
  final DateTime startDate;
  final DateTime endDate;

  Assignment({this.id, required this.operatorName, required this.startDate, required this.endDate, required this.itemId});
}

class GanttCell extends Equatable {
  final int row;
  final int column;

  GanttCell(this.row, this.column);
  @override
  List<Object?> get props => [row, column];
}

class GanttFilter extends Equatable {
  final String label;
  final dynamic value;
  final String filterName;
  bool isSelected;

  GanttFilter({required this.label, required this.value, required this.isSelected, required this.filterName});

  @override
  List<Object?> get props => [label, value];
}

class GanttFilterGroup {
  final String groupName;
  final List<GanttFilter> filters;
  GanttFilterGroup({required this.groupName, required this.filters});
}

class GanttChart<T> extends StatefulWidget {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<T> items;
  final List<Assignment> assignments;
  final List<Case>? cases;
  final List<MileageReport>? mileages;
  final List<GanttFilterGroup>? filterGroups;
  final int? pageSkip;

  final Function(T) cardBuilder;
  final Function(DateTime, DateTime, T)? onDaysSelected;
  final Function(DateTime, DateTime) onDateChanged;
  final Function(Assignment)? onSelectAssignment;
  final Function(Case)? onSelectCase;
  final Function(MileageReport)? onSelectMileageReport;
  final Function(GanttFilter)? onFilterSelect;
  final Function()? onFilterConfirmed;

  GanttChart({required this.title, required this.startDate, required this.endDate, required this.items, required this.assignments, required this.cardBuilder, this.onDaysSelected, required this.onDateChanged, this.onSelectAssignment, this.filterGroups, this.onFilterSelect, this.onFilterConfirmed, this.pageSkip = 7, this.cases, this.onSelectCase, this.mileages, this.onSelectMileageReport});

  @override
  _GanttChartState<T> createState() => _GanttChartState<T>();
}

class _GanttChartState<T> extends State<GanttChart<T>> {
  final double itemCardHeight = 120;
  final double titleHeight = 120;

  late double cellWidth;

  late int numberOfDays;

  bool isSelectingCells = false;
  late double itemListContainerWidth;
  final List<GanttCell> _selectedCells = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      numberOfDays = widget.endDate.difference(widget.startDate).inDays;
      itemListContainerWidth = constraints.maxWidth * 0.16;
      cellWidth = (constraints.maxWidth - itemListContainerWidth) / numberOfDays - (20 / numberOfDays);

      return SingleChildScrollView(
        child: Container(
          height: widget.items.length * itemCardHeight + titleHeight,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: MyColors.backgroundCardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildItemList(context, constraints.maxHeight, constraints.maxWidth),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGanttHeader(context, constraints.maxHeight, constraints.maxWidth),
                    _buildGanttBody(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Container _buildItemList(BuildContext context, double maxHeight, double maxWidth) {
    return Container(
      width: itemListContainerWidth,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(4, 0))],
        color: MyColors.backgroundCardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.all(16.0),
            child: FittedBox(
              child: Text(
                widget.title,
                style: TextStyle(color: MyColors.cardTextColor, fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF15151F),
              ),
              child: Column(
                children: widget.items
                    .map(
                      (item) => Container(
                        height: itemCardHeight,
                        decoration: BoxDecoration(
                          color: MyColors.backgroundCardColor,
                        ),
                        child: widget.cardBuilder(item),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGanttHeader(BuildContext context, double maxHeight, double maxWidth) {
    return Container(
      height: titleHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF585876), width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        DateFormat('MMM').format(widget.startDate),
                        style: TextStyle(color: MyColors.cardTextColor, fontSize: 26),
                      ),
                    ),
                  ),
                  if (widget.filterGroups != null) _buildFilterButton()
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: MyColors.accentColor,
                  ),
                  onPressed: () {
                    widget.onDateChanged(widget.startDate.add(Duration(days: widget.pageSkip! * -1)), widget.endDate.add(Duration(days: widget.pageSkip! * -1)));
                  },
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      numberOfDays,
                      (index) => Text(
                        '${DateFormat('EE d').format(
                          widget.startDate.add(
                            Duration(days: index),
                          ),
                        )}',
                        style: TextStyle(color: MyColors.cardTextColor),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_right,
                    color: MyColors.accentColor,
                  ),
                  onPressed: () {
                    widget.onDateChanged(widget.startDate.add(Duration(days: widget.pageSkip!)), widget.endDate.add(Duration(days: widget.pageSkip!)));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGanttBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: List.generate(
            widget.items.length,
            (indexRow) => Row(
                children: List.generate(
              numberOfDays,
              (indexColumn) => MouseRegion(
                cursor: isSelectingCells ? SystemMouseCursors.click : SystemMouseCursors.basic,
                onHover: (hover) {
                  _selectOrUnSelectCell(indexRow, indexColumn);
                },
                child: GestureDetector(
                  onTap: () {
                    if (isSelectingCells) {
                      if (widget.onDaysSelected != null) {
                        widget.onDaysSelected!(widget.startDate.add(Duration(days: _selectedCells.first.column)), widget.startDate.add(Duration(days: _selectedCells.last.column)), widget.items[_selectedCells.first.row]);
                      }
                      _clearSelection();
                      isSelectingCells = false;
                    }
                  },
                  onDoubleTap: () {
                    setState(() {
                      _clearSelection();
                      isSelectingCells = true;
                    });
                    _selectOrUnSelectCell(indexRow, indexColumn);
                  },
                  child: Container(
                    height: itemCardHeight,
                    width: cellWidth,
                    decoration: BoxDecoration(
                      color: _selectedCells.contains(GanttCell(indexRow, indexColumn))
                          ? Colors.blueGrey
                          : indexRow.isOdd
                              ? Color(0xFF15151F).withOpacity(0.4)
                              : null,
                      border: Border(right: BorderSide(color: Color(0xFF585876), width: 0.1), bottom: BorderSide(color: Color(0xFF585876), width: 0.1)),
                    ),
                    child: Container(),
                  ),
                ),
              ),
            )),
          ),
        ),
        ..._buildAssignmentCards(),
        ..._buildCasesCards(),
        ..._buildMileageReportDots(),
      ],
    );
  }

  Widget _buildFilterButton() {
    return IconButton(
      onPressed: _showSideSheet,
      icon: Icon(
        Icons.filter_list,
        color: MyColors.cardTextColor,
      ),
    );
  }

  void _showSideSheet() {
    showGeneralDialog(
      barrierLabel: 'Barrier',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            child: Container(
              height: double.infinity,
              width: 300,
              decoration: BoxDecoration(
                color: MyColors.backgroundCardColor,
              ),
              child: _buildFilterGroups(),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(animation1),
          child: child,
        );
      },
    );
  }

  Widget _buildFilterGroups() {
    return StatefulBuilder(
      builder: (context, _state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.filterGroups!.map(
                  (e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.groupName,
                        style: MyTextStyles.dataTableHeading,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: e.filters
                            .map(
                              (e) => FilterChip(
                                  backgroundColor: MyColors.mobilityOneBlackColor,
                                  side: BorderSide(color: MyColors.mobilityOneBlackColor),
                                  selected: e.isSelected,
                                  selectedColor: MyColors.accentColor,
                                  label: Text(
                                    e.label,
                                    style: MyTextStyles.dataTableText,
                                  ),
                                  onSelected: (selected) {
                                    _state(() {
                                      e.isSelected = selected;
                                      widget.onFilterSelect!(e);
                                    });
                                  }),
                            )
                            .toList(),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ConfirmButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onFilterConfirmed!();
                    },
                    title: MyLocalization.of(context)!.filterLabel.toUpperCase(),
                  ),
                )
              ].toList(),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAssignmentCards() {
    var calculateVerticalPosition = (Assignment assignment) {
      return widget.items.indexWhere((item) => assignment.itemId == (item as dynamic).id) * itemCardHeight + itemCardHeight * 0.1;
    };

    var calculateHorizontalPosition = (Assignment assignment) {
      return (assignment.startDate.day - widget.startDate.day) * cellWidth + ((assignment.startDate.hour == 0 ? 24 : assignment.startDate.hour) * (cellWidth / 24));
    };

    var calculateNumberOfAssignmentDays = (Assignment assignment) {
      return assignment.endDate.difference(assignment.startDate).inDays + 1;
    };

    var calculateWidth = (Assignment assignment) {
      return cellWidth * calculateNumberOfAssignmentDays(assignment) - (assignment.startDate.hour * (cellWidth / 24)) - ((24 - (assignment.endDate.hour == 0 ? 24 : assignment.endDate.hour)) * (cellWidth / 24));
    };

    return List.generate(widget.assignments.length, (index) {
      final assignment = widget.assignments[index];
      if (assignment.startDate.isAfter(widget.endDate) || assignment.endDate.isBefore(widget.startDate)) {
        return Container();
      }

      return Positioned(
        left: calculateHorizontalPosition(assignment),
        top: calculateVerticalPosition(assignment),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (widget.onSelectAssignment != null) {
                widget.onSelectAssignment!(assignment);
              }
            },
            child: Container(
              height: itemCardHeight - 20,
              width: calculateWidth(assignment),
              decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: MyColors.accentColor, width: 4))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FittedBox(
                          child: Text(
                            assignment.operatorName.isNotEmpty ? assignment.operatorName : 'Operator Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    FittedBox(
                        child: Text(
                      '${DateFormat('MMM d, y H:m').format(assignment.startDate)} - ${DateFormat('MMM d, y H:m').format(assignment.endDate)}',
                      style: TextStyle(fontSize: 12),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildCasesCards() {
    var calculateVerticalPosition = (Case _case) {
      return widget.items.indexWhere((item) => _case.vehicleId == (item as dynamic).id) * itemCardHeight + itemCardHeight * 0.17;
    };

    var calculateHorizontalPosition = (Case _case) {
      return (_case.startTime.day - widget.startDate.day) * cellWidth + ((_case.startTime.hour == 0 ? 24 : _case.startTime.hour) * (cellWidth / 24));
    };

    var calculateNumberOfCaseDays = (Case _case) {
      return _case.endTime.difference(_case.startTime).inDays + 1;
    };

    var calculateWidth = (Case _case) {
      return cellWidth * calculateNumberOfCaseDays(_case) - (_case.startTime.hour * (cellWidth / 24)) - ((24 - (_case.endTime.hour == 0 ? 24 : _case.endTime.hour)) * (cellWidth / 24));
    };

    if (widget.cases == null) {
      return [];
    }
    return List.generate(
      widget.cases!.length,
      (index) {
        final _case = widget.cases![index];
        if (_case.startTime.isAfter(widget.endDate) || _case.endTime.isBefore(widget.startDate)) {
          return Container();
        }

        return Positioned(
          left: calculateHorizontalPosition(_case),
          top: calculateVerticalPosition(_case),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if (widget.onSelectCase != null) {
                  widget.onSelectCase!(_case);
                }
              },
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  height: itemCardHeight - 40,
                  width: calculateWidth(_case) < 120 ? 120 : calculateWidth(_case),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFFe4572e), width: 4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FittedBox(
                              child: Text(
                                _case.name ?? 'Case name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        FittedBox(
                          child: Text(_case.comment ?? ''),
                        ),
                        Spacer(),
                        FittedBox(
                            child: Text(
                          '${DateFormat('MMM d, y H:m').format(_case.startTime)} - ${DateFormat('MMM d, y H:m').format(_case.endTime)}',
                          style: TextStyle(fontSize: 12),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildMileageReportDots() {

    final dotHeight = 15.0;
    final dotWidth = 20.0;

    var calculateVerticalPosition = (MileageReport mileage) {
      return widget.items.indexWhere((item) => mileage.vehicleId == (item as dynamic).id) * itemCardHeight;
    };

    var calculateHorizontalPosition = (MileageReport mileage) {
      return (mileage.time.day - widget.startDate.day) * cellWidth + ((mileage.time.hour == 0 ? 24 : mileage.time.hour) * (cellWidth / 24));
    };

    if (widget.mileages == null) {
      return [];
    }

    return List.generate(
      widget.mileages!.length,
      (index) {
        final mileage = widget.mileages![index];

        if (mileage.time.isAfter(widget.endDate) || mileage.time.isBefore(widget.startDate)) {
          return Container();
        }

        return Positioned(
          left: calculateHorizontalPosition(mileage),
          top: calculateVerticalPosition(mileage),
          child: Tooltip(
            message: '${mileage.value} ${mileage.measuringUnit}',
            child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if (widget.onSelectMileageReport != null) {
                  widget.onSelectMileageReport!(mileage);
                }
              },
              child: Container(
                height: dotHeight,
                width: dotWidth,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent
                ),
              ),
            ),
        ),
          ),);
      },
    );
  }

  void _selectOrUnSelectCell(int row, int column) {
    if (isSelectingCells) {
      final newCell = GanttCell(row, column);
      if (!_selectedCells.contains(newCell) && _isSameRow(row)) {
        if (_selectedCells.isNotEmpty && newCell.column < _selectedCells.last.column) {
          _selectedCells.removeLast();
        }

        if (_selectedCells.isNotEmpty && newCell.column - _selectedCells.last.column > 1) {
          for (var i = _selectedCells.last.column + 1; i < newCell.column; i++) {
            _selectedCells.add(GanttCell(row, i));
          }
        }
        _selectedCells.add(newCell);
        setState(() {});
      } else {
        if (newCell.column < _selectedCells.last.column) {
          setState(() {
            _selectedCells.removeLast();
            if (_selectedCells.isEmpty) {
              _selectedCells.add(newCell);
            }
          });
        }
      }
    }
  }

  bool _isSameRow(int row) {
    if (_selectedCells.isNotEmpty) {
      return _selectedCells[0].row == row;
    }
    return true;
  }

  void _clearSelection() {
    setState(() {
      _selectedCells.clear();
    });
  }
}
