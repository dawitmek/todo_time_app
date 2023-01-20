import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/screens/date_screen.dart';
import 'package:todo_time_app/screens/first_screen.dart';
import 'package:todo_time_app/screens/home.dart';

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    LocalStorage nameStorage = LocalStorage(usernameFile);

    return MaterialApp(
      title: "Todo App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white)),
      home: FutureBuilder(
        future: nameStorage.ready,
        builder: (BuildContext e, AsyncSnapshot snap) {
          String? username = nameStorage.getItem('username');
          if (snap.data != null) {
            if (username == null || username.isEmpty) {
              return const FirstScreen();
            } else {
              return const HomeScreen();
            }
          } else {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      // initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/first': (context) => const FirstScreen(),
        '/date': (context) => const DateScreen(),
      },
    );
  }
}
