import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class CardModel extends StatefulWidget {
  const CardModel(
      {required this.id,
      required this.cardColor,
      required this.localDatabase,
      super.key});

  final String id;

  final Color cardColor;

  final LocalStorage localDatabase;

  @override
  State<CardModel> createState() => _CardModelState();
}

class _CardModelState extends State<CardModel> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.localDatabase.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Hero(
              tag: widget.id,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
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
                            child: ListView.builder(
                              itemCount: 24,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return CardDataWidget(
                                  index: index,
                                  taskText: "TESTING 1 TESTING 1 TESTING 1 ",
                                  editingActive: true,
                                  completed: true,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class CardDataWidget extends StatefulWidget {
  const CardDataWidget({
    Key? key,
    required this.index,
    required this.taskText,
    required this.editingActive,
    required this.completed,
  }) : super(key: key);

  final int index;
  final String taskText;
  final bool editingActive;
  final bool completed;

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
    return DefaultTextStyle(
      style: const TextStyle(),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                            hintText: widget.taskText,
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
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                buttonsFunction(widget.editingActive),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int maxLinesText() {
    if (!widget.editingActive) {
      return 2;
    }
    return 12;
  }

  Widget buttonsFunction(bool canEdit) {
    if (canEdit) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CheckBoxWidget(completed: widget.completed),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              setState(() {
                _controller.text.isEmpty
                    ? _controller.text = widget.taskText
                    : _controller.text = '';

                _textFieldFocus.requestFocus();
                isReadOnly = !isReadOnly;
              });
            },
            child: Icon(
              Icons.edit_note,
              color: !isReadOnly ? Colors.lightBlue : null,
            ),
          )
        ],
      );
    } else {
      return Row();
    }
  }
}

class CheckBoxWidget extends StatefulWidget {
  CheckBoxWidget({
    Key? key,
    required this.completed,
  }) : super(key: key);

  bool completed;
  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Change shape

    return Checkbox(
      value: widget.completed,
      shape: const CircleBorder(),
      activeColor: Colors.green,
      onChanged: (bool? clicked) {
        setState(() {
          widget.completed = clicked!;
        });
      },
    );
  }
}
