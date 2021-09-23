import 'package:mobility_one/ui/widgets/calendar_activity_card.dart';

class CalendarActivity {
  DateTime dateTime;
  ActivityStatus status;
  String description;

  CalendarActivity({required this.dateTime, required this.status, required this.description});
}