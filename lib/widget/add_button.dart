import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewCardButton extends StatelessWidget {
  const AddNewCardButton({super.key});

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
                              colors: [Colors.yellow.shade900, Colors.yellow]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const NewCardForm(),
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
  const NewCardForm({super.key});

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
                  color: Colors.black,
                  gradient: LinearGradient(
                    colors: [Colors.yellow.shade900, Colors.yellow],
                  ),
                ),
                child: const Center(child: Text("Add a new task")),
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
                hintStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    width: 5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(width: 2),
                ),
                contentPadding: const EdgeInsets.only(right: 20),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
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
                /**
                 * * dropDownValue = importance
                 * * _controller = text/task
                 * * timeToAdd = time to add it on
                 *  */

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
}
