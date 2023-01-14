import 'package:flutter/material.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/widget/hours.dart';

class TimeModel extends StatelessWidget {
  const TimeModel({required this.id, required this.timeColor, super.key});

  final String id;

  final Color timeColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Hero(
          tag: id,
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black54,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: terColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: 24,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return HourWidget(
                          task: "RIGHT",
                          hour: index,
                          txtBgColor: timeColor,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
