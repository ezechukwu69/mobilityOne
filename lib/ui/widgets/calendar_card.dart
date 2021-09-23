import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobility_one/models/calendar_activity.dart';
import 'package:mobility_one/ui/widgets/calendar_activity_card.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatefulWidget {
  final String title;

  CalendarCard({required this.title});

  @override
  _CalendarCardState createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  List<CalendarActivity> activities = [
    CalendarActivity(status: ActivityStatus.SCHEDULED, dateTime: DateTime.now(), description: 'Service maintenance on the vehicle'),
    CalendarActivity(status: ActivityStatus.ONGOING, dateTime: DateTime.now(), description: 'Type change on the vehicle ID 2245'),
    CalendarActivity(status: ActivityStatus.OVERDUE, dateTime: DateTime.now(), description: 'Insurance meeting'),
    CalendarActivity(status: ActivityStatus.TASK, dateTime: DateTime.now(), description: 'Get paperwork checked by insurance'),
  ];

  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;

  Map<ActivityStatus, bool> activitiesFilter = {ActivityStatus.SCHEDULED: true, ActivityStatus.ONGOING: true, ActivityStatus.OVERDUE: true, ActivityStatus.TASK: true};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF15151F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 33),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'You have ${activities.length} activities',
                        style: TextStyle(color: MyColors.cardTextColor, fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  _buildTableCalendar(),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: MyColors.accentColor, width: 1),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text('View Calendar'.toUpperCase(), style: TextStyle(color: MyColors.cardTextColor, fontSize: 10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildDropdownActivityFilter(),
            ...List.generate(
                activities.length,
                (index) => CalendarActivityCard(
                  activityInfo: activities[index],
                ),
              ),
          ],
        ),
      ),
    );
  }

  TableCalendar _buildTableCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle(color: MyColors.cardTextColor),
        formatButtonDecoration: BoxDecoration(
          border: Border.all(color: MyColors.cardTextColor),
          borderRadius: BorderRadius.circular(30),
        ),
        leftChevronIcon: Icon(
          Icons.keyboard_arrow_left,
          color: MyColors.cardTextColor,
        ),
        rightChevronIcon: Icon(
          Icons.keyboard_arrow_right,
          color: MyColors.cardTextColor,
        ),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay; // update `_focusedDay` here as well
        });
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          final text = DateFormat.E().format(day);
          return Center(
            child: Text(
              text,
              style: TextStyle(color: MyColors.cardTextColor),
            ),
          );
        },
        defaultBuilder: (context, day, _) {
          final text = day.day.toString();
          final color = day.weekday == DateTime.sunday ? MyColors.dangerColor : MyColors.cardTextColor;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(color: color, fontSize: 12),
                ),
                _buildCalendarEventDotsAlertFor(day)
              ],
            ),
          );
        },
        todayBuilder: (context, day, _) {
          final text = day.day.toString();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: Color(0xFF585876), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              _buildCalendarEventDotsAlertFor(day)
            ],
          );
        },
        headerTitleBuilder: (context, day) {
          final text = months[day.month - 1];
          return FittedBox(
            fit: BoxFit.contain,
            child: Text(
              text,
              style: TextStyle(color: MyColors.cardTextColor,),
              maxLines: 1,
            ),
          );
        },
        outsideBuilder: (context, day, _) {
          final text = day.day.toString();
          final color = day.weekday == DateTime.sunday ? Color(0xFF984D64) : Color(0xFF585876);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarEventDotsAlertFor(DateTime date) {
    var count = activities.where((element) => element.dateTime.day == date.day && element.dateTime.month == date.month && element.dateTime.year == date.year).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count.length,
        (index) => Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: MyColors.accentColor, shape: BoxShape.circle),
        ),
      ),
    );
  }

  Widget _buildDropdownActivityFilter() {
    final textStyle = TextStyle(color: MyColors.cardTextColor, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            'Filter Activities',
            style: textStyle,
          ),
          Theme(
            data: Theme.of(context).copyWith(disabledColor: Colors.white, unselectedWidgetColor: MyColors.cardTextColor),
            child: PopupMenuButton(
                icon: Icon(
                  Icons.sort,
                  color: MyColors.cardTextColor,
                ),
                color: MyColors.backgroundColor,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: StatefulBuilder(builder: (_context, _setState) {
                        return CheckboxListTile(
                          activeColor: MyColors.accentColor,
                          title: Text(
                            'Scheduled',
                            style: textStyle,
                          ),
                          onChanged: (value) {
                            _setState(
                              () {
                                activitiesFilter[ActivityStatus.SCHEDULED] = value!;
                              },
                            );
                          },
                          value: activitiesFilter[ActivityStatus.SCHEDULED],
                        );
                      }),
                    ),
                    PopupMenuItem(
                      child: StatefulBuilder(builder: (_context, _setState) {
                        return CheckboxListTile(
                          activeColor: MyColors.accentColor,
                          title: Text(
                            'On Going',
                            style: textStyle,
                          ),
                          onChanged: (value) {
                            _setState(() {
                              activitiesFilter[ActivityStatus.ONGOING] = value!;
                            });
                          },
                          value: activitiesFilter[ActivityStatus.ONGOING],
                        );
                      }),
                    ),
                    PopupMenuItem(
                      child: StatefulBuilder(builder: (_context, _setState) {
                        return CheckboxListTile(
                          activeColor: MyColors.accentColor,
                          title: Text(
                            'Overdue',
                            style: textStyle,
                          ),
                          onChanged: (value) {
                            _setState(() {
                              activitiesFilter[ActivityStatus.OVERDUE] = value!;
                            });
                          },
                          value: activitiesFilter[ActivityStatus.OVERDUE],
                        );
                      }),
                    ),
                    PopupMenuItem(
                      child: StatefulBuilder(builder: (_context, _setState) {
                        return CheckboxListTile(
                          activeColor: MyColors.accentColor,
                          title: Text(
                            'Task',
                            style: textStyle,
                          ),
                          onChanged: (value) {
                            _setState(() {
                              activitiesFilter[ActivityStatus.TASK] = value!;
                            });
                          },
                          value: activitiesFilter[ActivityStatus.TASK],
                        );
                      }),
                    ),
                  ];
                }),
          ),
        ],
      ),
    );
  }
}
