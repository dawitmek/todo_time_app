import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_time_app/models/tasks.dart';

import '../screens/home.dart';

class CardModel extends StatefulWidget {
  const CardModel(
      {required this.id,
      required this.cardColor,
      required this.items,
      required this.storage,
      required this.list,
      super.key});

  final String id;
  final Color cardColor;
  final List<Item> items;
  final LocalStorage storage;
  final CardDataModel list;

  @override
  State<CardModel> createState() => _CardModelState();
}

class _CardModelState extends State<CardModel> {
  StreamController<int> stream = StreamController();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.id,
      child: SafeArea(
        child: Material(
          type: MaterialType.card,
          borderRadius: BorderRadius.circular(16),
          color: Colors.black38,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: checkIfValuesExist(widget.items),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // * Returns a list if there are values. if no values => returns text
  Widget checkIfValuesExist(List<Item> itemList) {
    if (itemList.isNotEmpty) {
      return ListView.builder(
        itemCount: widget.items.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return CardDataWidget(
            index: index,
            editingActive: true,
            storage: widget.storage,
            items: widget.items,
            id: widget.id,
            list: widget.list,
            cardColor: widget.cardColor,
          );
        },
      );
    } else {
      return const Center(
        child: Text(
          'There are no tasks yet.\nAdd a task!',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}

class CardDataWidget extends StatefulWidget {
  const CardDataWidget({
    Key? key,
    required this.index,
    required this.editingActive,
    required this.storage,
    required this.items,
    required this.id,
    required this.list,
    required this.cardColor,
  }) : super(key: key);

  final int index;
  final bool editingActive;
  final LocalStorage storage;
  final List<Item> items;
  final String id;
  final CardDataModel list;
  final Color cardColor;

  @override
  State<CardDataWidget> createState() => _CardDataWidgetState();
}

class _CardDataWidgetState extends State<CardDataWidget> {
  bool isReadOnly = true;

  late TextEditingController _controller;
  late FocusNode _textFieldFocus;

  @override
  void initState() {
    super.initState();
    _textFieldFocus = FocusNode();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Item currItem = widget.items.elementAt(widget.index);

    return DefaultTextStyle(
      style: const TextStyle(),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Row(
              children: [
                Text("${widget.index + 1}. "),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        // height: 34,
                        child: TextField(
                          readOnly: isReadOnly,
                          textAlign: TextAlign.start,
                          controller: _controller,
                          focusNode: _textFieldFocus,
                          decoration: InputDecoration(
                            hintText:
                                widget.items.elementAt(widget.index).taskText,
                            // TODO: Change Max Lines to Dynamic
                            hintMaxLines: 2,
                            contentPadding: const EdgeInsets.all(0),
                            hintStyle: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          onSubmitted: (value) {
                            currItem.taskText = value;
                            setState(() {
                              saveToStorage(widget.id);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // * Shows buttons for the hero screen and not for the
                // * normal card widget
                taskWidgets(widget.editingActive, currItem),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget taskWidgets(bool canEdit, Item currItem) {
    if (canEdit) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: currItem.completed,
            shape: const CircleBorder(),
            activeColor: Colors.green,
            onChanged: (bool? clicked) {
              setState(() {
                currItem.completed = clicked!;
                saveToStorage(widget.id);
              });
            },
          ),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              setState(() {
                _controller.text.isEmpty
                    ? _controller.text = currItem.taskText
                    : _controller.text = '';

                _textFieldFocus.requestFocus();
                isReadOnly = !isReadOnly;
              });
            },
            child: Icon(
              Icons.edit_note,
              color: !isReadOnly ? Colors.lightBlue : null,
            ),
          ),
          InkWell(
            onTap: () {
              removeItem(currItem);
              // ! Ineffecient
              Navigator.of(context).pop();
              Navigator.of(context).push(
                HeroDialogRoute(
                  builder: (context) => Center(
                    child: CardModel(
                      id: widget.id,
                      cardColor: widget.cardColor,
                      items: widget.items,
                      storage: widget.storage,
                      list: widget.list,
                    ),
                  ),
                ),
              );
            },
            splashColor: Colors.red,
            child: const Icon(Icons.clear),
          )
        ],
      );
    } else {
      return Row();
    }
  }

  void removeItem(Item currItem) {
    widget.items.removeAt(widget.items.indexOf(currItem));
    widget.storage.setItem(currItem.taskType, widget.items);
  }

  void saveToStorage(String key) {
    switch (key) {
      case "important":
        widget.storage.setItem(key, widget.list.toListImp());
        break;
      case "unimportant":
        widget.storage.setItem(key, widget.list.toListUnimp());
        break;
      default:
    }
  }
}
