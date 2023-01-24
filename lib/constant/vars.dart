import 'package:flutter/material.dart';

const Color mainColor = Colors.orange;

const Color secColor = Colors.redAccent;

const Color terColor = Color.fromARGB(255, 216, 153, 59);

const String usernameFile = "name";

DateTime timeNow = DateTime.now();

String dataFile =
    '${validateLength(timeNow.year)}-${validateLength(timeNow.month)}-${validateLength(timeNow.day)}';

String validateLength(int time) {
  String str = time.toString();
  if (str.length < 2) {
    return '0$str';
  } else {
    return str;
  }
}
