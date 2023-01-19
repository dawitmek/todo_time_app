import 'package:flutter/material.dart';
import 'package:todo_time_app/models/tasks.dart';

class HourWidget extends StatelessWidget {
  const HourWidget({
    required this.items,
    required this.hour,
    required this.txtBgColor,
    bool? editable = false,
    super.key,
  });

  final int hour;
  static bool dayTime = true;
  final Color txtBgColor;
  final List<Item?> items;

  // TODO: Refrator usability and effeciency

  @override
  Widget build(BuildContext context) {
    dayTime = hour >= 12 ? false : true;

    Container timeText = getHour(dayTime, hour);

    String? taskHour = '';

    String? task30Min = '';

    for (var item in items) {
      if (item?.time?.hour == hour && item?.time?.minute == 0) {
        taskHour = item?.taskText;
      } else if (item?.time?.hour == hour && item?.time?.minute == 30) {
        task30Min = item?.taskText;
      }
    }

    // if (item?.time?.hour == hour) {}
    return Stack(
      alignment: const Alignment(0, -0.8),
      children: [
        const Divider(
          color: Colors.white,
          height: 10,
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
                        child: checkIfTextEmpty(taskHour),
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
                    // height: 10,
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
                              child: checkIfTextEmpty(task30Min),
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

  Container checkIfTextEmpty(String? taskHour) {
    if (taskHour == '') {
      return Container();
    } else {
      return Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          taskHour ?? '',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  Container getHour(bool dayTime, int hour) {
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
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
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
}
