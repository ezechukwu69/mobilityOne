import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';

class KPIInfo {
  String title;
  String value;
  double percentage;
  int daysInterval;

  KPIInfo({required this.title, required this.value, required this.percentage, required this.daysInterval});
}

final kCardKpiTitleStyle = TextStyle(
    color: Color(0xFFCECEF4),
    fontSize: 15,
    fontWeight: FontWeight.bold
);

final kCardKpiValueStyle = TextStyle(
  color: Colors.white,
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

final kCardKpiPositivePercentageStyle = TextStyle(
  color: MyColors.accentColor,
  fontSize: 12,
  fontWeight: FontWeight.bold
);

final kCardKpiNegativePercentageStyle = TextStyle(
  color: MyColors.dangerColor,
  fontSize: 12,
  fontWeight: FontWeight.bold
);

final kCardKpiIntervalStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Color(0xFFCECEF4)
);

class KPICard extends StatelessWidget {

  final KPIInfo kpiInfo;

  KPICard({required this.kpiInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: MyColors.backgroundCardColor,
        borderRadius: BorderRadius.all(Radius.circular(19.0693),),
        border: Border.all(color: Color(0xFF3A3A4E), width: 1)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(kpiInfo.title, style: kCardKpiTitleStyle,),
          Text(kpiInfo.value.toString(), style: kCardKpiValueStyle,),
          Image.asset('assets/images/${ kpiInfo.percentage >= 0 ? 'kpiCardPositiveGraph.png' : 'kpiCardNegativeGraph.png'}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_formatPercentage(kpiInfo.percentage), style: kpiInfo.percentage >= 0 ? kCardKpiPositivePercentageStyle : kCardKpiNegativePercentageStyle,),
              SizedBox(width: 10,),
              Text('(${kpiInfo.daysInterval.toString()} days)', style: kCardKpiIntervalStyle,),
            ],
          )
        ],
      ),
    );
  }

  String _formatPercentage(double percentage) {
    if (percentage >= 0) {
      return '+$percentage%';
    } else {
      return '$percentage%';
    }
  }
}
