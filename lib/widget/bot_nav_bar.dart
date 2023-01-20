import 'package:flutter/material.dart';
import 'package:todo_time_app/constant/vars.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  static int currIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: "Date",
        ),
      ],
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedItemColor: mainColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: currIndex,
      onTap: (int index) {
        print('Current index: $currIndex, Clicked Index: $index');
        if (index == 0 && currIndex != 0) {
          Navigator.of(context).pushNamed('/home');
        }
        if (index == 1 && currIndex != 1) {
          Navigator.of(context).pushNamed('/date');
        }
        currIndex = index;
        setState(() {
          currIndex = index;
        });
      },
    );
  }
}
