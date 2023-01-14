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
                          return Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                child: Text("$index. Testing"),
                              ),
                            ],
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
