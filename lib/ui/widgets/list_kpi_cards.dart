import 'package:flutter/material.dart';
import 'package:mobility_one/ui/widgets/kpi_card.dart';
import 'package:mobility_one/util/my_colors.dart';

class ListKpiCards extends StatefulWidget {
  final List<KPICard> kpiCards;
  ListKpiCards({required this.kpiCards});

  @override
  _ListKpiCardsState createState() => _ListKpiCardsState();
}

class _ListKpiCardsState extends State<ListKpiCards> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      buildDefaultDragHandles: false,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          var item = widget.kpiCards.removeAt(oldIndex);
          widget.kpiCards.insert(newIndex, item);
        });
      },
      children: widget.kpiCards
          .map(
            (kpiCard) =>
                Container(
                  key: ValueKey(kpiCard.kpiInfo.title),
                  padding: EdgeInsets.all(16),
                  color: MyColors.backgroundColor,
                  child: ReorderableDragStartListener(
                    index: widget.kpiCards.indexOf(kpiCard),
                    child: kpiCard,
                  ),
                ),
          )
          .toList(),
    );
  }
}
