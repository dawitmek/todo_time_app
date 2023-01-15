import 'package:flutter/material.dart';

class CardModel extends StatelessWidget {
  const CardModel({required this.id, required this.cardColor, super.key});

  final String id;

  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: id,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black38,
        child: SafeArea(
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
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: 24,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return CardDataWidget(
                            index: index,
                            taskText: "Testing Testing Testing Testing ",
                            editingActive: true,
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
  }
}

class CardDataWidget extends StatefulWidget {
  const CardDataWidget({
    Key? key,
    required this.index,
    required this.taskText,
    required this.editingActive,
  }) : super(key: key);

  final int index;
  final String taskText;
  final bool editingActive;

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
      child: SingleChildScrollView(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("${widget.index + 1}. "),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 34,
                        child: TextField(
                          readOnly: isReadOnly,
                          textAlign: TextAlign.start,
                          controller: _controller,
                          focusNode: _textFieldFocus,
                          decoration: InputDecoration(
                            hintText: widget.taskText,
                            // hintMaxLines: maxLinesText(),
                            contentPadding: const EdgeInsets.all(15),
                            hintStyle: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
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
      return Expanded(
        flex: 1,
        child: Row(
          children: [
            const CheckBoxWidget(),
            InkWell(
              onTap: () {
                // _textFieldFocus.requestFocus();
                setState(() {
                  isReadOnly = !isReadOnly;
                });
              },
              child: const Icon(
                Icons.edit_note,
                color: Colors.amber,
              ),
            )
          ],
        ),
      );
    } else {
      return Row();
    }
  }
}

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool _completed = false;
  @override
  void initState() {
    super.initState();
    _completed = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Change shape

    return Checkbox(
      value: _completed,
      shape: const CircleBorder(),
      activeColor: Colors.green,
      onChanged: (bool? clicked) {
        setState(() {
          _completed = clicked!;
        });
      },
    );
  }
}
