import 'package:flutter/material.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/models/time.dart';
import 'package:todo_time_app/models/todo.dart';
import 'package:todo_time_app/widget/hours.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
                colors: [Colors.black, Colors.black87])),
        child: Column(
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height / 5),
              width: MediaQuery.of(context).size.width,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Hello David",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("What are we doing today?",
                            style: TextStyle(
                              fontSize: 18,
                            )),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Center(
                        child: InkWell(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // TOD: Change to GetX
                          Navigator.of(context).push(HeroDialogRoute(
                              builder: (context) => const Center(
                                    child: CardModel(
                                      id: "important",
                                      cardColor: mainColor,
                                    ),
                                  )));
                        },
                        child: Hero(
                          tag: "important",
                          child: Container(
                            height: 150,
                            width: (MediaQuery.of(context).size.width / 2) - 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: mainColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          // TOD: Change to GetX
                          Navigator.of(context).push(HeroDialogRoute(
                              builder: (context) => const Center(
                                    child: CardModel(
                                      id: "unimportant",
                                      cardColor: secColor,
                                    ),
                                  )));
                        },
                        child: Hero(
                          tag: "unimportant",
                          child: Container(
                            height: 150,
                            width: (MediaQuery.of(context).size.width / 2) - 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: secColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      // TOD: Change to GetX
                      Navigator.of(context).push(HeroDialogRoute(
                          builder: (context) => const Center(
                                child: TimeModel(
                                  id: "time",
                                  timeColor: terColor,
                                ),
                              )));
                    },
                    child: SingleChildScrollView(
                      child: SafeArea(
                        child: Hero(
                          tag: "time",
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  height:
                                      (MediaQuery.of(context).size.height) / 2,
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: terColor,
                                  ),
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ListView.builder(
                                        itemCount: 24,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return HourWidget(
                                            task: "TEST",
                                            hour: index,
                                          );
                                        },
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const HomeNavigationBar(),
      resizeToAvoidBottomInset: false,
    );
  }
}

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedItemColor: mainColor,
      type: BottomNavigationBarType.fixed,
    );
  }
}

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: const InkWell(child: Icon(Icons.grid_view_rounded)),
      actions: [
        Container(
            margin: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.orange.shade600,
            ))
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class HeroDialogRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  HeroDialogRoute({
    required WidgetBuilder builder,
    // RouteSettings settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}
