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
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  child: const TextField(
                    maxLines: 8,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        hintText: 'Write a note...',
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
