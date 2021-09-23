import 'package:flutter/material.dart';
import 'package:mobility_one/blocs/vehicle_status_cubit/cubit/vehiclestatus_cubit.dart';
import 'package:mobility_one/ui/widgets/draggable_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomKanban extends StatefulWidget {
  final String title;
  final List<Draggable_custom_card> list;
  CustomKanban({Key? key, required this.title, required this.list})
      : super(key: key);
  @override
  _CustomKanbanState createState() => _CustomKanbanState();
}

class _CustomKanbanState extends State<CustomKanban> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 1,
        ),
        Container(
          height: MediaQuery.of(context).size.height - 240,
          decoration: BoxDecoration(
            color: Colors.blue.shade900,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: 240,
          child: DragTarget<Draggable_custom_card>(
           
            onWillAccept: (data) {
              return data!.list != widget.list;
            },
            onAccept: (data) {
              context
                  .read<VehicleStatusCubit>()
                  .dropOnTarget(data.list, widget.list, data);
            },
            builder: (context, candidates, rejects) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 260,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.list.length,
                          itemBuilder: (context, index) {
                            return draggableCard(index);
                          }),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget draggableCard(int index) {
    return Draggable<Draggable_custom_card>(
      ignoringFeedbackSemantics: false,
      data: widget.list[index],
      feedback: widget.list[index],
      childWhenDragging: Container(
        width: 225,
        height: 120,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[300]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: widget.list[index],
    );
  }
}
