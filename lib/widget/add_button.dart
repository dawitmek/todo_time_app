import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/models/tasks.dart';

class AddNewCardButton extends StatelessWidget {
  const AddNewCardButton({
    required this.storage,
    required this.list,
    super.key,
  });

  final LocalStorage storage;
  final CardDataModel list;

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return SafeArea(
      child: CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        child: Hero(
          tag: "addButton",
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black38,
            textStyle: const TextStyle(
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade800,
                              Colors.grey.shade300
                            ],
                            begin: const Alignment(-2, 0),
                            end: const Alignment(4, 0),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: NewCardForm(storage: storage, list: list),
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

class NewCardForm extends StatefulWidget {
  const NewCardForm({
    required this.storage,
    required this.list,
    super.key,
  });

  final LocalStorage storage;
  final CardDataModel list;

  @override
  State<NewCardForm> createState() => _NewCardFormState();
}

class _NewCardFormState extends State<NewCardForm> {
  late TextEditingController _controller;
  final prefs = SharedPreferences.getInstance();

  List<String> dropDownList = ["Important", "Unimportant"];
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = dropDownList.first;
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeToAdd = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 24, 0);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        margin: const EdgeInsets.all(12),
        width: constraints.maxWidth,
        child: Column(
          children: [
            Center(
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight / 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
                child: const Center(
                  child: Text(
                    "Add a new task",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Divider(
                color: Colors.red,
                thickness: 2,
              ),
            ),
            SingleChildScrollView(
              child: DropdownButton<String>(
                isExpanded: true,
                // itemHeight: null,
                dropdownColor: Colors.black,
                items: dropDownList.map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Center(child: Text(val)),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                value: dropdownValue,
              ),
            ),
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter task',
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    width: 5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    width: 2,
                    color: mainColor,
                  ),
                ),
                contentPadding: const EdgeInsets.only(right: 20),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              // TODO: Give option for time or not
              child: CupertinoDatePicker(
                initialDateTime: DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day, 24, 0),
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false,
                minuteInterval: 30,
                onDateTimeChanged: (DateTime newTime) {
                  timeToAdd = newTime;
                },
              ),
            ),
            InkWell(
              onTap: () {
                addTodoAndSave(timeToAdd);

                Navigator.of(context).pop();
              },
              child: Container(
                width: constraints.maxWidth,
                height: 30,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text("Add New Task")),
              ),
            )
          ],
        ),
      );
    });
  }

  void addTodoAndSave(DateTime timeToAdd) {
    /**
     * * dropDownValue = importance
     * * _controller = text/task
     * * timeToAdd = time to add it on
     *  */

    widget.storage.clear();
    final item = Item(
      taskId: DateTime.now().microsecondsSinceEpoch.toString(),
      taskText: _controller.text,
      completed: false,
      // time: timeToAdd,
    );

    print(item);

    if (dropdownValue == 'Important') {
      widget.list.importantItems.add(item);
      widget.storage.setItem('important', widget.list.toListImp());
    } else {
      widget.list.unimportantItems.add(item);
      widget.storage.setItem('unimportant', widget.list.toListUnimp());
    }
  }
}
