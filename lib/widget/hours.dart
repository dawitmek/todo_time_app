import 'package:flutter/material.dart';

class HourWidget extends StatelessWidget {
  const HourWidget(
      {required this.task,
      required this.hour,
      required this.txtBgColor,
      bool? editable = false,
      super.key});

  final String task;
  final int hour;
  static bool dayTime = true;
  final Color txtBgColor;

  Widget getHour(bool dayTime, int hour) {
    /* 
  * If the hour is 0 then it's midnight
  * if it has less than 2 digits => concat a 0 in front of the hour
  * 
   */

    Container dayOrNight(String txt) {
      return Container(
        padding: const EdgeInsets.only(right: 5, left: 5),
        decoration: BoxDecoration(
          color: txtBgColor,
        ),
        child: DefaultTextStyle(
          style: const TextStyle(),
          child: Text(txt),
        ),
      );
    }

    if (dayTime) {
      return dayOrNight(
        '${hour == 0 ? 12 : (hour.toString().length < 2 ? '0$hour' : hour)}:00 am',
      );
    } else {
      int pmHour = hour - 12;
      return dayOrNight(
        '${pmHour == 0 ? 12 : pmHour.toString().length < 2 ? '0$pmHour' : pmHour}:00 pm',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    dayTime = hour >= 12 ? false : true;

    Widget timeText = getHour(dayTime, hour);

    return Stack(
      alignment: const Alignment(0, -0.8),
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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: timeText,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: DefaultTextStyle(
                        style: const TextStyle(),
                        child: Text(
                          task,
                          style: const TextStyle(
                            backgroundColor: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Stack(
                children: [
                  const Divider(
                    color: Colors.white,
                    // height: 5,
                    thickness: 2,
                    indent: 5,
                    endIndent: 5,
                  ),
                  SingleChildScrollView(
                    // scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 89,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: DefaultTextStyle(
                              style: const TextStyle(),
                              child: Text(
                                task,
                                style: const TextStyle(
                                  backgroundColor: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
