import 'package:flutter/material.dart';
import 'package:mobility_one/models/calendar_activity.dart';
import 'package:mobility_one/util/my_colors.dart';

enum ActivityStatus {
  SCHEDULED,
  TASK,
  ONGOING,
  OVERDUE,
}

Map<ActivityStatus, dynamic> tags = {
  ActivityStatus.SCHEDULED: {
    'text': 'SCHEDULED',
    'textColor': MyColors.accentColor,
    'backgroundColor': Color(0xFF0B2821)
  },
  ActivityStatus.ONGOING: {
    'text': 'ONGOING',
    'textColor': Color(0xFFF9E213),
    'backgroundColor': Color(0xFF35310B)
  },
  ActivityStatus.TASK: {
    'text': 'TASK',
    'textColor': Color(0xFF0688FF),
    'backgroundColor': Color(0xFF0E183C)
  },
  ActivityStatus.OVERDUE: {
    'text': 'OVERDUE',
    'textColor': Color(0xFFFF2566),
    'backgroundColor': Color(0xFF36101B)
  }
};

class CalendarActivityCard extends StatelessWidget {

  final CalendarActivity activityInfo;

  CalendarActivityCard({required this.activityInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 130,
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(width: 1, color: Color(0xFF585876)),
      ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTag(),
          SizedBox(height: 15,),
          FittedBox(fit: BoxFit.contain,child: Text(activityInfo.description, style: TextStyle(color: Colors.white),)),
          SizedBox(height: 8,),
          FittedBox(fit: BoxFit.contain, child: Text('11.12.2020 / 11:30', style: TextStyle(color: MyColors.cardTextColor),)),
        ],
      ),
    );
  }

  Widget _buildTag() {
    return Container(
      height: 25,
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: tags[activityInfo.status]['backgroundColor']
      ),
      child: Center(
        child: Text(tags[activityInfo.status]['text'], style: TextStyle(color: tags[activityInfo.status]['textColor'], fontSize: 10),),
      ),
    );
  }
}
