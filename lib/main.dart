import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_time_app/api/noti_api.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/screens/date_screen.dart';
import 'package:todo_time_app/screens/first_screen.dart';
import 'package:todo_time_app/screens/home.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const Main());
  FlutterNativeSplash.remove();
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();

    NotificationApi.init(initScheduled: true);
    listenNotis();
  }

  void listenNotis() => NotificationApi.onNotis.stream.listen((event) {});

  void onClickedNoti(String? payload) => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return payload != null
                ? HomeScreen(time: DateTime.parse(payload))
                : const HomeScreen();
          },
        ),
      );

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
        // '/home': (context) => const HomeScreen(),
        '/first': (context) => const FirstScreen(),
        '/date': (context) => const DateScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final time = settings.arguments;
          return MaterialPageRoute(
            builder: (context) {
              return HomeScreen(
                time: time != null ? time as DateTime : null,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
