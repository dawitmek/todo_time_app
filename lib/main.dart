import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_time_app/screens/firstScreen.dart';
import 'package:todo_time_app/screens/home.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    LocalStorage storage = LocalStorage('data${DateTime.now().day.toString()}');

    return GetMaterialApp(
      title: "Todo App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white)),
      home: Builder(builder: (e) {
        if (storage.getItem('username') != null) {
          return const FirstScreen();
        } else {
          return const HomeScreen();
        }
      }),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/initial', page: () => const FirstScreen()),
      ],
    );
  }
}
