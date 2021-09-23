import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:mobility_one/blocs/drawer_cubit/drawer_state.dart';
import 'package:mobility_one/models/dropdown_option.dart';
import 'package:mobility_one/ui/widgets/app_drawer.dart';
import 'package:mobility_one/ui/widgets/calendar_card.dart';
import 'package:mobility_one/ui/widgets/graph_card.dart';
import 'package:mobility_one/ui/widgets/kpi_card.dart';
import 'package:mobility_one/ui/widgets/list_kpi_cards.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/util.dart';

List<KPICard> kpiCards = [
  KPICard(
    kpiInfo: KPIInfo(title: 'Vehicles', value: '200', percentage: 12, daysInterval: 30),
  ),
  KPICard(
    kpiInfo: KPIInfo(title: 'Active Vehicles', value: '125', percentage: -5, daysInterval: 30),
  ),
  KPICard(
    kpiInfo: KPIInfo(title: 'On Service', value: '20', percentage: 12, daysInterval: 30),
  ),
  KPICard(
    kpiInfo: KPIInfo(title: 'Inactive vehicles', value: '33', percentage: 12, daysInterval: 30),
  ),
  KPICard(
    kpiInfo: KPIInfo(title: 'Expenses', value: '3450 EUR', percentage: 12, daysInterval: 30),
  ),
];



class DashboardItem {
  Widget widget;
  double? height;
  DashboardItem({required this.widget, this.height});
}

class DashboardScreen extends StatefulWidget {
  DashboardScreen();

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<DashboardItem> dashboardItems;

  @override
  void initState() {
    super.initState();
    _initializeDashboardItems();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= Util.smallScreenWidth) {
        if (!_calendarIsBeingShowed()) {
          dashboardItems.add(DashboardItem(
              widget: CalendarCard(
                title: 'Activities',
              ),
              height: 900));
        }
      } else {
        dashboardItems.removeWhere((element) => element.widget is CalendarCard);
      }
      return BlocBuilder<DrawerCubit, DrawerState>(builder: (context, drawerState) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: MyColors.backgroundColor,
            drawer: drawerState is NotPinnedDrawer
                ? AppDrawer(onDrawerOptionSelected: (item) {
                    Beamer.of(context).beamToNamed(item.route);
                  })
                : null,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 4,
                  child: ReorderableListView(
                      physics: BouncingScrollPhysics(),
                      buildDefaultDragHandles: false,
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          var item = dashboardItems.removeAt(oldIndex);
                          dashboardItems.insert(newIndex, item);
                        });
                      },
                      children: dashboardItems.map((item) {
                        return Container(
                          key: ValueKey(item),
                          padding: EdgeInsets.only(bottom: 50, left: 16),
                          height: item.height,
                          color: MyColors.backgroundColor,
                          child: ReorderableDragStartListener(
                            index: dashboardItems.indexOf(item),
                            child: Center(
                              child: item.widget,
                            ),
                          ),
                        );
                      }).toList()),
                ),
                constraints.maxWidth > Util.smallScreenWidth
                    ? Expanded(
                        flex: 1,
                        child: CalendarCard(
                          title: 'Activities',
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      });
    });
  }

  bool _calendarIsBeingShowed() {
    try {
      dashboardItems.firstWhere((element) => element.widget is CalendarCard);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _initializeDashboardItems() {
    dashboardItems = [
      DashboardItem(
          widget: ListKpiCards(
            kpiCards: kpiCards,
          ),
          height: 230),
      DashboardItem(
        widget: GraphCard(
          title: 'Analytics',
          chartType: GraphType.LINE,
          dropDownMenuOptions: [
            DropDownOption(label: 'Expenses 2021', value: 2021),
            DropDownOption(label: 'Expenses 2020', value: 2020),
            DropDownOption(label: 'Expenses 2019', value: 2019),
          ],
        ),
      ),
    ];
  }
}
