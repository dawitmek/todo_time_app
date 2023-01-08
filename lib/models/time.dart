import 'package:flutter/material.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/widget/hours.dart';

class TimeModel extends StatelessWidget {
  const TimeModel({required this.id, required this.timeColor, super.key});

  final String id;

  final Color timeColor;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: id,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: mainColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: 24,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return HourWidget(
                            task: "RIGHT",
                            hour: index,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
