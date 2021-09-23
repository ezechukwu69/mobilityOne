import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class Draggable_custom_card extends StatelessWidget {
  final int status;
  final String name;
  final String vehicle;
  final String distance;
  final List<Draggable_custom_card> list;

  const Draggable_custom_card({Key? key, required this.status,required  this.name,required  this.vehicle,required  this.distance, required this.list}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return cardContainer();
  }

  Widget cardContainer() {
    return Container(
      width: 225,
      height: 120,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 110,
                margin: EdgeInsets.only(bottom: 10, top: 7),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal,decoration: TextDecoration.none),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.car_rental),
                  Text(
                    vehicle,
                    style: MyTextStyles.draggablecardtext,
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  status == 1
                      ? Icon(Icons.tag_faces_outlined)
                      : status == 2
                          ? Icon(Icons.report_gmailerrorred_rounded)
                          : Icon(Icons.dangerous),
                  Text(
                    distance,
                    style: MyTextStyles.draggablecardtext,
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 10, bottom: 10, right: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      side: BorderSide(color: Colors.grey, width: 2),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {},
                    child: Text('...'),
                  ),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
