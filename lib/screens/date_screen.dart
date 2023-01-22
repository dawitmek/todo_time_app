import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/models/tasks.dart';
import 'package:todo_time_app/widget/bot_nav_bar.dart';

class DateScreen extends StatefulWidget {
  const DateScreen({
    this.time,
    super.key,
  });
  final DateTime? time;

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = LocalStorage(dataFile);
    DateTime dateNow = DateTime.now();
    dynamic dateFromStorage = storage.getItem('date');
    DateTime current =
        DateTime.parse(dateFromStorage ?? DateTime.now().toIso8601String());
    return Scaffold(
      body: FutureBuilder(
          future: storage.ready,
          builder: (context, snap) {
            return Container(
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
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500)),
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
                        initialDate: current,
                        firstDate: DateTime(dateNow.year, dateNow.month),
                        lastDate: dateNow,
                        onDateChanged: (DateTime val) {
                          setState(() {
                            current = val;
                            storage.setItem('date', val.toIso8601String());
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
                          '${current.year}-${current.month}-${current.day}');
                      return FutureBuilder(
                          future: file.ready,
                          builder: (BuildContext context, AsyncSnapshot snap) {
                            if (snap.data == null) {
                              return const Center(
                                  child: CircularProgressIndicator());
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
                                    taskType: item['taskType'],
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
                                    taskType: item['taskType'],
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
            );
          }),
      bottomNavigationBar: HomeNavigationBar(time: current),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            current = DateTime.now();
            storage.setItem('date', DateTime.now().toIso8601String());
          });
        },
        backgroundColor: secColor,
        tooltip: "Reset to current day",
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}
