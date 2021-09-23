import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobility_one/models/dropdown_option.dart';
import 'package:mobility_one/ui/widgets/dropdown_menu.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/util.dart';

enum GraphType { LINE, PIZZA, BAR }

class GraphCard extends StatefulWidget {
  final String title;
  final List<DropDownOption> dropDownMenuOptions;
  final GraphType chartType;

  GraphCard({required this.title, required this.chartType, this.dropDownMenuOptions = const []});

  @override
  _GraphCardState createState() => _GraphCardState();
}

class _GraphCardState extends State<GraphCard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth <= Util.smallScreenWidth;

        return Container(
          height: 376,
          width: 1130,
          decoration: BoxDecoration(
            color: MyColors.backgroundCardColor,
            borderRadius: BorderRadius.all(Radius.circular(30),),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 30, right: 34, bottom: 26, left: 37),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Spacer(),
                    DropDownMenu(
                      dropDownMenuOptions: widget.dropDownMenuOptions,
                      onSelection: (value) {
                        print('changed value $value');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 64,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        child: LineChart(
                          sampleData1(isSmallScreen),
                          swapAnimationDuration: Duration(milliseconds: 150), // Optional
                          swapAnimationCurve: Curves.linear, // Optional
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  LineChartData sampleData1(bool isSmallScreen) {

    const leftDataLabels = ['2k', '4k', '8k', '12k'];
    const bottomDataLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Color(0xFF15D7A8).withOpacity(0.099),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          rotateAngle: isSmallScreen ? -90 : 0,
          margin: 10,
          getTitles: (value) {
            final index = value.toInt();
            if (index == 0 || index > 12) return '';
            return bottomDataLabels[index - 1];
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            final index = value.toInt();
            if (index == 0) return '';
            return leftDataLabels[index - 1];
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 14,
      maxY: 4,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 1.5),
        FlSpot(5, 1.4),
        FlSpot(7, 3.4),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
      ],
      isCurved: true,
      colors: [
        const Color(0xFF15D7A8),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradientFrom: Offset(0.3, 0.9),
        gradientTo: Offset(0, 1),
        colors: [
          ColorTween(begin:Color(0xFF15D7A8), end: Colors.black)
              .lerp(0.2)!
              .withOpacity(0.1),
          ColorTween(begin: Color(0xFF15D7A8), end: Colors.black)
              .lerp(0.4)!
              .withOpacity(0.1),
        ]
      ),
    );

    return [
      lineChartBarData1,
    ];
  }
}
