import 'package:flutter/material.dart';
import 'package:todo_time_app/constant/vars.dart';

class HourWidget extends StatelessWidget {
  const HourWidget(
      {required this.task,
      required this.hour,
      bool? editable = false,
      super.key});

  final String task;
  final int hour;
  static bool dayTime = true;
  @override
  Widget build(BuildContext context) {
    dayTime = hour >= 12 ? false : true;

    Widget timeText = getHour(dayTime, hour);

    return Stack(
      alignment: const Alignment(0, -0.50),
      children: [
        const Divider(
          color: Colors.white,
          height: 5,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        Column(
          children: [
            SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: timeText,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: DefaultTextStyle(
                    style: const TextStyle(),
                    child: Text(
                      task,
                      style: const TextStyle(
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                )
              ]),
            ),
            Stack(
              children: const [
                Divider(
                  color: Colors.white,
                  // height: 5,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5,
                ),
                // Text(task),
              ],
            )
          ],
        ),
      ],
    );
  }
}

Widget getHour(bool dayTime, int hour) {
  /* 
  * If the hour is 0 then it's midnight
  * if it has less than 2 digits => concat a 0 in front of the hour
  * 
   */

  if (dayTime) {
    return Container(
      padding: const EdgeInsets.only(right: 5, left: 5),
      decoration: const BoxDecoration(
        color: terColor,
      ),
      child: DefaultTextStyle(
        style: const TextStyle(),
        child: Text(
            '${hour == 0 ? 12 : (hour.toString().length < 2 ? '0$hour' : hour)}:00 am'),
      ),
    );
  } else {
    int pmHour = hour - 12;
    return Container(
      padding: const EdgeInsets.only(right: 5, left: 5),
      decoration: const BoxDecoration(
        color: terColor,
      ),
      child: DefaultTextStyle(
        style: const TextStyle(),
        child: Text(
            '${pmHour == 0 ? 12 : pmHour.toString().length < 2 ? '0$pmHour' : pmHour}:00 pm'),
      ),
    );
  }
}
