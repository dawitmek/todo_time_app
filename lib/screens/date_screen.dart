import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/models/tasks.dart';
import 'package:todo_time_app/widget/bot_nav_bar.dart';

class DateScreen extends StatefulWidget {
  const DateScreen({super.key});

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  DateTime current = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
            colors: [Colors.black, Colors.black87],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(28.0),
              child: Text("What's the date you want to display?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
            ),
            Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: mainColor,
                  ),
                ),
                child: CalendarDatePicker(
                  currentDate: current,
                  initialDate: currentTime,
                  firstDate: DateTime(currentTime.year, currentTime.month),
                  lastDate: currentTime,
                  onDateChanged: (DateTime val) {
                    setState(() {
                      current = val;
                    });
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 22, top: 50),
              width: double.infinity,
              child: Builder(builder: (context) {
                LocalStorage file = LocalStorage(
                    'data${current.year}-${current.month}-${current.day}');
                return FutureBuilder(
                    future: file.ready,
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if (snap.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var impItems = file.getItem('important');
                      var unimpItems = file.getItem('unimportant');
                      List<Item> importantItems = [];
                      List<Item> unimportantItems = [];

                      if (impItems != null) {
                        importantItems = List<Item>.from(
                          (impItems as List).map(
                            (item) => Item(
                              taskId: item['taskId'],
                              taskText: item['taskText'],
                              completed: item['completed'],
                            ),
                          ),
                        );
                      }

                      if (unimpItems != null) {
                        unimportantItems = List<Item>.from(
                          (unimpItems as List).map(
                            (item) => Item(
                              taskId: item['taskId'],
                              taskText: item['taskText'],
                              completed: item['completed'],
                            ),
                          ),
                        );
                      }
                      List<Item> allTasks = [
                        ...importantItems,
                        ...unimportantItems
                      ];
                      return Text(
                        '${allTasks.length} ${allTasks.length < 2 ? 'task' : 'tasks'} during that day',
                        style: const TextStyle(fontSize: 20),
                      );
                    });
              }),
            )
          ],
        ),
      ),
      bottomNavigationBar: const HomeNavigationBar(),
      resizeToAvoidBottomInset: false,
    );
  }
}
