import 'package:flutter/material.dart';
import 'package:todo_time_app/constant/vars.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    this.time,
  super.key});
  final DateTime? time;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
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
        if (index == 0 && currIndex != 0) {
          Navigator.of(context).pushNamed('/home', arguments: widget.time);
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
